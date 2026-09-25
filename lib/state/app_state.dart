import 'package:flutter/material.dart';
import '../models/smoke_data.dart';
import '../theme/app_theme.dart';

class SmokeGuardState extends ChangeNotifier {
  // Theme Mode
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // User Profile Data
  String _userName = 'Amit Kumar Prasad';
  String get userName => _userName;
  String _userEmail = 'amit.prasad@smokeguard.io';
  String get userEmail => _userEmail;
  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void updateProfile(String name, String email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  // Device & Sensor Info
  bool _isSensorConnected = true;
  bool get isSensorConnected => _isSensorConnected;
  final int _sensorBattery = 94;
  int get sensorBattery => _sensorBattery;
  final String _sensorName = 'SmokeGuard IoT Sensor v2.1';
  String get sensorName => _sensorName;

  void toggleSensorConnection() {
    _isSensorConnected = !_isSensorConnected;
    notifyListeners();
  }

  // Simulation Mode (Allows presentation / PPT reviewers to switch states)
  bool _isSpikeSimulation = false;
  bool get isSpikeSimulation => _isSpikeSimulation;

  // Real-Time Smoke Metrics
  SmokeMetrics _currentMetrics = const SmokeMetrics(
    pm25: 18.4,
    voc: 0.14,
    pseiScore: 28,
    exposureTimeMinutes: 14,
    carbonMonoxide: 1.1,
    temperature: 24.5,
    humidity: 48.0,
    aqi: 42,
  );
  SmokeMetrics get currentMetrics => _currentMetrics;

  void setCustomPsei(int score) {
    final clamped = score.clamp(0, 100);
    final pm25Calc = (clamped * 1.2).clamp(5.0, 150.0);
    final vocCalc = (clamped * 0.025).clamp(0.05, 3.5);
    final coCalc = (clamped * 0.11).clamp(0.5, 15.0);
    final exposureTime = (clamped * 0.6).round().clamp(5, 120);

    _currentMetrics = SmokeMetrics(
      pm25: double.parse(pm25Calc.toStringAsFixed(1)),
      voc: double.parse(vocCalc.toStringAsFixed(2)),
      pseiScore: clamped,
      exposureTimeMinutes: exposureTime,
      carbonMonoxide: double.parse(coCalc.toStringAsFixed(1)),
      temperature: 24.5,
      humidity: 48.0,
      aqi: (clamped * 2.2).round(),
    );

    _isSpikeSimulation = clamped >= 60;
    notifyListeners();
  }

  void applyScenarioPreset(String scenario) {
    if (scenario == 'clean') {
      setCustomPsei(22);
    } else if (scenario == 'moderate') {
      setCustomPsei(52);
    } else if (scenario == 'smoke_hazard') {
      setCustomPsei(82);
    }
  }

  void simulateState({required bool spike}) {
    if (spike) {
      applyScenarioPreset('smoke_hazard');
    } else {
      applyScenarioPreset('clean');
    }
  }

  void toggleSpikeSimulation() {
    simulateState(spike: !_isSpikeSimulation);
  }

  // Alerts List
  final List<AlertItem> _alerts = [
    AlertItem(
      id: 'alt-1',
      title: '⚠ Smoke Exposure Detected',
      subtitle: 'Critical biomass & vehicle smoke plume detected nearby',
      riskLevel: RiskLevel.high,
      pseiValue: 72,
      pm25Value: 86.8,
      location: 'Central Metro Plaza (South Gate)',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      durationMinutes: 42,
      recommendations: const [
        'Move to fresh air immediately',
        'Put on your N95 respirator mask',
        'Monitor heart rate and respiratory ease',
        'Avoid strenuous outdoor walking',
      ],
    ),
    AlertItem(
      id: 'alt-2',
      title: 'Elevated VOC Spike',
      subtitle: 'Solvent/cooking smoke fumes above safety threshold',
      riskLevel: RiskLevel.moderate,
      pseiValue: 54,
      pm25Value: 45.2,
      location: 'Downtown Food Street & Market',
      timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 40)),
      durationMinutes: 28,
      recommendations: const [
        'Relocate away from active open fryers / grills',
        'Ensure proper cross-ventilation in the area',
      ],
    ),
    AlertItem(
      id: 'alt-3',
      title: 'Traffic Exhaust Particulate Surge',
      subtitle: 'Peak rush-hour diesel emissions cluster',
      riskLevel: RiskLevel.moderate,
      pseiValue: 48,
      pm25Value: 39.0,
      location: 'Ring Road Crossing (Bus Stand)',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      durationMinutes: 35,
      isResolved: true,
      recommendations: const [
        'Keep vehicle windows rolled up',
        'Activate in-cabin recirculation mode',
      ],
    ),
    AlertItem(
      id: 'alt-4',
      title: 'Industrial Smoke Incursion',
      subtitle: 'Dense smoke from industrial corridor',
      riskLevel: RiskLevel.high,
      pseiValue: 78,
      pm25Value: 92.4,
      location: 'Sector 4 Industrial Bypass',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      durationMinutes: 58,
      isResolved: true,
      recommendations: const [
        'Stay indoors with HEPA air filtration',
        'Seal window cracks and vent ducts',
      ],
    ),
  ];
  List<AlertItem> get alerts => List.unmodifiable(_alerts);

  int get unreadAlertsCount => _alerts.where((a) => !a.isResolved).length;

  void dismissAlert(String id) {
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void resolveAlert(String id) {
    final index = _alerts.indexWhere((a) => a.id == id);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isResolved: true);
      notifyListeners();
    }
  }

  // Exposure History Items
  final List<ExposureHistoryItem> _history = [
    ExposureHistoryItem(
      id: 'h-1',
      date: DateTime.now(),
      dayName: 'Today (Friday)',
      durationMinutes: 42,
      avgPsei: 46,
      peakPsei: 72,
      primaryLocation: 'Central Metro & Food Street',
      overallRisk: RiskLevel.high,
    ),
    ExposureHistoryItem(
      id: 'h-2',
      date: DateTime.now().subtract(const Duration(days: 1)),
      dayName: 'Yesterday (Thursday)',
      durationMinutes: 58,
      avgPsei: 54,
      peakPsei: 78,
      primaryLocation: 'Sector 4 Industrial Bypass',
      overallRisk: RiskLevel.high,
    ),
    ExposureHistoryItem(
      id: 'h-3',
      date: DateTime.now().subtract(const Duration(days: 2)),
      dayName: 'Wednesday',
      durationMinutes: 22,
      avgPsei: 26,
      peakPsei: 34,
      primaryLocation: 'Green Park & Tech Corridor',
      overallRisk: RiskLevel.safe,
    ),
    ExposureHistoryItem(
      id: 'h-4',
      date: DateTime.now().subtract(const Duration(days: 3)),
      dayName: 'Tuesday',
      durationMinutes: 31,
      avgPsei: 38,
      peakPsei: 49,
      primaryLocation: 'Commercial High Street',
      overallRisk: RiskLevel.moderate,
    ),
    ExposureHistoryItem(
      id: 'h-5',
      date: DateTime.now().subtract(const Duration(days: 4)),
      dayName: 'Monday',
      durationMinutes: 18,
      avgPsei: 22,
      peakPsei: 29,
      primaryLocation: 'Suburban Residential Zone',
      overallRisk: RiskLevel.safe,
    ),
    ExposureHistoryItem(
      id: 'h-6',
      date: DateTime.now().subtract(const Duration(days: 5)),
      dayName: 'Sunday',
      durationMinutes: 12,
      avgPsei: 19,
      peakPsei: 24,
      primaryLocation: 'Botanical Gardens',
      overallRisk: RiskLevel.safe,
    ),
    ExposureHistoryItem(
      id: 'h-7',
      date: DateTime.now().subtract(const Duration(days: 6)),
      dayName: 'Saturday',
      durationMinutes: 45,
      avgPsei: 51,
      peakPsei: 66,
      primaryLocation: 'Highway Food Plaza',
      overallRisk: RiskLevel.moderate,
    ),
  ];
  List<ExposureHistoryItem> get history => List.unmodifiable(_history);

  // AI Insights
  final List<AIInsightItem> _aiInsights = const [
    AIInsightItem(
      title: 'Commute Hotspot Detection',
      primaryStat: 'Public Transport (68%)',
      highlight: 'Peak Smoke Window: 6:00 PM – 8:00 PM',
      description: 'Your highest particulate intake coincides with evening metro bus transit hubs.',
      icon: Icons.directions_bus_rounded,
      accentColor: AppColors.accentCyan,
    ),
    AIInsightItem(
      title: 'Exposure Optimization AI',
      primaryStat: '-42% Risk Reduction',
      highlight: 'Route Shift Recommendation',
      description: 'Choosing West Boulevard over Central Corridor drops daily PSEI by 38 points.',
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.accentTeal,
    ),
    AIInsightItem(
      title: 'Asthma & Lung Safety Score',
      primaryStat: '8.4 / 10 (Good)',
      highlight: 'Recovery Window: 18 hrs safe air',
      description: 'Your lungs have had 82% clean air clearance in the last 48-hour cycle.',
      icon: Icons.health_and_safety_rounded,
      accentColor: AppColors.riskSafe,
    ),
  ];
  List<AIInsightItem> get aiInsights => _aiInsights;

  // Settings Toggles
  bool _pushNotifications = true;
  bool get pushNotifications => _pushNotifications;
  void togglePushNotifications(bool val) {
    _pushNotifications = val;
    notifyListeners();
  }

  bool _hapticFeedback = true;
  bool get hapticFeedback => _hapticFeedback;
  void toggleHapticFeedback(bool val) {
    _hapticFeedback = val;
    notifyListeners();
  }

  bool _criticalVibrationAlert = true;
  bool get criticalVibrationAlert => _criticalVibrationAlert;
  void toggleCriticalVibration(bool val) {
    _criticalVibrationAlert = val;
    notifyListeners();
  }

  double _pseiAlertThreshold = 60.0;
  double get pseiAlertThreshold => _pseiAlertThreshold;
  void setPseiThreshold(double val) {
    _pseiAlertThreshold = val;
    notifyListeners();
  }

  // Active Bottom Navigation Tab index
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;
  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }
}
