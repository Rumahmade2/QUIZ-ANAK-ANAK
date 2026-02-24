import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/services/auth_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('register, login, delete user', () async {
    final username = 'bob';
    final pw = 'secret';

    // register
    final reg = await AuthService.register(username, pw);
    expect(reg, isTrue);

    // login sukses
    final ok = await AuthService.login(username, pw);
    expect(ok, isTrue);

    // login gagal (password salah)
    final wrong = await AuthService.login(username, 'nope');
    expect(wrong, isFalse);

    // hapus user
    await AuthService.deleteUser(username);

    // setelah dihapus, login harus gagal
    final loginAfterDelete = await AuthService.login(username, pw);
    expect(loginAfterDelete, isFalse);
  });
}
