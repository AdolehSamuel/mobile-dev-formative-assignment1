// Basic smoke test for ALU Connect: verifies the app boots and shows the
// branded splash screen without throwing.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alu_connect/main.dart';
import 'package:alu_connect/state/app_state.dart';

void main() {
  testWidgets('App boots and shows the splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();

    await tester.pumpWidget(ALUConnectApp(appState: appState));

    expect(find.text('ALU Connect'), findsOneWidget);
    expect(find.text('Connect. Collaborate. Lead together.'), findsOneWidget);

    // Let the splash screen's navigation timer fire and the fade
    // transition into onboarding settle, so no timers are left pending.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();

    expect(find.text("Discover what's happening"), findsOneWidget);
  });
}
