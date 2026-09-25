import 'package:flutter/material.dart';
import '../models/smoke_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'risk_details_screen.dart';

class AlertsScreen extends StatefulWidget {
  final SmokeGuardState state;

  const AlertsScreen({super.key, required this.state});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = widget.state;
    final alerts = state.alerts;

    // Filter alerts
    final filteredAlerts = alerts.where((alert) {
      if (_selectedFilter == 'Active') return !alert.isResolved;
      if (_selectedFilter == 'High Risk') return alert.riskLevel == RiskLevel.high;
      if (_selectedFilter == 'Resolved') return alert.isResolved;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Smoke Alerts',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.riskHigh,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${state.unreadAlertsCount} Active',
                  style: TextStyle(
                    color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Active', 'High Risk', 'Resolved'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedFilter = filter);
                      },
                      selectedColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                      backgroundColor: isDark ? AppColors.darkCard : AppColors.pureWhite,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? (isDark ? AppColors.pureBlack : AppColors.pureWhite)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? (isDark ? AppColors.pureWhite : AppColors.pureBlack)
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Top Primary Alert Banner
            if (filteredAlerts.isNotEmpty && filteredAlerts.any((a) => !a.isResolved))
              _buildProminentAlertBanner(filteredAlerts.firstWhere((a) => !a.isResolved), isDark),

            const SizedBox(height: 22),

            // Alert Timeline Header
            Text(
              'Alert Timeline',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
              ),
            ),
            const SizedBox(height: 10),

            // Timeline Items
            if (filteredAlerts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 40,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No alerts found in this category',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredAlerts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final alert = filteredAlerts[index];
                  return _buildTimelineAlertCard(alert, isDark);
                },
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProminentAlertBanner(AlertItem alert, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: alert.riskLevel == RiskLevel.high ? AppColors.riskHigh : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.crisis_alert_rounded, color: alert.riskLevel.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Risk Level: ${alert.riskLevel.label}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: alert.riskLevel.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PSEI ${alert.pseiValue}',
                  style: TextStyle(
                    color: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              const SizedBox(width: 4),
              Text(
                alert.location,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.state.dismissAlert(alert.id);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Dismiss', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RiskDetailsScreen(state: widget.state),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                    foregroundColor: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineAlertCard(AlertItem alert, bool isDark) {
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                alert.isResolved ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
                color: alert.isResolved ? AppColors.riskSafe : alert.riskLevel.color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                          ),
                        ),
                      ),
                      Text(
                        alert.isResolved ? 'Resolved' : 'Active',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: alert.isResolved ? AppColors.riskSafe : alert.riskLevel.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    alert.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${alert.location} • PSEI ${alert.pseiValue}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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
}
