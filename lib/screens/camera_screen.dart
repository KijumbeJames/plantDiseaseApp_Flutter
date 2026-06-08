import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'result_screen.dart';
import '../theme/app_colors.dart';

class CameraScreen extends StatefulWidget {
  final bool fromGallery;
  const CameraScreen({super.key, this.fromGallery = false});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _cornerController;

  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _cornerAnim;

  final List<Animation<Offset>> _slideAnims = [];
  final List<AnimationController> _slideControllers = [];

  AppColors get _c => AppColors.of(context);
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    _fadeController.forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCubic),
    );

    _cornerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _cornerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cornerController, curve: Curves.easeInOutCubic),
    );

    for (int i = 0; i < 6; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      final anim = Tween<Offset>(
        begin: const Offset(0, 0.18),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic));
      _slideControllers.add(ctrl);
      _slideAnims.add(anim);
      Future.delayed(Duration(milliseconds: 60 * i), () {
        if (mounted) ctrl.forward();
      });
    }

    if (widget.fromGallery) {
      Future.delayed(const Duration(milliseconds: 400), _pickFromGallery);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _cornerController.dispose();
    for (final c in _slideControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (file != null) {
      setState(() => _selectedImage = File(file.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file != null) {
      setState(() => _selectedImage = File(file.path));
    }
  }

  Future<void> _pickSmart() async {
    if (_selectedImage != null) return;
    if (widget.fromGallery) {
      return _pickFromGallery();
    }
    return _pickFromCamera();
  }

  void _analyzeImage() {
    if (_selectedImage == null) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ResultScreen(imageFile: _selectedImage!),
          );
        },
        transitionsBuilder: (_, animation, _, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  Widget _slideWrap(int index, Widget child) {
    return FadeTransition(
      opacity: _slideControllers[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: _c.bgBottom,
      body: Stack(
        children: [
          _AnimatedBackground(progress: _fadeAnim, isDark: _isDark),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildTopBar(topPad),
                    _buildPreviewArea(),
                    _buildTipsCard(),
                    _buildBottomSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(double topPad) {
    return _slideWrap(
      0,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Row(
          children: [
            _glassIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chagua Picha',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _c.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    'Lenga jani la mmea vizuri',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: _c.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isDark ? const Color(0xFF0F2D1E) : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (_isDark ? Colors.white : _c.ink).withValues(alpha: 0.18),
                  width: 0.4,
                ),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, _) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _c.brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'OFFLINE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _c.brandDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewArea() {
    return _slideWrap(
      1,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedBuilder(
          animation: _cornerAnim,
          builder: (_, _) {
            final color = Color.lerp(
              _c.brand,
              const Color(0xFF4ADE80),
              _cornerAnim.value,
            )!;
            return Material(
              color: _c.surface2,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: _pickSmart,
                child: Container(
                  height: 252,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _c.stroke.withValues(alpha: 0.75),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : _PreviewPlaceholder(pulse: _pulseAnim),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: _corner(color, true, true),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: _corner(color, true, false),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: _corner(color, false, true),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: _corner(color, false, false),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeOutCubic,
                          child: _selectedImage == null
                              ? const SizedBox.shrink()
                              : Container(
                                  key: const ValueKey('badge'),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.40),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.14),
                                      width: 0.6,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.image_rounded,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 6),
                                      Text(
                                        'Picha imechaguliwa',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _corner(Color color, bool top, bool left) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _CornerPainter(color, top, left)),
    );
  }

  Widget _buildTipsCard() {
    return _slideWrap(
      2,
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _isDark ? const Color(0xFF0F2D1E) : const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (_isDark ? Colors.white : _c.ink).withValues(alpha: 0.18),
              width: 0.4,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: _c.brandDark, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hakikisha jani liko wazi · Mwanga wa kutosha · Picha isiyofifia',
                  style: TextStyle(
                    fontSize: 11,
                    color: _c.muted,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _slideWrap(
            3,
            const Text(
              'Chagua Njia',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFFE2E8F0),
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _slideWrap(
            4,
            _actionBtn(
              icon: Icons.camera_alt_rounded,
              title: 'Piga Picha Sasa',
              subtitle: 'Fungua kamera ya simu',
              isSolid: true,
              onTap: _pickFromCamera,
            ),
          ),
          const SizedBox(height: 10),
          _slideWrap(
            5,
            _actionBtn(
              icon: Icons.photo_library_rounded,
              title: 'Chagua Galeri',
              subtitle: 'Chagua picha zilizopo',
              isSolid: false,
              onTap: _pickFromGallery,
            ),
          ),
          if (_selectedImage != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.tonalIcon(
                onPressed: _analyzeImage,
                icon: const Icon(Icons.analytics_rounded, size: 20),
                label: const Text(
                  'Changanua Sasa',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _c.brand,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSolid,
    required VoidCallback onTap,
  }) {
    final bg = isSolid ? _c.brandDark : Colors.transparent;
    final border =
        isSolid ? null : Border.all(color: _c.brandDark, width: 1.6);
    final fg = isSolid ? Colors.white : _c.brand;
    final sub =
        isSolid ? Colors.white.withValues(alpha: 0.65) : _c.muted;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: border,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSolid
                      ? Colors.white.withValues(alpha: 0.16)
                      : (_isDark ? const Color(0xFF0F2D1E) : const Color(0xFFDCFCE7)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: fg, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: fg,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: sub,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: isSolid
                      ? Colors.white.withValues(alpha: 0.55)
                      : _c.brandDark,
                  size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Icon(icon, color: Colors.white.withValues(alpha: 0.75), size: 18),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final bool top;
  final bool left;
  _CornerPainter(this.color, this.top, this.left);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final x = left ? 0.0 : size.width;
    final y = top ? 0.0 : size.height;
    final dx = left ? size.width : -size.width;
    final dy = top ? size.height : -size.height;

    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}

class _AnimatedBackground extends StatelessWidget {
  final Animation<double> progress;
  final bool isDark;
  const _AnimatedBackground({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final t = progress.value;
        final c = AppColors.of(context);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                c.bgTop,
                Color.lerp(
                  c.bgBottom,
                  isDark ? const Color(0xFF0A2534) : const Color(0xFFDCFCE7),
                  t,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Align(
            alignment: const Alignment(0.85, -0.85),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    c.brand.withValues(alpha: isDark ? 0.22 : 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  final Animation<double> pulse;
  const _PreviewPlaceholder({required this.pulse});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: pulse,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F2D1E) : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: (isDark ? Colors.white : c.ink).withValues(alpha: 0.18),
                  width: 0.4,
                ),
              ),
              child: Icon(
                Icons.add_a_photo_rounded,
                color: c.brandDark,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Gusa hapa kuchagua picha',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: c.ink.withValues(alpha: isDark ? 0.78 : 0.85),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Au tumia vitufe vya chini',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              color: c.muted,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}