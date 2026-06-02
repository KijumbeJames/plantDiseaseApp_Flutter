import 'package:flutter/material.dart';

@immutable
class AppColors {
  final Color bgTop;
  final Color bgBottom;
  final Color surface;
  final Color surface2;
  final Color stroke;
  final Color ink;
  final Color muted;
  final Color brand;
  final Color brandDark;

  const AppColors({
    required this.bgTop,
    required this.bgBottom,
    required this.surface,
    required this.surface2,
    required this.stroke,
    required this.ink,
    required this.muted,
    required this.brand,
    required this.brandDark,
  });

  static const dark = AppColors(
    bgTop: Color(0xFF07121F),
    bgBottom: Color(0xFF0D1B2A),
    surface: Color(0xFF0F2130),
    surface2: Color(0xFF111F2E),
    stroke: Color(0x1AFFFFFF),
    ink: Color(0xFFEAF2FF),
    muted: Color(0xFF8FB0C3),
    brand: Color(0xFF22C55E),
    brandDark: Color(0xFF166534),
  );

  static const light = AppColors(
    bgTop: Color(0xFFF7FAF8),
    bgBottom: Color(0xFFEEF6F0),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF4F7F5),
    stroke: Color(0x1F0F172A),
    ink: Color(0xFF0F172A),
    muted: Color(0xFF475569),
    brand: Color(0xFF22C55E),
    brandDark: Color(0xFF166534),
  );

  static AppColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}

