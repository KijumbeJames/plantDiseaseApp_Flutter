import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1F0F),
                    Color(0xFF0D2B14),
                    Color(0xFF0A1628),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.tr('Settings', 'Mipangilio'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Language
                    _sectionTitle(appState.tr('Language', 'Lugha')),
                    const SizedBox(height: 10),
                    _langOption('EN', 'English', '🇬🇧'),
                    const SizedBox(height: 8),
                    _langOption('SW', 'Kiswahili', '🇹🇿'),

                    const SizedBox(height: 28),

                    // ── Font Style
                    _sectionTitle(
                      appState.tr('Font Style', 'Mtindo wa Maandishi'),
                    ),
                    const SizedBox(height: 10),
                    _fontOption('Outfit', GoogleFonts.outfit),
                    const SizedBox(height: 8),
                    _fontOption('Poppins', GoogleFonts.poppins),
                    const SizedBox(height: 8),
                    _fontOption('Inter', GoogleFonts.inter),
                    const SizedBox(height: 8),
                    _fontOption('DM Sans', GoogleFonts.dmSans),
                    const SizedBox(height: 8),
                    _fontOption('Nunito', GoogleFonts.nunito),

                    const SizedBox(height: 28),

                    // ── App Info
                    _sectionTitle(appState.tr('App Info', 'Kuhusu App')),
                    const SizedBox(height: 10),
                    _infoTile(
                      Icons.info_outline_rounded,
                      appState.tr('Version', 'Toleo'),
                      '1.0.0',
                    ),
                    const SizedBox(height: 8),
                    _infoTile(
                      Icons.memory_rounded,
                      appState.tr('Model', 'Modeli'),
                      'EfficientNet-Lite0',
                    ),
                    const SizedBox(height: 8),
                    _infoTile(
                      Icons.category_rounded,
                      appState.tr('Classes', 'Madarasa'),
                      '19',
                    ),
                    const SizedBox(height: 8),
                    _infoTile(
                      Icons.offline_bolt_rounded,
                      appState.tr('Mode', 'Hali'),
                      appState.tr('100% Offline', '100% Bila Mtandao'),
                    ),

                    const SizedBox(height: 28),

                    // ── About
                    _sectionTitle(appState.tr('About', 'Habari')),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        appState.tr(
                          'LeafScan TZ is an AI-powered plant disease detection app for Cassava and Maize crops. Built for smallholder farmers in Tanzania. Works 100% offline.',
                          'LeafScan TZ ni programu ya AI ya kutambua magonjwa ya muhogo na mahindi. Imetengenezwa kwa wakulima wadogo Tanzania. Inafanya kazi bila mtandao.',
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.6),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.35),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _langOption(String code, String name, String flag) {
    final selected = appState.lang == code;
    return GestureDetector(
      onTap: () => appState.setLang(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF22C55E).withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF22C55E).withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.08),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF22C55E),
                      size: 20,
                      key: ValueKey('check'),
                    )
                  : Container(
                      key: const ValueKey('empty'),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fontOption(
    String name,
    TextStyle Function({TextStyle? textStyle}) fontFn,
  ) {
    final selected = appState.fontFamily == name;
    final previewStyle = fontFn(
      textStyle: const TextStyle(fontSize: 13, color: Colors.white54),
    );
    final nameStyle = fontFn(
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );

    return GestureDetector(
      onTap: () => appState.setFont(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF22C55E).withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF22C55E).withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.08),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: nameStyle),
                  const SizedBox(height: 4),
                  Text('The quick brown fox jumps', style: previewStyle),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF22C55E),
                      size: 20,
                      key: ValueKey('chk'),
                    )
                  : Container(
                      key: const ValueKey('emp'),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF22C55E), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}
