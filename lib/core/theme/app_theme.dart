// core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.transparent, // مهم نخليه شفاف

    primaryColor: const Color(0xFF1A531A),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A531A),
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // 🎨 الخلفية المتدرجة الجديدة
  static BoxDecoration backgroundGradient = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFFFFFFF), // أبيض
        Color(0xFFF5F1E8), // بيج
        Color(0xFFE8F3EA), // أخضر فاتح
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}