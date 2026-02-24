import 'package:firebase_auth/firebase_auth.dart';
import 'settings_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Konversi username → email palsu (wajib untuk Firebase Auth)
  static String _email(String username) => '$username@quiz-anak.com';

  /// ======================
  /// REGISTER (DAFTAR)
  /// ======================
  static Future<bool> register(String username, String password) async {
    try {
      final existing = await SettingsService.getUsers();
      if (existing.contains(username)) return false;

      await _auth.createUserWithEmailAndPassword(
        email: _email(username),
        password: password,
      );

      await SettingsService.addUser(username);
      await SettingsService.setCurrentUser(username);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  /// ======================
  /// LOGIN
  /// ======================
  static Future<bool> login(String username, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email(username),
        password: password,
      );

      await SettingsService.setCurrentUser(username);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  /// ======================
  /// LOGOUT
  /// ======================
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// ======================
  /// STATUS LOGIN
  /// ======================
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  static Future<String?> getLoggedInUser() async {
    return await SettingsService.getCurrentUser();
  }

  /// ======================
  /// DELETE USER
  /// ======================
  static Future<void> deleteUser(String username) async {
    final user = _auth.currentUser;
    if (user != null && user.email == _email(username)) {
      await user.delete();
    }
    await SettingsService.deleteUser(username);
  }
}
