import 'package:flutter/material.dart';
import 'dart:io';
import '../theme/app_colors.dart';

class ResultScreen extends StatefulWidget {
  final File imageFile;
  const ResultScreen({super.key, required this.imageFile});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  AppColors get _c => AppColors.of(context);
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _c.bgBottom,
      body: Stack(
        children: [
          _AnimatedBackground(progress: _fadeAnim, isDark: _isDark),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _topBar(context)),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _imageCard(),
                            const SizedBox(height: 14),
                            _statusCard(),
                            const SizedBox(height: 14),
                            _recommendationsCard(),
                            const SizedBox(height: 14),
                            _actionsRow(context),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
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
                  'Matokeo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: _c.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Uchambuzi wa picha ya jani',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: _c.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _pill(
            icon: Icons.offline_bolt_rounded,
            label: 'OFFLINE',
          ),
        ],
      ),
    );
  }

  Widget _imageCard() {
    return Material(
      color: _c.surface2,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _c.stroke, width: 0.8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(widget.imageFile, fit: BoxFit.cover),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                              width: 0.8),
                        ),
                        child: const Icon(Icons.image_rounded,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Picha iliyochaguliwa',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
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

  Widget _statusCard() {
    return Material(
      color: _c.surface2,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _c.stroke, width: 0.8),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _c.brand.withValues(alpha: _isDark ? 0.22 : 0.18),
                    _c.brand.withValues(alpha: _isDark ? 0.08 : 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _c.stroke, width: 0.8),
              ),
              child: const Icon(Icons.psychology_alt_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Model bado haijaongezwa',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: _c.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ukishaweka model, hapa ndipo itaonyesha ugonjwa + confidence.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _c.muted,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
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

  Widget _recommendationsCard() {
    const items = [
      _Reco(
        icon: Icons.wb_sunny_rounded,
        title: 'Mwanga mzuri',
        body: 'Piga picha kwenye mwanga wa kutosha ili details zionekane.',
      ),
      _Reco(
        icon: Icons.center_focus_strong_rounded,
        title: 'Lenga jani',
        body: 'Hakikisha jani linajaza frame, lisipindane na background sana.',
      ),
      _Reco(
        icon: Icons.cleaning_services_rounded,
        title: 'Epuka blur',
        body: 'Shikilia simu steady, futa lens kama kuna vumbi/maji.',
      ),
    ];

    return Material(
      color: _c.surface2,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _c.stroke, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Mapendekezo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: _c.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Icon(Icons.tips_and_updates_rounded,
                    color: _c.muted.withValues(alpha: 0.55), size: 18),
              ],
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < items.length; i++) ...[
              _RecoTile(reco: items[i]),
              if (i != items.length - 1) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.replay_rounded, size: 18),
            label: const Text('Piga nyingine'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _c.ink.withValues(alpha: 0.92),
              side: BorderSide(color: _c.stroke.withValues(alpha: 0.9)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Hifadhi'),
            style: FilledButton.styleFrom(
              backgroundColor: _c.brandDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (_isDark ? Colors.white : _c.ink).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: (_isDark ? Colors.white : _c.ink).withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _c.brandDark, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: _c.brandDark,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
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
          child: Icon(icon, color: _c.ink.withValues(alpha: 0.75), size: 18),
        ),
      ),
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

class _Reco {
  final IconData icon;
  final String title;
  final String body;
  const _Reco({required this.icon, required this.title, required this.body});
}

class _RecoTile extends StatelessWidget {
  final _Reco reco;
  const _RecoTile({required this.reco});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: c.brand.withValues(alpha: isDark ? 0.14 : 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.stroke, width: 0.8),
          ),
          child: Icon(reco.icon,
              color: c.ink.withValues(alpha: isDark ? 0.90 : 0.80), size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reco.title,
                style: TextStyle(
                  color: c.ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reco.body,
                style: TextStyle(
                  color: c.muted,
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}