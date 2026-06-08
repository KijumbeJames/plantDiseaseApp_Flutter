import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF166534), Color(0xFF22C55E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF22C55E).withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded,
                        size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kijumbe James',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appState.tr('Smallholder Farmer', 'Mkulima Mdogo'),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Stats row
                  Row(
                    children: [
                      _statBox('12', appState.tr('Total Scans', 'Scan Zote')),
                      const SizedBox(width: 10),
                      _statBox('8', appState.tr('Diseases Found', 'Magonjwa')),
                      const SizedBox(width: 10),
                      _statBox('4', appState.tr('Healthy', 'Nzuri')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info tiles
                  _profileTile(
                    Icons.location_on_rounded,
                    appState.tr('Location', 'Eneo'),
                    'Dar es Salaam, TZ',
                  ),
                  const SizedBox(height: 8),
                  _profileTile(
                    Icons.grass_rounded,
                    appState.tr('Primary Crop', 'Zao Kuu'),
                    appState.tr('Cassava & Maize', 'Muhogo & Mahindi'),
                  ),
                  const SizedBox(height: 8),
                  _profileTile(
                    Icons.calendar_today_rounded,
                    appState.tr('Member Since', 'Mwanachama Tangu'),
                    'June 2026',
                  ),
                  const SizedBox(height: 8),
                  _profileTile(
                    Icons.offline_bolt_rounded,
                    appState.tr('App Mode', 'Hali ya App'),
                    appState.tr('Offline', 'Bila Mtandao'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF22C55E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}