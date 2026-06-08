import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'home_screen.dart';
import '../services/app_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _hexCtrl;
  late AnimationController _floatCtrl;

  late Animation<double> _bgFade;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _subSlide;
  late Animation<double> _subFade;
  late Animation<Offset> _btnSlide;
  late Animation<double> _btnFade;
  late Animation<double> _glowPulse;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _hexCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    )..repeat();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    _bgFade = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterCtrl,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _iconFade = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _masterCtrl,
            curve: const Interval(0.3, 0.65, curve: Curves.easeOutCubic),
          ),
        );
    _titleFade = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );

    _subSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _masterCtrl,
            curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
          ),
        );
    _subFade = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.45, 0.72, curve: Curves.easeOut),
    );

    _btnSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _masterCtrl,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _btnFade = CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.6, 0.95, curve: Curves.easeOut),
    );

    _glowPulse = Tween<double>(
      begin: 0.25,
      end: 0.65,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _floatAnim = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _masterCtrl.forward();
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _glowCtrl.dispose();
    _hexCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim, child) =>
            FadeTransition(opacity: anim, child: const HomeScreen()),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFF071A0E),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── 1. Background photo
            FadeTransition(
              opacity: _bgFade,
              child: Image.asset(
                'assets/images/welcome_screen.png',
                fit: BoxFit.cover,
              ),
            ),

            // ── 2. Layered dark overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x77071A0E),
                    Color(0xAA071A0E),
                    Color(0xEE071A0E),
                    Color(0xFF071A0E),
                  ],
                  stops: [0.0, 0.3, 0.65, 1.0],
                ),
              ),
            ),

            // ── 3. Subtle blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              child: Container(color: Colors.transparent),
            ),

            // ── 4. Hex AI network full screen
            AnimatedBuilder(
              animation: _hexCtrl,
              builder: (context, child) => CustomPaint(
                painter: _HexNetworkPainter(_hexCtrl.value),
                size: Size.infinite,
              ),
            ),

            // ── 5. Radial glow behind icon
            AnimatedBuilder(
              animation: _glowPulse,
              builder: (context, child) => Positioned(
                top: size.height * 0.18,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color.fromRGBO(34, 197, 94, _glowPulse.value * 0.22),
                          Color.fromRGBO(22, 101, 52, _glowPulse.value * 0.12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 6. Floating plant icon
            Positioned(
              top: size.height * 0.14,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _floatAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: child,
                ),
                child: ScaleTransition(
                  scale: _iconScale,
                  child: FadeTransition(
                    opacity: _iconFade,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _glowPulse,
                        builder: (context, child) => Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF14532D), Color(0xFF22C55E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(
                                0xFF22C55E,
                              ).withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(
                                  34,
                                  197,
                                  94,
                                  _glowPulse.value * 0.7,
                                ),
                                blurRadius: 40,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.yard_rounded,
                            size: 46,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 7. Main content bottom half
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language toggle
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () => appState.setLang(
                            appState.lang == 'EN' ? 'SW' : 'EN',
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.language_rounded,
                                  color: Colors.white70,
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  appState.lang,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 5),

                    // Title
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF22C55E,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0xFF22C55E,
                                  ).withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                appState.tr('AI POWERED', 'NGUVU YA AI'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF22C55E),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              appState.tr(
                                'AI Plant\nDisease\nDetection',
                                'Utambuzi wa\nMagonjwa\nkwa AI',
                              ),
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    SlideTransition(
                      position: _subSlide,
                      child: FadeTransition(
                        opacity: _subFade,
                        child: Text(
                          appState.tr(
                            'Detect Cassava & Maize diseases\ninstantly using Artificial Intelligence.\nNo internet required.',
                            'Gundua magonjwa ya Muhogo na\nMahindi kwa Akili Bandia.\nHaihitaji mtandao.',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.5),
                            height: 1.7,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // GET STARTED button
                    SlideTransition(
                      position: _btnSlide,
                      child: FadeTransition(
                        opacity: _btnFade,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF166534),
                                      Color(0xFF22C55E),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF22C55E,
                                      ).withValues(alpha: 0.45),
                                      blurRadius: 24,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _goHome,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        appState.tr('GET STARTED', 'ANZA SASA'),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.18,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Three feature dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _featureDot(
                                  Icons.offline_bolt_rounded,
                                  appState.tr('Offline', 'Bila Mtandao'),
                                ),
                                _divider(),
                                _featureDot(
                                  Icons.psychology_rounded,
                                  appState.tr('AI Powered', 'Nguvu ya AI'),
                                ),
                                _divider(),
                                _featureDot(
                                  Icons.bolt_rounded,
                                  appState.tr('Instant', 'Haraka'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),
                          ],
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

  Widget _featureDot(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF22C55E)),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── Hex network painter ────────────────────────────────────
class _HexNetworkPainter extends CustomPainter {
  final double progress;
  _HexNetworkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final hexPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    final linePaint = Paint()
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    const hexSize = 38.0;
    const cols = 10;
    const rows = 18;

    final nodes = <Offset>[];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * hexSize * 1.52 + (row % 2 == 1 ? hexSize * 0.76 : 0);
        final y = row * hexSize * 0.88;
        _drawHex(canvas, Offset(x, y), hexSize * 0.42, hexPaint);
        nodes.add(Offset(x, y));
      }
    }

    final rnd = math.Random(77);
    for (int i = 0; i < 20; i++) {
      final a = nodes[rnd.nextInt(nodes.length)];
      final b = nodes[rnd.nextInt(nodes.length)];
      final phase = (progress + i * 0.05) % 1.0;
      final alpha = (math.sin(phase * math.pi * 2) * 0.5 + 0.5) * 0.1;
      linePaint.color = Color.fromRGBO(34, 197, 94, alpha);
      canvas.drawLine(a, b, linePaint);
    }

    for (int i = 0; i < 16; i++) {
      final node = nodes[(i * 11) % nodes.length];
      final phase = (progress + i * 0.063) % 1.0;
      final pulse = math.sin(phase * math.pi * 2) * 0.5 + 0.5;
      nodePaint.color = Color.fromRGBO(34, 197, 94, 0.08 + pulse * 0.22);
      canvas.drawCircle(node, 2.0 + pulse * 2.0, nodePaint);
      nodePaint.color = Color.fromRGBO(74, 222, 128, 0.5 + pulse * 0.5);
      canvas.drawCircle(node, 1.2, nodePaint);
    }
  }

  void _drawHex(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = math.pi / 3 * i;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HexNetworkPainter old) => old.progress != progress;
}
