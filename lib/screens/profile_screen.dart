import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final SmokeGuardState state;

  const ProfileScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(state: state),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          children: [
            // User Avatar & Name Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                        ),
                        child: Center(
                          child: Text(
                            'AP',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    state.userEmail,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      'Asthmatic Sensitivity Profile • Active',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3 Stat Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildProfileStatCard(
                    title: 'Total Hours',
                    value: '18.5h',
                    icon: Icons.timer_outlined,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildProfileStatCard(
                    title: 'Avg Risk',
                    value: '32 PSEI',
                    icon: Icons.speed_rounded,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildProfileStatCard(
                    title: 'Total Alerts',
                    value: '12',
                    icon: Icons.notifications_none_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hardware Device Status Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.watch_rounded,
                      color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paired Smoke Sensor Band',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: SG-902-BLE • Battery ${state.sensorBattery}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Connected',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Presentation PPT Actions
            _buildActionTile(
              icon: Icons.slideshow_rounded,
              title: 'PPT Presentation Showcase Specs',
              subtitle: 'View 8-screen UI flow case study slides',
              isDark: isDark,
              onTap: () => _showPresentationInfo(context, isDark),
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.picture_as_pdf_outlined,
              title: 'Export Smoke Health Report',
              subtitle: 'Download monthly exposure summary',
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Exporting SmokeGuard Health Report (PDF)...'),
                    backgroundColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.settings_outlined,
              title: 'Settings & Preferences',
              subtitle: 'Notifications, dark mode, language',
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsScreen(state: state)),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStatCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: isDark ? AppColors.pureWhite : AppColors.pureBlack),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isDark ? AppColors.pureWhite : AppColors.pureBlack, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12),
          ],
        ),
      ),
    );
  }

  void _showPresentationInfo(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.slideshow_rounded, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'PPT UI Flow Showcase Slides',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('1. Splash Screen • Minimalist Monochrome Intro'),
              const SizedBox(height: 5),
              const Text('2. Onboarding Screens • 3 Awareness & Tracking Slides'),
              const SizedBox(height: 5),
              const Text('3. Login & Sign Up • Card Authentication'),
              const SizedBox(height: 5),
              const Text('4. Home Dashboard • Live Status, PM2.5, VOC, PSEI'),
              const SizedBox(height: 5),
              const Text('5. Alert Screen • Active High Risk Alerts & Timeline'),
              const SizedBox(height: 5),
              const Text('6. Risk Details Screen • Radial PSEI Gauge & Advice'),
              const SizedBox(height: 5),
              const Text('7. Exposure History • Daily/Weekly/Monthly Trends'),
              const SizedBox(height: 5),
              const Text('8. Analytics Dashboard • AI Insights & Charts'),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    foregroundColor: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
