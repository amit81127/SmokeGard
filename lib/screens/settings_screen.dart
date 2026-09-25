import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final SmokeGuardState state;

  const SettingsScreen({super.key, required this.state});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, _) {
        final state = widget.state;

        return Scaffold(
          backgroundColor: AppColors.darkBg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Settings & Preferences',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Appearance & Preferences
                _buildSectionHeader('PREFERENCES & DISPLAY'),
                _buildCardGroup(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text(
                        'Dark Theme (Default)',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        state.isDarkMode ? 'Futuristic Space Navy & Cyan active' : 'Light high-contrast mode active',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      secondary: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          state.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: AppColors.accentCyan,
                          size: 18,
                        ),
                      ),
                      value: state.isDarkMode,
                      activeThumbColor: AppColors.accentCyan,
                      activeTrackColor: AppColors.accentCyan.withValues(alpha: 0.35),
                      inactiveThumbColor: AppColors.textMuted,
                      inactiveTrackColor: AppColors.darkCardElevated,
                      onChanged: (val) {
                        state.toggleTheme();
                        _showFeedback(state.isDarkMode ? 'Dark Theme activated' : 'Light Theme activated');
                      },
                    ),
                    const Divider(height: 1, color: AppColors.darkBorder),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.language_rounded, color: AppColors.accentCyan, size: 18),
                      ),
                      title: const Text(
                        'Language',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        state.selectedLanguage,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
                      onTap: () => _showLanguageDialog(context, state),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 2. Notifications & Wearable Haptics
                _buildSectionHeader('NOTIFICATIONS & WEARABLE HAPTICS'),
                _buildCardGroup(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text(
                        'Push Notifications',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        state.pushNotifications ? 'Instant alerts on smoke spikes' : 'Alerts muted (app background only)',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      secondary: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          state.pushNotifications ? Icons.notifications_active_rounded : Icons.notifications_off_outlined,
                          color: state.pushNotifications ? AppColors.accentCyan : AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                      value: state.pushNotifications,
                      activeThumbColor: AppColors.accentCyan,
                      activeTrackColor: AppColors.accentCyan.withValues(alpha: 0.35),
                      inactiveThumbColor: AppColors.textMuted,
                      inactiveTrackColor: AppColors.darkCardElevated,
                      onChanged: (val) {
                        state.togglePushNotifications(val);
                        _showFeedback(val ? 'Push Notifications Enabled' : 'Push Notifications Disabled');
                      },
                    ),
                    const Divider(height: 1, color: AppColors.darkBorder),
                    SwitchListTile.adaptive(
                      title: const Text(
                        'Haptic Vibration Band',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        state.hapticFeedback ? 'Wearable band vibrates during smoke surge' : 'Vibration motor disabled',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      secondary: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.vibration_rounded,
                          color: state.hapticFeedback ? AppColors.accentTeal : AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                      value: state.hapticFeedback,
                      activeThumbColor: AppColors.accentTeal,
                      activeTrackColor: AppColors.accentTeal.withValues(alpha: 0.35),
                      inactiveThumbColor: AppColors.textMuted,
                      inactiveTrackColor: AppColors.darkCardElevated,
                      onChanged: (val) {
                        state.toggleHapticFeedback(val);
                        _showFeedback(val ? 'Haptic Vibration On' : 'Haptic Vibration Off');
                      },
                    ),
                    const Divider(height: 1, color: AppColors.darkBorder),
                    SwitchListTile.adaptive(
                      title: const Text(
                        'Critical Hazard Alarm',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        state.criticalVibrationAlert ? 'Continuous alarm for PSEI > 70' : 'Standard beep only',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      secondary: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.emergency_rounded,
                          color: state.criticalVibrationAlert ? AppColors.riskHigh : AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                      value: state.criticalVibrationAlert,
                      activeThumbColor: AppColors.riskHigh,
                      activeTrackColor: AppColors.riskHigh.withValues(alpha: 0.35),
                      inactiveThumbColor: AppColors.textMuted,
                      inactiveTrackColor: AppColors.darkCardElevated,
                      onChanged: (val) {
                        state.toggleCriticalVibration(val);
                        _showFeedback(val ? 'Critical Hazard Alarm Active' : 'Hazard Alarm Muted');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 3. Smoke Sensitivity & Thresholds
                _buildSectionHeader('ALERT SENSITIVITY THRESHOLD'),
                _buildCardGroup(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Trigger Alert at PSEI',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${state.pseiAlertThreshold.toInt()} PSEI',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.accentCyan,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Adjust the sensitivity point where SmokeGuard fires high-risk notifications.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.accentCyan,
                              inactiveTrackColor: AppColors.darkBorder,
                              thumbColor: AppColors.accentCyan,
                              overlayColor: AppColors.accentCyan.withValues(alpha: 0.2),
                              trackHeight: 3,
                            ),
                            child: Slider(
                              value: state.pseiAlertThreshold,
                              min: 30.0,
                              max: 90.0,
                              divisions: 12,
                              onChanged: (val) => state.setPseiThreshold(val),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 4. Sensor Hardware Section
                _buildSectionHeader('HARDWARE & SENSORS'),
                _buildCardGroup(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.sensors_rounded,
                          color: state.isSensorConnected ? AppColors.riskSafe : AppColors.riskHigh,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        state.sensorName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        state.isSensorConnected
                            ? 'Connected (BLE 5.2) • Battery ${state.sensorBattery}%'
                            : 'Sensor Disconnected (Tap Connect)',
                        style: TextStyle(
                          fontSize: 11,
                          color: state.isSensorConnected ? AppColors.riskSafe : AppColors.riskHigh,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          state.toggleSensorConnection();
                          _showFeedback(state.isSensorConnected ? 'Sensor Band Connected' : 'Sensor Band Disconnected');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.isSensorConnected ? AppColors.darkCardElevated : AppColors.accentCyan,
                          foregroundColor: state.isSensorConnected ? AppColors.riskHigh : AppColors.pureBlack,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          state.isSensorConnected ? 'Disconnect' : 'Connect',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 5. Privacy & System Section
                _buildSectionHeader('SYSTEM & ABOUT'),
                _buildCardGroup(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.privacy_tip_outlined, color: AppColors.accentCyan, size: 18),
                      ),
                      title: const Text(
                        'Privacy & Edge AI Encryption',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: const Text(
                        'All sensor telemetry computed locally on device',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
                      onTap: () => _showPrivacyDialog(context),
                    ),
                    const Divider(height: 1, color: AppColors.darkBorder),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.darkCardElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline_rounded, color: AppColors.accentTeal, size: 18),
                      ),
                      title: const Text(
                        'About SmokeGuard System',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      subtitle: const Text(
                        'Version 2.0.0 • AIoT Smoke Exposure Defender',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildCardGroup({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(children: children),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.pureBlack, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        backgroundColor: AppColors.accentCyan,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SmokeGuardState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        title: const Text(
          'Select Language',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Hindi (हिंदी)', 'Spanish (Español)', 'French (Français)'].map((lang) {
            final isSelected = state.selectedLanguage.startsWith(lang.split(' ').first);
            return ListTile(
              title: Text(
                lang,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.accentCyan : AppColors.textPrimary,
                ),
              ),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.accentCyan, size: 18) : null,
              onTap: () {
                state.setLanguage(lang.split(' ').first);
                Navigator.of(ctx).pop();
                _showFeedback('Language switched to ${lang.split(' ').first}');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        title: Row(
          children: const [
            Icon(Icons.security_rounded, color: AppColors.accentCyan, size: 22),
            SizedBox(width: 8),
            Text('Privacy & Edge AI', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary)),
          ],
        ),
        content: const Text(
          'SmokeGuard uses on-device Edge Machine Learning algorithms to compute Personalized Smoke Exposure Index (PSEI) without storing unencrypted raw biometric telemetry on external cloud servers.\n\nAll historical exposure clusters remain encrypted in private sandboxed storage.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: AppColors.pureBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        title: Row(
          children: const [
            Icon(Icons.shield_outlined, color: AppColors.accentCyan, size: 22),
            SizedBox(width: 8),
            Text('SmokeGuard AIoT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary)),
          ],
        ),
        content: const Text(
          'SmokeGuard: Smart Second-Hand Smoke Exposure & Respiratory Health Protection System.\n\nFeatures:\n• Real-Time PM2.5, VOC & Carbon Monoxide Sensing\n• Dynamic PSEI (0-100) Score Gauge\n• BLE 5.2 Wearable Haptic Feedback\n• AI Commute Exposure Optimization\n• Final Year Major Project UI Architecture',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: AppColors.pureBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
