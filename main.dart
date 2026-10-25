import 'package:flutter/material.dart';
import 'features/main_layout_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FactoryCmmsApp());
}

class FactoryCmmsApp extends StatelessWidget {
  const FactoryCmmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fabrika CMMS - Bakım ve Vardiya Yönetimi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainLayoutScreen(),
    );
  }
}
