// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const SkinCareModalApp(),
    ),
  );
}

class SkinCareModalApp extends StatelessWidget {
  const SkinCareModalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aura SkinCare',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4332)),
      ),
      home: const MainScreen(),
    );
  }
}
