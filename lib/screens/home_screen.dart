import 'package:flutter/material.dart';
import 'camera_screen.dart';
import '../main.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  int _selectedCropIndex = 0;

  AppColors get _c => AppColors.of(context);
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  final List<_Crop> _crops = const [
    _Crop(
      name: 'Muhogo',
      subtitle: 'Cassava',
      icon: Icons.grass_rounded,
      accent: Color(0xFF22C55E),
      tagBg: Color(0xFFDCFCE7),
      tagText: Color(0xFF166534),
      tags: ['CMD', 'CBSD', 'CBB', '+2'],
    ),
    _Crop(
      name: 'Mahindi',
      subtitle: 'Maize',
      icon: Icons.agriculture_rounded,
      accent: Color(0xFFF59E0B),
      tagBg: Color(0xFFFEF3C7),
      tagText: Color(0xFF92400E),
      tags: ['NLB', 'FAW', 'GLS', '+11'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topPad = media.padding.top;
    return Scaffold(
      backgroundColor: _c.bgBottom,
      body: Stack(
        children: [
          _AnimatedBackground(progress: _fade, isDark: _isDark),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 210,
                collapsedHeight: kToolbarHeight + topPad,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeroHeader(context),
                ),
                title: Padding(
                  padding: EdgeInsets.only(top: topPad),
                  child: Text(
                    'LeafScan TZ',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: _c.ink,
                    ),
                  ),
                ),
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slide,
                  child: FadeTransition(
                    opacity: _fade,
                    child: _buildBody(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    final crop = _crops[_selectedCropIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Row(
            children: [
              _pill(
                leading: const _PillDot(color: Color(0xFF22C55E)),
                label: 'OFFLINE READY',
                fg: const Color(0xFF22C55E),
                bg: _isDark ? const Color(0xFF0F2D1E) : const Color(0xFFDCFCE7),
              ),
              const Spacer(),
              _iconGlassButton(
                icon: Icons.info_outline_rounded,
                onTap: () => _showAbout(context),
              ),
              const SizedBox(width: 10),
              _iconGlassButton(
                icon: _isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                onTap: () => _showThemePicker(context),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Hero(
                tag: 'leafscan-mark',
                child: _brandMark(accent: crop.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LeafScan TZ',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: _c.ink,
                        letterSpacing: -0.6,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gundua magonjwa ya mimea haraka\nna bila mtandao',
                      style: TextStyle(
                        fontSize: 13,
                        color: _c.muted.withValues(alpha: _isDark ? 0.75 : 0.85),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        gradient: LinearGradient(
          colors: [
            _c.bgBottom.withValues(alpha: 0.00),
            _c.bgBottom.withValues(alpha: _isDark ? 0.70 : 0.55),
            _c.bgBottom,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.25, 1.0],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Staggered(
            index: 0,
            progress: _fade,
            child: Row(
              children: [
                _statCard('19', 'Magonjwa', Icons.bug_report_rounded),
                const SizedBox(width: 10),
                _statCard('2', 'Mazao', Icons.eco_rounded),
                const SizedBox(width: 10),
                _statCard('100%', 'Offline', Icons.offline_bolt_rounded),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _Staggered(
            index: 1,
            progress: _fade,
            child: _SectionTitle(
              title: 'Mazao Yanayoungwa',
              subtitle: 'Chagua zao kupata mapendekezo sahihi',
            ),
          ),

          const SizedBox(height: 12),

          _Staggered(
            index: 2,
            progress: _fade,
            child: Column(
              children: [
                for (int i = 0; i < _crops.length; i++) ...[
                  _cropCard(
                    crop: _crops[i],
                    selected: i == _selectedCropIndex,
                    onTap: () => setState(() => _selectedCropIndex = i),
                  ),
                  if (i != _crops.length - 1) const SizedBox(height: 10),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          _Staggered(
            index: 3,
            progress: _fade,
            child: _SectionTitle(
              title: 'Anza Uchunguzi',
              subtitle: 'Piga picha au chagua kwenye galeri',
            ),
          ),

          const SizedBox(height: 12),

          _Staggered(
            index: 4,
            progress: _fade,
            child: _actionButton(
              icon: Icons.camera_alt_rounded,
              title: 'Piga Picha',
              subtitle: 'Tumia kamera moja kwa moja',
              isSolid: true,
              onTap: () => _pushCamera(context),
            ),
          ),

          const SizedBox(height: 10),

          _Staggered(
            index: 5,
            progress: _fade,
            child: _actionButton(
              icon: Icons.photo_library_rounded,
              title: 'Chagua Picha',
              subtitle: 'Chagua kutoka kwenye galeri',
              isSolid: false,
              onTap: () => _pushCamera(context, fromGallery: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Expanded(
      child: Material(
        color: _c.surface2,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _c.stroke, width: 0.7),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _c.brandDark.withValues(alpha: _isDark ? 0.18 : 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      color: _c.ink.withValues(alpha: 0.92), size: 18),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: _c.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: _c.muted,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cropCard({
    required _Crop crop,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final shadow = selected
        ? [
            BoxShadow(
              color: crop.accent.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: shadow,
      ),
      child: Material(
        color: _c.surface2,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? crop.accent.withValues(alpha: 0.85) : _c.stroke,
                width: selected ? 1.3 : 0.7,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        crop.accent.withValues(alpha: 0.22),
                        crop.accent.withValues(alpha: 0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: crop.accent.withValues(alpha: 0.30),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(crop.icon,
                      color: Colors.white.withValues(alpha: 0.90), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            crop.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${crop.subtitle})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9FB5C5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeOutCubic,
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: selected
                                ? Icon(Icons.check_circle_rounded,
                                    key: const ValueKey('sel'),
                                    color: crop.accent,
                                    size: 20)
                                : Icon(Icons.circle_outlined,
                                    key: const ValueKey('unsel'),
                                    color: Colors.white.withValues(alpha: 0.25),
                                    size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: crop.tags
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: crop.accent.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: crop.accent.withValues(alpha: 0.22),
                                    width: 0.6,
                                  ),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.85),
                                    letterSpacing: 0.2,
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
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSolid,
    required VoidCallback onTap,
  }) {
    final bg = isSolid ? _c.brandDark : _c.surface;
    final fg = isSolid ? Colors.white : _c.brandDark;
    final sub =
        isSolid ? Colors.white.withValues(alpha: 0.70) : _c.muted.withValues(alpha: 0.9);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: isSolid ? null : Border.all(color: _c.brandDark, width: 1.6),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSolid
                      ? Colors.white.withValues(alpha: 0.16)
                      : const Color(0xFFDCFCE7),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: fg,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: sub,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: isSolid
                      ? Colors.white.withValues(alpha: 0.65)
                      : _c.brandDark,
                  size: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _pushCamera(BuildContext context, {bool fromGallery = false}) {
    final screen =
        fromGallery ? const CameraScreen(fromGallery: true) : const CameraScreen();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: screen,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position:
                Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(
              curved,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        settings: RouteSettings(name: fromGallery ? 'gallery' : 'camera'),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Material(
            color: _c.surface2,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'leafscan-mark',
                        child: _brandMark(accent: _crops[_selectedCropIndex].accent),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LeafScan TZ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                                color: _c.ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Plant disease detection (offline)',
                              style: TextStyle(
                                fontSize: 12,
                                color: _c.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded,
                            color: _c.ink.withValues(alpha: 0.85)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Chagua zao kisha piga picha ya jani. App itaonyesha matokeo na mapendekezo (ukishaongeza model).',
                    style: TextStyle(
                      height: 1.45,
                      color: _c.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: _c.brandDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Sawa'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _pill({
    required Widget leading,
    required String label,
    required Color fg,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconGlassButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: (_isDark ? Colors.white : _c.ink).withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (_isDark ? Colors.white : _c.ink).withValues(alpha: 0.10),
            ),
          ),
          child: Icon(icon, color: _c.ink.withValues(alpha: 0.70), size: 19),
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final c = AppColors.of(context);
        final mode = PlantDiseaseApp.themeModeOf(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Material(
            color: c.surface2,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: c.stroke.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mwonekano',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: c.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: mode,
                    onChanged: (v) =>
                        PlantDiseaseApp.setThemeMode(context, v ?? ThemeMode.system),
                    title: Text('System', style: TextStyle(color: c.ink)),
                    activeColor: c.brand,
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: mode,
                    onChanged: (v) =>
                        PlantDiseaseApp.setThemeMode(context, v ?? ThemeMode.dark),
                    title: Text('Dark', style: TextStyle(color: c.ink)),
                    activeColor: c.brand,
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: mode,
                    onChanged: (v) =>
                        PlantDiseaseApp.setThemeMode(context, v ?? ThemeMode.light),
                    title: Text('Light', style: TextStyle(color: c.ink)),
                    activeColor: c.brand,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _brandMark({required Color accent}) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.95),
            const Color(0xFF22C55E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.yard_rounded, size: 30, color: Colors.white),
    );
  }
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
              stops: const [0.0, 1.0],
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

class _PillDot extends StatelessWidget {
  final Color color;
  const _PillDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: c.ink,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: c.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.tune_rounded, color: c.muted.withValues(alpha: 0.65), size: 18),
      ],
    );
  }
}

class _Staggered extends StatelessWidget {
  final int index;
  final Animation<double> progress;
  final Widget child;
  const _Staggered({
    required this.index,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.09).clamp(0.0, 0.55);
    final curved = CurvedAnimation(
      parent: progress,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class _Crop {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color tagBg;
  final Color tagText;
  final List<String> tags;

  const _Crop({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.tagBg,
    required this.tagText,
    required this.tags,
  });
}