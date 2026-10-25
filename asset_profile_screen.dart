import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../../shift_handover/shift_log_model.dart';

class AssetProfileScreen extends StatelessWidget {
  final AssetModel asset;

  const AssetProfileScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final isCritical = asset.criticality == 'A';

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          title: Text('${asset.code} SİCİL KARTI', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.amberAccent,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amberAccent,
            tabs: [
              Tab(icon: Icon(Icons.info_outline, size: 20), text: 'Künye & Teknik'),
              Tab(icon: Icon(Icons.history, size: 20), text: 'Arıza Geçmişi'),
              Tab(icon: Icon(Icons.menu_book, size: 20), text: 'Vardiya Notları'),
              Tab(icon: Icon(Icons.settings_input_component, size: 20), text: 'Değişen Parçalar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // SEKME 1: KÜNYE & TEKNİK VERİLER
            _buildTechnicalCard(asset, isCritical),

            // SEKME 2: ARIZA GEÇMİŞİ & KÖK NEDEN (5-WHY)
            _buildFailureHistoryList(),

            // SEKME 3: DİJİTAL VARDIYA DEFTERİ NOTLARI
            _buildShiftNotesTab(),

            // SEKME 4: DEĞİŞEN YEDEK PARÇALAR
            _buildPartsUsedList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalCard(AssetModel a, bool isCritical) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(a.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCritical ? Colors.red.shade100 : Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Kritiklik: ${a.criticality}', style: TextStyle(fontWeight: FontWeight.bold, color: isCritical ? Colors.red.shade900 : Colors.blueGrey.shade900)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Lokasyon: ${a.location} | Ekipman Kodu: ${a.code}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              const Divider(height: 24),
              const Text('Teknik Parametreler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              _techRow('Motor Gücü', '${a.technicalSpecs['motor_kw'] ?? 45} kW'),
              _techRow('Maksimum Çalışma Basıncı', '210 Bar'),
              _techRow('Yağ Deposu Hacmi', '600 Litre (Shell Tellus S2 MX 46)'),
              _techRow('Devreye Alınma Tarihi', 'Mart 2021'),
              _techRow('Periyodik Bakım Aralığı', 'Her 500 Çalışma Saati'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _techRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFailureHistoryList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _failureCard(
          date: '24 Gün Önce',
          title: 'Hidrolik Basınç Düşüşü (Koç İnmiyor)',
          duration: '125 dk',
          technician: 'Ahmet Yılmaz (Mekanik)',
          solution: 'Oransal valf sökülüp temizlendi, yüksek basınç filtresi yenisiyle değiştirildi.',
          fiveWhy: 'Pres baskı yapamadı -> Basınç 120 bar altındaydı -> Valfte çapak birikmiş -> Filtre baypas açmış -> Değişim periyodu gecikmiş.',
        ),
        _failureCard(
          date: '42 Gün Önce',
          title: 'Ana Pompa Şaft Keçesi Yağ Sızıntısı',
          duration: '60 dk',
          technician: 'Ahmet Yılmaz (Mekanik)',
          solution: '80x100x10 Viton keçe yenilendi, yağ seviyesi 40L eklendi.',
          fiveWhy: 'Alt tavaya yağ aktı -> Pompa şaftından damlama vardı -> Keçe dudağı aşınmış -> Yüksek sıcaklık sertleşme yapmış.',
        ),
      ],
    );
  }

  Widget _failureCard({
    required String date,
    required String title,
    required String duration,
    required String technician,
    required String solution,
    required String fiveWhy,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                  child: Text(duration, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('$date • Müdahale: $technician', style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
              child: Text('Çözüm: $solution', style: TextStyle(fontSize: 12, color: Colors.green.shade900, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 6),
            Text('5-Why Kök Neden: $fiveWhy', style: const TextStyle(fontSize: 11, color: Colors.black87, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftNotesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('3. Vardiya (24:00 - 08:00)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                    Text('Bugün 07:45', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Operatör: Ali Kaya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                const Text('4200 baskı yapıldı. Kalıp sıcaklığı stabil kaldı.', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.amber.shade300)),
                  child: const Text('Vardiya Uyarısı: Valf bloğunda hafif yağ terlemesi var, takip edilsin.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9A3412))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPartsUsedList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _partItem('FLT-HYD-10U', 'Yüksek Basınç Yağ Filtresi 10 Mikron', '1 Adet', '24 Gün Önce'),
        _partItem('PMP-SL-01', 'Hidrolik Pompa Şaft Keçesi (Viton)', '1 Adet', '42 Gün Önce'),
        _partItem('OIL-ISO-46', 'Shell Tellus S2 MX 46 Hidrolik Yağ', '40 Litre', '42 Gün Önce'),
        _partItem('VLF-NG6-24V', 'Yön Kontrol Valfi Rexroth 24V', '1 Adet', '75 Gün Önce'),
      ],
    );
  }

  static Widget _partItem(String code, String name, String qty, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.settings_input_component, color: Color(0xFF0F172A)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('Parça Kodu: $code • $date', style: const TextStyle(fontSize: 11)),
        trailing: Text(qty, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0369A1))),
      ),
    );
  }
}
