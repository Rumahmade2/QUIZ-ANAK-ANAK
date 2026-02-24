import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/services/settings_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('users add / delete / select flow', () async {
    // initial
    var users = await SettingsService.getUsers();
    expect(users, ['default']);

    // add user
    await SettingsService.addUser('alice');
    users = await SettingsService.getUsers();
    expect(users.contains('alice'), isTrue);

    // adding duplicate does not create duplicate
    await SettingsService.addUser('alice');
    users = await SettingsService.getUsers();
    final occurrences = users.where((u) => u == 'alice').length;
    expect(occurrences, 1);

    // set current user
    await SettingsService.setCurrentUser('alice');
    var current = await SettingsService.getCurrentUser();
    expect(current, 'alice');

    // delete user
    await SettingsService.deleteUser('alice');
    users = await SettingsService.getUsers();
    expect(users.contains('alice'), isFalse);

    // current should fall back to default
    current = await SettingsService.getCurrentUser();
    expect(current, isNot('alice'));
  });

  test('last tab index persistence', () async {
    // default should be 0
    var idx = await SettingsService.getLastTabIndex();
    expect(idx, 0);

    await SettingsService.setLastTabIndex(2);
    idx = await SettingsService.getLastTabIndex();
    expect(idx, 2);
  });
}