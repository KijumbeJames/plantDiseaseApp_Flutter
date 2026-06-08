import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'camera_screen.dart';
import 'results_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import '../services/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFF0D2415),
        extendBody: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Full background photo
            Image.asset('assets/images/welcome_screen.png', fit: BoxFit.cover),

            // ── Dark overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99001A0A),
                    Color(0xBB001A0A),
                    Color(0xF2001A0A),
                  ],
                  stops: [0.0, 0.35, 1.0],
                ),
              ),
            ),

            // ── Plant AI illustration top right
            Positioned(
              top: 55,
              right: -10,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    0,
                    Tween<double>(begin: -6.0, end: 6.0)
                        .animate(
                          CurvedAnimation(
                            parent: _floatController,
                            curve: Curves.easeInOut,
                          ),
                        )
                        .value,
                  ),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) => CustomPaint(
                      size: const Size(200, 240),
                      painter: _PlantAIPainter(_pulseController.value),
                    ),
                  ),
                ),
              ),
            ),

            // ── Screen content
            SafeArea(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _HomeContent(pulseController: _pulseController),
                  const ResultsScreen(),
                  const SettingsScreen(),
                  const ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xDD0D2415),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_rounded, appState.tr('Home', 'Nyumbani')),
            _navItem(1, Icons.eco_rounded, appState.tr('Plants', 'Mimea')),

            // Center scan button
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim, child) => FadeTransition(
                    opacity: anim,
                    child: const CameraScreen(),
                  ),
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              ),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) => Transform.scale(
                  scale: 0.95 + _pulseController.value * 0.1,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF22C55E).withValues(
                            alpha: 0.3 + _pulseController.value * 0.25,
                          ),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.document_scanner_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),

            _navItem(
              2,
              Icons.bar_chart_rounded,
              appState.tr('Insights', 'Takwimu'),
            ),
            _navItem(3, Icons.person_rounded, appState.tr('Profile', 'Wasifu')),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: SizedBox(
        width: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.35),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HOME CONTENT ──────────────────────────────────────────
