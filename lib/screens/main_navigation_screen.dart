import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'alerts_screen.dart';
import 'analytics_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final SmokeGuardState _appState = SmokeGuardState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        state: _appState,
        onNavigateToTab: (index) => setState(() => _appState.setTabIndex(index)),
      ),
      AnalyticsScreen(state: _appState),
      HistoryScreen(state: _appState),
      AlertsScreen(state: _appState),
      ProfileScreen(state: _appState),
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      extendBody: false,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: IndexedStack(
            index: _appState.currentTabIndex,
            children: screens,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _appState.currentTabIndex,
        unreadAlerts: _appState.unreadAlertsCount,
        onTabSelected: (index) {
          setState(() {
            _appState.setTabIndex(index);
          });
        },
      ),
    );
  }
}
