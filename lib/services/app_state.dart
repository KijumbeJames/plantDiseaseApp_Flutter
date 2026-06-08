import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppState extends ChangeNotifier {
  String _lang = 'EN';
  String _fontFamily = 'Outfit';

  String get lang => _lang;
  String get fontFamily => _fontFamily;

  void setLang(String lang) {
    _lang = lang;
    notifyListeners();
  }

  void setFont(String font) {
    _fontFamily = font;
    notifyListeners();
  }

  String tr(String en, String sw) => _lang == 'EN' ? en : sw;

  TextTheme getTextTheme() {
    final base = ThemeData.dark().textTheme;
    switch (_fontFamily) {
      case 'Poppins':
        return GoogleFonts.poppinsTextTheme(base);
      case 'Inter':
        return GoogleFonts.interTextTheme(base);
      case 'DM Sans':
        return GoogleFonts.dmSansTextTheme(base);
      case 'Nunito':
        return GoogleFonts.nunitoTextTheme(base);
      case 'Outfit':
      default:
        return GoogleFonts.outfitTextTheme(base);
    }
  }
}

final appState = AppState();
