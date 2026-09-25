import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smokeguard/main.dart';
import 'package:smokeguard/screens/settings_screen.dart';
import 'package:smokeguard/state/app_state.dart';

void main() {
  testWidgets('SmokeGuard app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmokeGuardApp());
    expect(find.text('SMOKE'), findsOneWidget);
    expect(find.text('GUARD'), findsOneWidget);

    // Pump past splash screen timer
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pumpAndSettle();
  });

  testWidgets('Settings screen switches toggle reactively', (WidgetTester tester) async {
    final state = SmokeGuardState();
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(state: state),
      ),
    );

    expect(state.pushNotifications, isTrue);
    expect(state.hapticFeedback, isTrue);

    // Find and toggle Push Notifications switch
    final pushTile = find.widgetWithText(SwitchListTile, 'Push Notifications');
    expect(pushTile, findsOneWidget);
    await tester.tap(pushTile);
    await tester.pumpAndSettle();

    expect(state.pushNotifications, isFalse);

    // Toggle back
    await tester.tap(pushTile);
    await tester.pumpAndSettle();
    expect(state.pushNotifications, isTrue);
  });
}

