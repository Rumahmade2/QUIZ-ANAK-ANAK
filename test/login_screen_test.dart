import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/screens/login_screen.dart';
import 'package:flutter_application_3/services/settings_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'users_list': ['default'],
      'current_user': 'default',
    });
  });

  testWidgets('add user and select it', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();

    // Initially shows default
    expect(find.text('default'), findsWidgets);

    // Register new user
    await tester.enterText(find.byType(TextField).first, 'alice');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    // alice should appear
    expect(find.text('alice'), findsWidgets);

    final current = await SettingsService.getCurrentUser();
    expect(current, 'alice');

    // Delete alice
    final aliceTile = find.widgetWithText(ListTile, 'alice');
    expect(aliceTile, findsOneWidget);

    final aliceDelete =
        find.descendant(of: aliceTile, matching: find.byIcon(Icons.delete));
    expect(aliceDelete, findsOneWidget);

    await tester.tap(aliceDelete);
    await tester.pumpAndSettle();

    expect(find.text('alice'), findsNothing);
  });
}
