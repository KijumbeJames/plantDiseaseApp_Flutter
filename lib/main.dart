import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(_ThemePrefs.key);
  final initialMode = _ThemePrefs.fromString(stored);
  runApp(PlantDiseaseApp(initialThemeMode: initialMode));
}

class PlantDiseaseApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  const PlantDiseaseApp({super.key, required this.initialThemeMode});

  static ThemeMode themeModeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<_PlantDiseaseAppState>();
    assert(state != null, 'PlantDiseaseApp state not found in context');
    return state!._themeMode;
  }

  static Future<void> setThemeMode(BuildContext context, ThemeMode mode) async {
    final state = context.findAncestorStateOfType<_PlantDiseaseAppState>();
    assert(state != null, 'PlantDiseaseApp state not found in context');
    await state!._setThemeMode(mode);
  }

  @override
  State<PlantDiseaseApp> createState() => _PlantDiseaseAppState();
}

class _PlantDiseaseAppState extends State<PlantDiseaseApp> {
  static const _seed = Color(0xFF22C55E);

  late ThemeMode _themeMode = widget.initialThemeMode;

  Future<void> _setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ThemePrefs.key, _ThemePrefs.toStringValue(mode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeafScan TZ',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFF0D1B2A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _seed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light),
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFFF7FAF8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF166534),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _ThemePrefs {
  static const key = 'themeMode';

  static ThemeMode fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      case null:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static String toStringValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}