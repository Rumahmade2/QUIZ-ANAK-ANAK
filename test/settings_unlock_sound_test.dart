import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/services/settings_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('unlock sound setting default and toggle', () async {
    final defaultVal = await SettingsService.getUnlockSoundEnabled();
    expect(defaultVal, isTrue);

    await SettingsService.setUnlockSoundEnabled(false);
    final val = await SettingsService.getUnlockSoundEnabled();
    expect(val, isFalse);
  });
}