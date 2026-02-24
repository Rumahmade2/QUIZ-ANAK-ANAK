import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _timeKey = 'time_per_question';
  static const _autoAdvanceKey = 'auto_advance';
  static const _advanceDelayKey = 'advance_delay_ms';

  static Future<int> getTimePerQuestion() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_timeKey) ?? 15;
  }

  static Future<void> setTimePerQuestion(int seconds) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_timeKey, seconds);
  }

  static Future<bool> getAutoAdvance() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_autoAdvanceKey) ?? true;
  }

  static Future<void> setAutoAdvance(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_autoAdvanceKey, v);
  }

  static Future<int> getAdvanceDelay() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_advanceDelayKey) ?? 700; // ms
  }

  static Future<void> setAdvanceDelay(int ms) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_advanceDelayKey, ms);
  }

  // user handling (simple multi-user support)
  static const _userKey = 'current_user';

  static Future<String> getCurrentUser() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_userKey) ?? 'default';
  }

  static Future<void> setCurrentUser(String name) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_userKey, name);
  }

  // simple user list management
  static const _usersKey = 'users_list';

  static Future<List<String>> getUsers() async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_usersKey) ?? ['default'];
    return list;
  }

  static Future<void> addUser(String name) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_usersKey) ?? ['default'];
    if (!list.contains(name)) {
      list.add(name);
      await p.setStringList(_usersKey, list);
    }
  }

  static Future<void> deleteUser(String name) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_usersKey) ?? ['default'];
    list.remove(name);
    await p.setStringList(_usersKey, list);
    final current = await getCurrentUser();
    if (current == name) {
      final newCurrent = list.isNotEmpty ? list.first : 'default';
      await setCurrentUser(newCurrent);
    }
  }

  // last selected tab index persistence
  static const _lastTabIndexKey = 'last_tab_index';

  static Future<int> getLastTabIndex() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_lastTabIndexKey) ?? 0;
  }

  static Future<void> setLastTabIndex(int index) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_lastTabIndexKey, index);
  }

  // confetti settings
  static const _confettiEnabledKey = 'confetti_enabled';
  static const _confettiIntensityKey = 'confetti_intensity';

  static Future<bool> getConfettiEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_confettiEnabledKey) ?? true;
  }

  static Future<void> setConfettiEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_confettiEnabledKey, v);
  }

  static Future<int> getConfettiIntensity() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_confettiIntensityKey) ?? 20; // numberOfParticles
  }

  static Future<void> setConfettiIntensity(int v) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_confettiIntensityKey, v);
  }

  // unlock enforcement setting
  static const _enforceUnlocksKey = 'enforce_unlocks';

  static Future<bool> getEnforceUnlocks() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_enforceUnlocksKey) ?? true;
  }

  static Future<void> setEnforceUnlocks(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_enforceUnlocksKey, v);
  }

  // unlock sound setting
  static const _unlockSoundKey = 'unlock_sound_enabled';

  static Future<bool> getUnlockSoundEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_unlockSoundKey) ?? true;
  }

  static Future<void> setUnlockSoundEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_unlockSoundKey, v);
  }

  // celebration mute (master) and custom chime setting
  static const _celebrationMutedKey = 'celebration_muted';
  static const _useCustomChimeKey = 'use_custom_chime';

  static Future<bool> getCelebrationMuted() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_celebrationMutedKey) ?? false;
  }

  static Future<void> setCelebrationMuted(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_celebrationMutedKey, v);
  }

  static Future<bool> getUseCustomChime() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_useCustomChimeKey) ?? true;
  }

  static Future<void> setUseCustomChime(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_useCustomChimeKey, v);
  }
}
