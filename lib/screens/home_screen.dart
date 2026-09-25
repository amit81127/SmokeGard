import 'package:flutter/material.dart';
import '../models/smoke_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/status_card.dart';
import 'risk_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final SmokeGuardState state;
  final Function(int) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.state,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = state.currentMetrics;
    final riskLevel = metrics.riskLevel;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section: User Greeting, Date/Time, Wearable Status, & Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hello Amit 👋',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Oct 8, 2026 • 09:00 PM',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Connected Wearable Indicator Badge with Battery
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.darkBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.isSensorConnected ? AppColors.riskSafe : AppColors.riskHigh,
                                boxShadow: [
                                  BoxShadow(
                                    color: (state.isSensorConnected ? AppColors.riskSafe : AppColors.riskHigh)
                                        .withValues(alpha: 0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.isSensorConnected
                                  ? 'Connected • ${state.sensorBattery}% 🔋'
                                  : 'Disconnected',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: state.isSensorConnected ? AppColors.textPrimary : AppColors.riskHigh,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Profile Avatar
                      InkWell(
                        onTap: () => onNavigateToTab(4), // Jump to Profile Tab
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: AppColors.cyanGlowGradient,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCyan.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'AP',
                              style: TextStyle(
                                color: AppColors.pureBlack,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Interactive Live Demo Simulation Console (Allows presentation / PPT reviewers to switch states)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: state.isSpikeSimulation ? AppColors.riskHigh : AppColors.accentCyan.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.tune_rounded, size: 14, color: AppColors.accentCyan),
                            SizedBox(width: 6),
                            Text(
                              'AIoT SENSOR SIMULATOR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'PSEI: ${metrics.pseiScore} (${riskLevel.label})',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: riskLevel.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.accentCyan,
                        inactiveTrackColor: AppColors.darkBorder,
                        thumbColor: AppColors.accentCyan,
                        overlayColor: AppColors.accentCyan.withValues(alpha: 0.15),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: metrics.pseiScore.toDouble(),
                        min: 0,
                        max: 100,
                        onChanged: (val) => state.setCustomPsei(val.round()),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPresetBtn(
                            label: '🟢 Safe (Clean)',
                            isSelected: metrics.pseiScore <= 35,
                            onTap: () => state.applyScenarioPreset('clean'),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildPresetBtn(
                            label: '🟡 Moderate (Traffic)',
                            isSelected: metrics.pseiScore > 35 && metrics.pseiScore <= 65,
                            onTap: () => state.applyScenarioPreset('moderate'),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildPresetBtn(
                            label: '🔴 High (Smoke Plume)',
                            isSelected: metrics.pseiScore > 65,
                            onTap: () => state.applyScenarioPreset('smoke_hazard'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Hero Card: Current Air Status, Status Badge, PSEI Score & Breathing Wave Radar
              LiveStatusCard(
                riskLevel: riskLevel,
                pseiScore: metrics.pseiScore,
                exposureMinutes: metrics.exposureTimeMinutes,
                isConnected: state.isSensorConnected,
                onTapDetails: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RiskDetailsScreen(state: state),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),

              // 3. Live Monitoring Section (4 modern metric cards)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Live Environmental Sensing',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Telemetry Stream',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2x2 Grid of PM2.5, VOC, Temperature, Humidity
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.98,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // 1. PM2.5 Card
                  MetricCard(
                    title: 'PM2.5 Level',
                    value: '${metrics.pm25}',
                    unit: 'µg/m³',
                    icon: Icons.grain_rounded,
                    accentColor: metrics.pm25 > 50 ? AppColors.riskHigh : AppColors.accentCyan,
                    badgeText: metrics.pm25 > 50 ? 'HAZARD' : 'OPTIMAL',
                    badgeColor: metrics.pm25 > 50 ? AppColors.riskHigh : AppColors.riskSafe,
                    sparklinePoints: const [0.2, 0.3, 0.25, 0.4, 0.35, 0.5, 0.3],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RiskDetailsScreen(state: state)),
                    ),
                  ),

                  // 2. VOC Level
                  MetricCard(
                    title: 'VOC Gas Density',
                    value: '${metrics.voc}',
                    unit: 'ppm',
                    icon: Icons.cloud_outlined,
                    accentColor: metrics.voc > 1.0 ? AppColors.riskModerate : AppColors.accentTeal,
                    badgeText: metrics.voc > 1.0 ? 'ELEVATED' : 'CLEAN',
                    badgeColor: metrics.voc > 1.0 ? AppColors.riskModerate : AppColors.accentTeal,
                    sparklinePoints: const [0.3, 0.2, 0.4, 0.3, 0.5, 0.4, 0.2],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RiskDetailsScreen(state: state)),
                    ),
                  ),

                  // 3. Temperature
                  MetricCard(
                    title: 'Temperature',
                    value: '${metrics.temperature}',
                    unit: '°C',
                    icon: Icons.thermostat_rounded,
                    accentColor: AppColors.accentBlue,
                    badgeText: 'COMFORTABLE',
                    badgeColor: AppColors.accentBlue,
                    sparklinePoints: const [0.4, 0.45, 0.5, 0.5, 0.52, 0.5, 0.48],
                    onTap: () {},
                  ),

                  // 4. Humidity
                  MetricCard(
                    title: 'Relative Humidity',
                    value: '${metrics.humidity.toInt()}',
                    unit: '%',
                    icon: Icons.water_drop_outlined,
                    accentColor: AppColors.accentCyan,
                    badgeText: 'NORMAL',
                    badgeColor: AppColors.accentCyan,
                    sparklinePoints: const [0.5, 0.48, 0.52, 0.55, 0.5, 0.48, 0.5],
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // 4. Quick Actions Section (Grid)
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionBtn(
                      title: 'Analytics',
                      icon: Icons.analytics_outlined,
                      accentColor: AppColors.accentCyan,
                      onTap: () => onNavigateToTab(1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionBtn(
                      title: 'History',
                      icon: Icons.history_rounded,
                      accentColor: AppColors.accentPurple,
                      onTap: () => onNavigateToTab(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionBtn(
                      title: 'Alerts',
                      icon: Icons.crisis_alert_rounded,
                      accentColor: AppColors.riskModerate,
                      onTap: () => onNavigateToTab(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildQuickActionBtn(
                      title: 'Insights',
                      icon: Icons.auto_awesome_rounded,
                      accentColor: AppColors.accentTeal,
                      onTap: () => onNavigateToTab(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // 5. Recent Alerts Section (Scrollable Cards)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Alerts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => onNavigateToTab(3),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (state.alerts.isNotEmpty)
                _buildRecentAlertCard(state.alerts.first, context)
              else
                const Text('No recent smoke incidents recorded.'),

              const SizedBox(height: 22),

              // 6. Exposure Summary Card
              const Text(
                'Exposure Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryStat('Today Exposure', '${metrics.exposureTimeMinutes}m', Icons.timer_outlined, AppColors.accentCyan),
                    Container(width: 1, height: 36, color: AppColors.darkBorder),
                    _buildSummaryStat('Weekly Exposure', '2.4 hrs', Icons.calendar_today_outlined, AppColors.accentTeal),
                    Container(width: 1, height: 36, color: AppColors.darkBorder),
                    _buildSummaryStat('Average PSEI', '34.2', Icons.speed_rounded, AppColors.riskSafe),
                    Container(width: 1, height: 36, color: AppColors.darkBorder),
                    _buildSummaryStat('Risk Trend', 'Stable ↘', Icons.trending_down_rounded, AppColors.accentBlue),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // 7. AI Health Recommendation Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF132238), Color(0xFF0F1A2C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.health_and_safety_rounded,
                        color: AppColors.accentCyan,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'AI Health Recommendation',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentCyan,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '"Air quality is currently safe. Continue monitoring your surroundings."',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetBtn({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCyan.withValues(alpha: 0.2)
              : AppColors.darkCardElevated,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.accentCyan, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn({
    required String title,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.darkBorder,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlertCard(AlertItem alert, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: alert.riskLevel == RiskLevel.high ? AppColors.riskHigh.withValues(alpha: 0.6) : AppColors.darkBorder,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: alert.riskLevel.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: alert.riskLevel.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Smoke Detected Warning',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: alert.riskLevel.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: alert.riskLevel.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        alert.riskLevel.label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: alert.riskLevel.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${alert.location} • PSEI ${alert.pseiValue}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '12 minutes ago',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RiskDetailsScreen(state: state)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkCardElevated,
              foregroundColor: AppColors.accentCyan,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
