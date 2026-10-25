import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'assets/presentation/asset_management_screen.dart';
import 'work_orders/presentation/quick_report_screen.dart';
import 'analytics/manager_kpi_dashboard_screen.dart';
import 'checklists/autonomous_checklist_screen.dart';
import 'shift_handover/shift_handover_screen.dart';

enum AppUserRole { operator, technician, supervisor }

class MainLayoutScreen extends StatefulWidget {
  final AppUserRole currentUserRole;
  final String userName;

  const MainLayoutScreen({
    super.key,
    this.currentUserRole = AppUserRole.supervisor,
    this.userName = 'Bakım Sorumlusu',
  });

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ManagerKpiDashboardScreen(),       // 0: KPI & Pareto Panel
    const AssetManagementScreen(),          // 1: Makineler & Sicil Kartları
    const ShiftHandoverScreen(),            // 2: Dijital Vardiya Defteri
    const AutonomousChecklistScreen(         // 3: Otonom Bakım
      assetCode: 'PRS-01',
      assetName: "1 No'lu Hidrolik Pres",
    ),
  ];

  void _openQuickReport() {
    HapticFeedback.heavyImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuickReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
              widget.currentUserRole == AppUserRole.supervisor ? 'Bakım Müdürü / Yönetici' : 'Operatör / Teknisyen',
              style: const TextStyle(fontSize: 11, color: Colors.amberAccent),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_rounded, color: Colors.amberAccent, size: 28),
            tooltip: 'Arıza Bildir',
            onPressed: _openQuickReport,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 66,
        height: 66,
        child: FloatingActionButton(
          onPressed: _openQuickReport,
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          elevation: 6,
          tooltip: 'Arıza Kaydı Aç',
          child: const Icon(Icons.add, size: 36),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.analytics_rounded, size: 28, color: _currentIndex == 0 ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)),
              tooltip: 'KPI Panel',
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: Icon(Icons.precision_manufacturing_rounded, size: 28, color: _currentIndex == 1 ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)),
              tooltip: 'Makineler & Sicil',
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 48), // FAB Boşluğu
            IconButton(
              icon: Icon(Icons.menu_book_rounded, size: 28, color: _currentIndex == 2 ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)),
              tooltip: 'Vardiya Defteri',
              onPressed: () => setState(() => _currentIndex = 2),
            ),
            IconButton(
              icon: Icon(Icons.fact_check_rounded, size: 28, color: _currentIndex == 3 ? const Color(0xFF0F172A) : const Color(0xFF94A3B8)),
              tooltip: 'Otonom Bakım',
              onPressed: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}
