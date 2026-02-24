import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  List<String> _users = [];
  String? _current;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await SettingsService.getUsers();
    final current = await SettingsService.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _users = users;
      _current = current;
    });
  }

  Future<void> _register() async {
    final name = _controller.text.trim();
    final pw = _pwController.text;
    if (name.isEmpty || pw.isEmpty) return;
    final ok = await AuthService.register(name, pw);
    if (ok) {
      await _loadUsers();
      _controller.clear();
      _pwController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pengguna "$name" terdaftar dan login.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama pengguna sudah ada.')));
    }
  }

  Future<void> _login() async {
    final name = _controller.text.trim();
    final pw = _pwController.text;
    if (name.isEmpty || pw.isEmpty) return;
    final ok = await AuthService.login(name, pw);
    if (ok) {
      await _loadUsers();
      _controller.clear();
      _pwController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil login sebagai "$name".')));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login gagal. Periksa nama & password.')));
    }
  }

  Future<void> _selectUser(String name) async {
    // selecting user without password will just set current user, but not authenticate
    await SettingsService.setCurrentUser(name);
    setState(() {
      _current = name;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berpindah ke pengguna "$name".')));
  }

  Future<void> _deleteUser(String name) async {
    await AuthService.deleteUser(name);
    await _loadUsers();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pengguna "$name" dihapus.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pengguna saat ini', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_current ?? '-', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Pilih pengguna yang ada', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: _users.isEmpty
                  ? const Center(child: Text('Belum ada pengguna.'))
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, i) {
                        final u = _users[i];
                        final isCurrent = u == _current;
                        return ListTile(
                          title: Text(u),
                          leading: isCurrent ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.person),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isCurrent)
                                IconButton(
                                  icon: const Icon(Icons.login),
                                  onPressed: () => _selectUser(u),
                                ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteUser(u),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Masuk / Daftar (dengan password)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Nama pengguna'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _pwController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _login, child: const Text('Masuk'))),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _register, child: const Text('Daftar'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
