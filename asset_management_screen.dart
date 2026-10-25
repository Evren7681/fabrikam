import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/asset_model.dart';
import 'asset_profile_screen.dart';

class AssetManagementScreen extends StatefulWidget {
  const AssetManagementScreen({super.key});

  @override
  State<AssetManagementScreen> createState() => _AssetManagementScreenState();
}

class _AssetManagementScreenState extends State<AssetManagementScreen> {
  final List<AssetModel> _assets = [
    AssetModel(id: '1', code: 'PRS-01', name: "1 No'lu Hidrolik Pres (630T)", location: 'Pres Hattı', criticality: 'A', technicalSpecs: {'motor_kw': 45}),
    AssetModel(id: '2', code: 'PRS-02', name: "2 No'lu Eksantrik Pres (250T)", location: 'Pres Hattı', criticality: 'B', technicalSpecs: {'motor_kw': 30}),
    AssetModel(id: '3', code: 'PRS-03', name: "3 No'lu Çift Tesirli Pres (400T)", location: 'Pres Hattı', criticality: 'A', technicalSpecs: {'motor_kw': 37}),
    AssetModel(id: '4', code: 'FRN-01', name: 'Tünel Fırın Ana Yanma Odası', location: 'Fırın Bölümü', criticality: 'A'),
    AssetModel(id: '5', code: 'FRN-02', name: 'Ön Isıtma ve Kurutma Fırını', location: 'Fırın Bölümü', criticality: 'B'),
    AssetModel(id: '6', code: 'MIX-01', name: 'Hammadde Mikseri 500L', location: 'Hazırlık Hattı', criticality: 'A', technicalSpecs: {'motor_kw': 55}),
    AssetModel(id: '8', code: 'CNV-01', name: 'Çıkış Rulolu Konveyör', location: 'Paketleme', criticality: 'C', technicalSpecs: {'motor_kw': 5.5}),
    AssetModel(id: '10', code: 'KOM-01', name: 'Vidalı Kompresör Ünitesi 7.5 Bar', location: 'Kompresör Dairesi', criticality: 'A', technicalSpecs: {'motor_kw': 75}),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assets.length,
        itemBuilder: (context, index) {
          final asset = _assets[index];
          final isCritical = asset.criticality == 'A';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Material(
              color: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {
                  // Doğrudan Makine Sicil Kartına Geçiş
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AssetProfileScreen(asset: asset),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: isCritical ? Colors.red.shade100 : const Color(0xFFF1F5F9),
                        child: Text(
                          asset.criticality,
                          style: TextStyle(
                            color: isCritical ? Colors.red.shade900 : const Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(4)),
                                  child: Text(asset.code, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ),
                                const SizedBox(width: 8),
                                Text(asset.location, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(asset.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 2),
                            const Text('Sicil Kartı & Vardiya Geçmişi İçin Dokunun', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
