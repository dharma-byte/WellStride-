import 'package:flutter/material.dart';

/// Central theme definition for WellStride. Both light and dark variants
/// are generated from a single seed color so the app stays visually
/// consistent across the OS-level theme the user has chosen.
class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF13A089);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      );
}