class _HomeContent extends StatefulWidget {
  final AnimationController pulseController;
  const _HomeContent({required this.pulseController});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late Animation<double> _entranceFade;
  final List<AnimationController> _slideCtrls = [];
  final List<Animation<Offset>> _slides = [];

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );
    _entranceCtrl.forward();

    for (int i = 0; i < 5; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      final anim = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));
      _slideCtrls.add(ctrl);
      _slides.add(anim);
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    for (final c in _slideCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _sw(int i, Widget child) => FadeTransition(
    opacity: _slideCtrls[i],
    child: SlideTransition(position: _slides[i], child: child),
  );

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return appState.tr('Good Morning,', 'Habari za Asubuhi,');
    if (h < 17) return appState.tr('Good Afternoon,', 'Habari za Mchana,');
    return appState.tr('Good Evening,', 'Habari za Jioni,');
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _entranceFade,
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, child) => SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildGreeting(),
              _buildScanCard(),
              _buildCropCards(),
            ],
          ),
        ),
      ),
    );
  }

  // ── TOP BAR
  Widget _buildTopBar() {
    return _sw(
      0,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _iconBtn(Icons.menu_rounded),
            _iconBtn(Icons.notifications_outlined),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
  );

  // ── GREETING
  Widget _buildGreeting() {
    return _sw(
      1,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 140, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white.withValues(alpha: 0.75),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              appState.tr(
                "Let's keep your plants\nhealthy and productive.",
                "Tuendelee kulinda mimea\nyako iwe na afya.",
              ),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.45),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 130),
          ],
        ),
      ),
    );
  }

  // ── SCAN CARD
  Widget _buildScanCard() {
    return _sw(
      2,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim, child) =>
                  FadeTransition(opacity: anim, child: const CameraScreen()),
              transitionDuration: const Duration(milliseconds: 350),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.tr('Scan Your Plant', 'Changanua Mmea Wako'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        appState.tr(
                          'Detect diseases and get AI insights',
                          'Gundua magonjwa na kupata ushauri',
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: widget.pulseController,
                  builder: (context, child) => Transform.scale(
                    scale: 0.95 + widget.pulseController.value * 0.1,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF22C55E,
                            ).withValues(alpha: 0.45),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── CROP CARDS
  Widget _buildCropCards() {
    return _sw(
      3,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appState.tr('Supported Crops', 'Mazao Yanayoungwa'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _cropCard(
              emoji: '🌿',
              name: appState.tr('Cassava', 'Muhogo'),
              sub: 'Cassava',
              tags: ['CMD', 'CBSD', 'CBB', '+2'],
              color: const Color(0xFF4ADE80),
            ),
            const SizedBox(height: 10),
            _cropCard(
              emoji: '🌽',
              name: appState.tr('Maize', 'Mahindi'),
              sub: 'Maize',
              tags: ['NLB', 'FAW', 'GLS', '+11'],
              color: const Color(0xFFFBBF24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cropCard({
    required String emoji,
    required String name,
    required String sub,
    required List<String> tags,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '($sub)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: color.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plant + AI network painter ─────────────────────────────
class _PlantAIPainter extends CustomPainter {
  final double animValue;
  _PlantAIPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final hexPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final linePaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.15)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    final nodes = [
      Offset(size.width * 0.28, size.height * 0.12),
      Offset(size.width * 0.62, size.height * 0.08),
      Offset(size.width * 0.88, size.height * 0.25),
      Offset(size.width * 0.18, size.height * 0.42),
      Offset(size.width * 0.52, size.height * 0.32),
      Offset(size.width * 0.80, size.height * 0.52),
      Offset(size.width * 0.38, size.height * 0.60),
    ];

    for (final o in nodes) {
      _drawHex(canvas, o, 20.0, hexPaint);
    }

    final pairs = [
      [0, 1],
      [1, 2],
      [0, 4],
      [1, 4],
      [2, 5],
      [3, 4],
      [4, 5],
      [4, 6],
    ];
    for (final p in pairs) {
      canvas.drawLine(nodes[p[0]], nodes[p[1]], linePaint);
    }

    for (int i = 0; i < nodes.length; i++) {
      final pulse = math.sin((animValue * math.pi * 2) + i * 0.9) * 0.5 + 0.5;
      nodePaint.color = Color.fromRGBO(34, 197, 94, 0.12 + pulse * 0.3);
      canvas.drawCircle(nodes[i], 3.5 + pulse * 2.5, nodePaint);
      nodePaint.color = Color.fromRGBO(74, 222, 128, 0.55 + pulse * 0.45);
      canvas.drawCircle(nodes[i], 2.0, nodePaint);
    }

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.55)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final stemPath = Path()
      ..moveTo(size.width * 0.42, size.height * 0.98)
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.72,
        size.width * 0.38,
        size.height * 0.52,
        size.width * 0.32,
        size.height * 0.28,
      );
    canvas.drawPath(stemPath, stemPaint);

    _drawLeaf(
      canvas,
      Offset(size.width * 0.32, size.height * 0.28),
      size.width * 0.30,
      -0.5,
      stemPaint,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.38, size.height * 0.50),
      size.width * 0.24,
      0.7,
      stemPaint,
    );
    _drawLeaf(
      canvas,
      Offset(size.width * 0.35, size.height * 0.38),
      size.width * 0.20,
      -0.9,
      stemPaint,
    );
  }

  void _drawLeaf(
    Canvas canvas,
    Offset base,
    double sz,
    double angle,
    Paint strokePaint,
  ) {
    final fillPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, 0)
      ..cubicTo(-sz * 0.5, -sz * 0.4, -sz * 0.85, -sz * 0.85, -sz, -sz * 0.3)
      ..cubicTo(-sz * 0.8, sz * 0.1, -sz * 0.4, sz * 0.05, 0, 0);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
    canvas.restore();
  }

  void _drawHex(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = math.pi / 180 * (60 * i - 30);
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
  bool shouldRepaint(_PlantAIPainter old) => old.animValue != animValue;
}
