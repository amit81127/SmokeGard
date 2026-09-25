import 'package:flutter/material.dart';
import '../models/smoke_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_charts.dart';
import 'risk_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  final SmokeGuardState state;

  const HistoryScreen({super.key, required this.state});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = widget.state;
    final historyList = state.history;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Exposure History',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
          indicatorWeight: 3,
          labelColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
          unselectedLabelColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryContent(historyList, 'Daily Exposure Trend', [18, 32, 54, 72, 45, 28, 14], ['6 AM', '9 AM', '12 PM', '3 PM', '6 PM', '9 PM', 'Now'], isDark),
          _buildHistoryContent(historyList, '7-Day Exposure Trend', [45, 12, 18, 31, 22, 58, 42], ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'], isDark),
          _buildHistoryContent(historyList, 'Monthly Risk Pattern', [35, 42, 60, 52, 48, 70, 38], ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'], isDark),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(
    List<ExposureHistoryItem> items,
    String chartTitle,
    List<double> trendValues,
    List<String> trendLabels,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3 Metric Summary Cards Row
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'Total Exposure',
                  value: '2.4 hrs',
                  icon: Icons.access_time_rounded,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'Highest Risk Day',
                  value: 'Thu (78)',
                  icon: Icons.trending_up_rounded,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricMiniCard(
                  title: 'Average PSEI',
                  value: '34.2',
                  icon: Icons.speed_rounded,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Charts Section Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chartTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'PSEI Index',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ExposureTrendLineChart(
                  values: trendValues,
                  labels: trendLabels,
                  lineColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                  height: 150,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Exposure Logs List
          Text(
            'Logged Exposure Sessions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
            ),
          ),
          const SizedBox(height: 10),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSessionLogCard(item, isDark);
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMetricMiniCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
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
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionLogCard(ExposureHistoryItem item, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RiskDetailsScreen(state: widget.state),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.overallRisk == RiskLevel.safe
                    ? Icons.sentiment_very_satisfied_rounded
                    : (item.overallRisk == RiskLevel.moderate
                        ? Icons.sentiment_neutral_rounded
                        : Icons.sentiment_very_dissatisfied_rounded),
                color: item.overallRisk.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.dayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.primaryLocation,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.durationMinutes}m logged',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'PSEI: ${item.peakPsei}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: item.overallRisk.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
