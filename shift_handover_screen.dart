import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../assets/models/asset_model.dart';
import '../assets/presentation/heavy_duty_asset_selector.dart';
import 'shift_log_model.dart';

class ShiftHandoverScreen extends StatefulWidget {
  final String? preselectedAssetId;
  final String? preselectedAssetCode;

  const ShiftHandoverScreen({
    super.key,
    this.preselectedAssetId,
    this.preselectedAssetCode,
  });

  @override
  State<ShiftHandoverScreen> createState() => _ShiftHandoverScreenState();
}

class _ShiftHandoverScreenState extends State<ShiftHandoverScreen> {
  String _selectedShift = '1. Vardiya (08:00 - 16:00)';
  String _selectedDept = 'Pres Hattı';
  AssetModel? _tiedAsset;

  final TextEditingController _notesCtrl = TextEditingController();
  final TextEditingController _warningCtrl = TextEditingController();
  final TextEditingController _pendingCtrl = TextEditingController();

  final List<AssetModel> _mockAssets = [
    AssetModel(id: '1', code: 'PRS-01', name: "1 No'lu Hidrolik Pres (630T)", location: 'Pres Hattı', criticality: 'A'),
    AssetModel(id: '2', code: 'PRS-02', name: "2 No'lu Eksantrik Pres (250T)", location: 'Pres Hattı', criticality: 'B'),
    AssetModel(id: '4', code: 'FRN-01', name: 'Tünel Fırın Ana Yanma Grubu', location: 'Fırın Bölümü', criticality: 'A'),
    AssetModel(id: '6', code: 'MIX-01', name: 'Hammadde Mikseri 500L', location: 'Hazırlık Hattı', criticality: 'A'),
    AssetModel(id: '10', code: 'KOM-01', name: 'Vidalı Kompresör 7.5 Bar', location: 'Kompresör Dairesi', criticality: 'A'),
  ];

  // Geçmiş Vardiya Notları Havuzu (Makine Siciline de beslenen veriler)
  final List<ShiftLogModel> _logs = [
    ShiftLogModel(
      id: 'sh-01',
      assetId: '1',
      assetCode: 'PRS-01',
      assetName: "1 No'lu Hidrolik Pres (630T)",
      shiftName: '3. Vardiya (24:00 - 08:00)',
      shiftDate: DateTime.now().subtract(const Duration(hours: 3)),
      operatorName: 'Ali Kaya (Pres Operatörü)',
      department: 'Pres Hattı',
      generalNotes: '630T pres ile 4200 adet basım yapıldı. Kalıp sıcaklığı stabil kaldı.',
      criticalWarning: 'Hidrolik ana valf bloğunda hafif terleme başladı, basınç 160 barda tutuldu.',
      pendingIssues: 'Gündüz bakım ekibi vardiya başında valf gövdesini sızıntı için kontrol etsin.',
    ),
    ShiftLogModel(
      id: 'sh-02',
      assetId: '4',
      assetCode: 'FRN-01',
      assetName: 'Tünel Fırın Ana Yanma Grubu',
      shiftName: '2. Vardiya (16:00 - 24:00)',
      shiftDate: DateTime.now().subtract(const Duration(hours: 9)),
      operatorName: 'Murat Şahin (Fırıncı)',
      department: 'Fırın Bölümü',
      generalNotes: 'Fırın 1150°C set değerinde çalıştı. Gaz tüketimi normal.',
      criticalWarning: '3 No brülör ateşleme zamanı 1 sn uzadı.',
      pendingIssues: 'Alev gözleme camının temizliği gerekebilir.',
    ),
  ];

  void _chooseAsset() async {
    final picked = await HeavyDutyAssetSelectorScreen.open(context, _mockAssets);
    if (picked != null) {
      setState(() => _tiedAsset = picked);
    }
  }

