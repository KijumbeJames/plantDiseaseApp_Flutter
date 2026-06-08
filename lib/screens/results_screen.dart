import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _history = [
    {
      'crop': 'Cassava',
      'disease': 'CMD',
      'confidence': 94.2,
      'date': 'Leo, 09:14',
      'emoji': '🌿',
      'color': Color(0xFF22C55E),
      'severity': 'High',
    },
    {
      'crop': 'Maize',
      'disease': 'FAW Pest',
      'confidence': 88.7,
      'date': 'Jana, 14:32',
      'emoji': '🌽',
      'color': Color(0xFFFBBF24),
      'severity': 'Medium',
    },
    {
      'crop': 'Cassava',
      'disease': 'Cassava Healthy',
      'confidence': 97.1,
      'date': 'Jana, 11:05',
      'emoji': '🌿',
      'color': Color(0xFF22C55E),
      'severity': 'None',
    },
    {
      'crop': 'Maize',
      'disease': 'NLB',
      'confidence': 76.3,
      'date': '01 Jun, 08:20',
      'emoji': '🌽',
      'color': Color(0xFFFBBF24),
      'severity': 'Low',
    },
  ];

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

  Color _severityColor(String s) {
    switch (s) {
      case 'High':
        return const Color(0xFFEF4444);
      case 'Medium':
        return const Color(0xFFFBBF24);
      case 'Low':
        return const Color(0xFF60A5FA);
      default:
        return const Color(0xFF22C55E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        children: [
          // Background
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appState.tr('Scan History', 'Historia ya Scan'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Text(
                          '${_history.length} ${appState.tr('scans', 'scan')}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    appState.tr(
                      'Your recent disease detections',
                      'Matokeo ya hivi karibuni',
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // List
                Expanded(
                  child: _history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.history_rounded,
                                size: 60,
                                color: Colors.white24,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                appState.tr('No scans yet', 'Hakuna scan bado'),
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: _history.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final item = _history[i];
                            final sColor = _severityColor(
                              item['severity'] as String,
                            );
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: (item['color'] as Color)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: (item['color'] as Color)
                                            .withValues(alpha: 0.25),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        item['emoji'] as String,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item['disease'] as String,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: sColor.withValues(
                                                  alpha: 0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                item['severity'] as String,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: sColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item['crop']} · ${item['confidence']}%',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item['date'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
