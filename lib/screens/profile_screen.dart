import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _users = [];
  String _current = '';
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await SettingsService.getUsers();
    final c = await SettingsService.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _users = u;
      _current = c;
    });
  }

  Future<void> _add() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    await SettingsService.addUser(name);
    _controller.clear();
    await _load();
  }

  Future<void> _delete(String name) async {
    await SettingsService.deleteUser(name);
    await _load();
  }

  Future<void> _setCurrent(String name) async {
    await SettingsService.setCurrentUser(name);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nama pengguna',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Tambah')),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final u = _users[index];
                  return ListTile(
                    title: Text(u),
                    leading: Radio<String>(
                      value: u,
                      groupValue: _current,
                      onChanged: (v) => _setCurrent(u),
                    ),
                    trailing: u == 'default'
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(u),
                          ),
                    onTap: () => _setCurrent(u),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
