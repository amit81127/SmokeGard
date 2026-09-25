import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const SmokeGuardApp());
}

class SmokeGuardScope extends InheritedNotifier<SmokeGuardState> {
  const SmokeGuardScope({
    super.key,
    required SmokeGuardState super.notifier,
    required super.child,
  });

  static SmokeGuardState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SmokeGuardScope>()!.notifier!;
  }
}

class SmokeGuardApp extends StatefulWidget {
  const SmokeGuardApp({super.key});

  @override
  State<SmokeGuardApp> createState() => _SmokeGuardAppState();
}

class _SmokeGuardAppState extends State<SmokeGuardApp> {
  final SmokeGuardState _appState = SmokeGuardState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onThemeChanged);
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmokeGuardScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'SmokeGuard',
        debugShowCheckedModeBanner: false,
        themeMode: _appState.themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