  void _saveLog() {
    if (_notesCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen vardiya devir notunu girin.')),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    final newLog = ShiftLogModel(
      id: const Uuid().v4(),
      assetId: _tiedAsset?.id,
      assetCode: _tiedAsset?.code,
      assetName: _tiedAsset?.name,
      shiftName: _selectedShift,
      shiftDate: DateTime.now(),
      operatorName: 'Ali Kaya (Operatör)',
      department: _selectedDept,
      generalNotes: _notesCtrl.text.trim(),
      criticalWarning: _warningCtrl.text.trim().isEmpty ? null : _warningCtrl.text.trim(),
      pendingIssues: _pendingCtrl.text.trim().isEmpty ? null : _pendingCtrl.text.trim(),
    );

    setState(() {
      _logs.insert(0, newLog);
      _notesCtrl.clear();
      _warningCtrl.clear();
      _pendingCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Vardiya devir notu kaydedildi ve Makine Siciline işlendi!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('DİJİTAL VARDIYA DEFTERİ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Vardiya ve Bölüm Bilgi Barı
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Vardiya & Bölüm Bilgisi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedShift,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: [
                            '1. Vardiya (08:00 - 16:00)',
                            '2. Vardiya (16:00 - 24:00)',
                            '3. Vardiya (24:00 - 08:00)',
                          ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (val) => setState(() => _selectedShift = val!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedDept,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: [
                            'Pres Hattı',
                            'Fırın Bölümü',
                            'Hazırlık Hattı',
                            'Paketleme',
                          ].map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (val) => setState(() => _selectedDept = val!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. İsteğe Bağlı Makine Bağlantısı (Elle Seçim)
            Material(
              color: Colors.white,
              elevation: 1,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: _chooseAsset,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.precision_manufacturing, color: Color(0xFF0F172A), size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tiedAsset != null ? '${_tiedAsset!.code} - ${_tiedAsset!.name}' : 'Genel Hat Notu (Belirli bir makineye bağlamak için dokunun)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: _tiedAsset != null ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                              ),
                            ),
                            if (_tiedAsset != null)
                              const Text('Bu not makinenin Sicil Kartı geçmişine otomatik işlenecektir.', style: TextStyle(fontSize: 11, color: Colors.green)),
                          ],
                        ),
                      ),
                      Icon(_tiedAsset != null ? Icons.check_circle : Icons.add_link, color: _tiedAsset != null ? Colors.green : Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Vardiya Defteri Form Girişleri
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Genel Vardiya Özeti & Üretim Durumu *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Örn: Vardiya boyu 4000 pres baskısı alındı. Önemli bir duruş yaşanmadı...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text('2. Kritik Uyarı & Dikkat Edilmesi Gerekenler (Opsiyonel)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _warningCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Örn: Pres oransal valfte yağ terlemesi var, basınç göstergesini sık sık kontrol edin!',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Colors.red.shade50.withOpacity(0.5),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text('3. Sonraki Vardiyaya / Bakıma Devredilen İşler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _pendingCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Örn: Gündüz mekanik bakım ekibi filtre temizliğine gelecek...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _saveLog,
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('DEFTERE KAYDET VE DEVRET', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Son Devir Teslim Kayıtları Listesi
            const Text('SON VARDIYA DEVİR TESLİM KAYITLARI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF475569))),
            const SizedBox(height: 8),

            ..._logs.map((log) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(6)),
                            child: Text(log.shiftName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          Text(log.department, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (log.assetCode != null)
                        Row(
                          children: [
                            const Icon(Icons.precision_manufacturing, size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text('${log.assetCode} - ${log.assetName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0369A1))),
                          ],
                        ),
                      const SizedBox(height: 6),
                      Text(log.generalNotes, style: const TextStyle(fontSize: 13)),
                      if (log.criticalWarning != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.red.shade200)),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('DİKKAT: ${log.criticalWarning!}', style: TextStyle(fontSize: 12, color: Colors.red.shade900, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ],
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Devreden: ${log.operatorName}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                          Text('${log.shiftDate.hour}:${log.shiftDate.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: Colors.black45)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
