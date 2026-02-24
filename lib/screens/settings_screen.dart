import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _time = 15;
  bool _auto = true;
  int _delay = 700;
  bool _loading = true;
  bool _confettiEnabled = true;
  int _confettiIntensity = 20;
  String _user = '';

  final Color mainColor = const Color(0xFF7C4DFF);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _time = await SettingsService.getTimePerQuestion();
    _auto = await SettingsService.getAutoAdvance();
    _delay = await SettingsService.getAdvanceDelay();
    _user = await SettingsService.getCurrentUser();
    _confettiEnabled = await SettingsService.getConfettiEnabled();
    _confettiIntensity = await SettingsService.getConfettiIntensity();

    setState(() => _loading = false);
  }

  Future<void> _save() async {
    await SettingsService.setTimePerQuestion(_time);
    await SettingsService.setAutoAdvance(_auto);
    await SettingsService.setAdvanceDelay(_delay);
    await SettingsService.setCurrentUser(_user.trim().isEmpty ? 'default' : _user.trim());
    await SettingsService.setConfettiEnabled(_confettiEnabled);
    await SettingsService.setConfettiIntensity(_confettiIntensity);

    if (mounted) Navigator.pop(context);
  }

  BoxDecoration card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.deepPurple.shade100.withOpacity(.35),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2FF),

      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: mainColor,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== TIME SETTINGS ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "⏱ Waktu & Navigasi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 16),

                  rowTitle("Waktu per soal:"),
                  slider(
                    value: _time.toDouble(),
                    label: "$_time detik",
                    onChange: (v) => setState(() => _time = v.round()),
                    max: 60,
                    min: 5,
                  ),

                  const SizedBox(height: 10),

                  toggle(
                    "Auto-advance setelah jawab",
                    _auto,
                    (v) => setState(() => _auto = v),
                  ),

                  const SizedBox(height: 10),

                  rowTitle("Delay auto-advance:"),
                  slider(
                    value: _delay.toDouble(),
                    label: "$_delay ms",
                    min: 200,
                    max: 1500,
                    onChange: (v) => setState(() => _delay = v.round()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ====== USER ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "👤 Pengguna",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: TextEditingController(text: _user),
                    onChanged: (v) => _user = v,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfileScreen()),
                          ).then((_) => _load()),
                          child: const Text("Kelola Pengguna"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ).then((_) => _load()),
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ====== CELEBRATION ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: card(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🎉 Perayaan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  toggle("Confetti saat berhasil", _confettiEnabled,
                      (v) => setState(() => _confettiEnabled = v)),

                  const SizedBox(height: 10),

                  rowTitle("Intensitas confetti"),
                  slider(
                    value: _confettiIntensity.toDouble(),
                    min: 5,
                    max: 80,
                    onChange: (v) =>
                        setState(() => _confettiIntensity = v.round()),
                    label: "$_confettiIntensity",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Simpan Pengaturan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );

  Widget toggle(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Switch(
          value: value,
          activeColor: mainColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget slider({
    required double value,
    required Function(double) onChange,
    required double min,
    required double max,
    required String label,
  }) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 12,
            activeColor: mainColor,
            label: label,
            onChanged: onChange,
          ),
        ),
        SizedBox(width: 60, child: Text(label, textAlign: TextAlign.center)),
      ],
    );
  }
}
