import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/risk_gauge.dart';

class RiskDetailsScreen extends StatelessWidget {
  final SmokeGuardState state;

  const RiskDetailsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final metrics = state.currentMetrics;
    final riskLevel = metrics.riskLevel;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Risk Details & Analysis',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              state.isSpikeSimulation ? Icons.health_and_safety : Icons.warning_amber_rounded,
              color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
            ),
            tooltip: 'Simulate Exposure Spike',
            onPressed: () => state.toggleSpikeSimulation(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Radial Gauge Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  RiskGaugeWidget(
                    pseiScore: metrics.pseiScore,
                    riskLevel: riskLevel,
                    size: 240,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGaugeMetric('PM2.5 Level', '${metrics.pm25} µg/m³', isDark),
                        Container(width: 1, height: 26, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        _buildGaugeMetric('VOC Density', '${metrics.voc} ppm', isDark),
                        Container(width: 1, height: 26, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        _buildGaugeMetric('CO Level', '${metrics.carbonMonoxide} ppm', isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Exposure Summary Section
            Text(
              'Exposure Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    icon: Icons.timer_outlined,
                    label: 'Exposure Duration',
                    value: '${metrics.exposureTimeMinutes} Minutes',
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: 'Central Metro Transit & Food Corridor',
                    isDark: isDark,
                  ),
                  const Divider(height: 20),
                  _buildSummaryRow(
                    icon: Icons.access_time_rounded,
                    label: 'Detection Time',
                    value: '06:45 PM • Active Live Session',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Smart Health Recommendation Cards
            Text(
              'Health Recommendations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
              ),
            ),
            const SizedBox(height: 10),

            _buildRecommendationCard(
              icon: Icons.directions_run_rounded,
              title: 'Move to Fresh Air',
              description: 'Immediately relocate to a filtered indoor zone, park, or clean-air shelter nearby.',
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildRecommendationCard(
              icon: Icons.masks_rounded,
              title: 'Reduce Exposure',
              description: 'Wear an N95 / FFP2 particulate mask and minimize physical exertion or deep breathing.',
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildRecommendationCard(
              icon: Icons.favorite_rounded,
              title: 'Monitor Health',
              description: 'Check for eye irritation, coughing, or throat dryness. Hydrate and use saline drops if needed.',
              isDark: isDark,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGaugeMetric(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isDark ? AppColors.pureWhite : AppColors.pureBlack, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDark ? AppColors.pureWhite : AppColors.pureBlack, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.35,
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
