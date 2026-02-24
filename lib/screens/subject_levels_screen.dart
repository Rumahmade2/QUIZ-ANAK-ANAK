import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/sample_data.dart';
import '../models/question.dart';
import '../services/storage_service.dart';
import '../services/settings_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'quiz_screen.dart';

class SubjectLevelsScreen extends StatefulWidget {
  final String subject;

  const SubjectLevelsScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<SubjectLevelsScreen> createState() => _SubjectLevelsScreenState();
}

class _SubjectLevelsScreenState extends State<SubjectLevelsScreen> {
  final Map<Difficulty, double> _best = {
    Difficulty.mudah: 0.0,
    Difficulty.susah: 0.0,
    Difficulty.sangatSusah: 0.0,
  };

  final Map<Difficulty, bool> _unlocked = {
    Difficulty.mudah: true,
    Difficulty.susah: false,
    Difficulty.sangatSusah: false,
  };

  final Map<Difficulty, List> _recent = {
    Difficulty.mudah: <dynamic>[],
    Difficulty.susah: <dynamic>[],
    Difficulty.sangatSusah: <dynamic>[],
  };

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadBestAndLocks();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadBestAndLocks() async {
    final b1 = await StorageService.getBestPercent(widget.subject, Difficulty.mudah);
    final b2 = await StorageService.getBestPercent(widget.subject, Difficulty.susah);
    final b3 = await StorageService.getBestPercent(widget.subject, Difficulty.sangatSusah);
    final u1 = await StorageService.isLevelUnlocked(widget.subject, Difficulty.mudah);
    final u2 = await StorageService.isLevelUnlocked(widget.subject, Difficulty.susah);
    final u3 = await StorageService.isLevelUnlocked(widget.subject, Difficulty.sangatSusah);

    final r1 = await StorageService.getResultsFiltered(widget.subject, Difficulty.mudah);
    final r2 = await StorageService.getResultsFiltered(widget.subject, Difficulty.susah);
    final r3 = await StorageService.getResultsFiltered(widget.subject, Difficulty.sangatSusah);

    if (!mounted) return;

    // detect newly unlocked levels
    final previouslyUnlocked = Map<Difficulty, bool>.from(_unlocked);

    setState(() {
      _best[Difficulty.mudah] = b1;
      _best[Difficulty.susah] = b2;
      _best[Difficulty.sangatSusah] = b3;

      _unlocked[Difficulty.mudah] = u1;
      _unlocked[Difficulty.susah] = u2;
      _unlocked[Difficulty.sangatSusah] = u3;

      _recent[Difficulty.mudah] = r1;
      _recent[Difficulty.susah] = r2;
      _recent[Difficulty.sangatSusah] = r3;
    });

    // after state update, check for newly unlocked levels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final d in Difficulty.values) {
        final wasLocked = !(previouslyUnlocked[d] ?? false);
        final nowUnlocked = _unlocked[d] ?? false;
        if (wasLocked && nowUnlocked) {
          // Respect celebration mute & confetti setting before playing
          SettingsService.getCelebrationMuted().then((muted) async {
            if (!muted) {
              final confettiEnabled = await SettingsService.getConfettiEnabled();
              if (confettiEnabled) {
                _confettiController.play();
              }

              final unlockSoundEnabled = await SettingsService.getUnlockSoundEnabled();
              if (unlockSoundEnabled) {
                final useCustom = await SettingsService.getUseCustomChime();
                if (useCustom) {
                  try {
                    final player = AudioPlayer();
                    await player.play(AssetSource('assets/sounds/chime.mp3'));
                  } catch (e) {
                    try {
                      FlutterRingtonePlayer.playNotification();
                    } catch (_) {}
                  }
                } else {
                  try {
                    FlutterRingtonePlayer.playNotification();
                  } catch (_) {}
                }
              }
            }
          });

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Level Terbuka!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Selamat! ${_labelForDifficulty(d)} baru saja terbuka.'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [Colors.green, Colors.yellow, Colors.orange],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
              ],
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = sampleQuizzes[widget.subject] ?? [];
    final counts = {
      Difficulty.mudah: questions.where((q) => q.difficulty == Difficulty.mudah).length,
      Difficulty.susah: questions.where((q) => q.difficulty == Difficulty.susah).length,
      Difficulty.sangatSusah: questions.where((q) => q.difficulty == Difficulty.sangatSusah).length,
    };

    Widget levelCard(String label, Difficulty d, Color color, IconData icon, String shortLabel) {
      final isUnlocked = _unlocked[d] ?? false;
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            ListTile(
              onTap: isUnlocked && counts[d]! > 0
                  ? () {
                      final qs = questions.where((q) => q.difficulty == d).toList();
                      if (AuthService.isLoggedIn()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => QuizScreen(subject: widget.subject, questions: qs, difficulty: d),
                        )).then((_) => _loadBestAndLocks());
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Perlu Login'),
                            content: const Text('Anda harus masuk untuk memulai kuis. Apakah ingin masuk sekarang?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())).then((_) => _loadBestAndLocks());
                                },
                                child: const Text('Masuk'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  : null,
              leading: CircleAvatar(backgroundColor: isUnlocked ? color : Colors.grey.shade400, child: Icon(icon, color: Colors.white)),
              title: Text(shortLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$label — ${counts[d]} soal'),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: (_best[d] ?? 0) / 100, minHeight: 6, backgroundColor: Colors.grey.shade200, color: isUnlocked ? color : Colors.grey),
                  const SizedBox(height: 6),
                  Text('Terbaik: ${_best[d]!.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
              trailing: counts[d]! > 0
                  ? ElevatedButton(
                      onPressed: isUnlocked
                          ? () {
                              final qs = questions.where((q) => q.difficulty == d).toList();
                              if (AuthService.isLoggedIn()) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => QuizScreen(subject: widget.subject, questions: qs, difficulty: d),
                                )).then((_) => _loadBestAndLocks());
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Perlu Login'),
                                    content: const Text('Anda harus masuk untuk memulai kuis. Apakah ingin masuk sekarang?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())).then((_) => _loadBestAndLocks());
                                        },
                                        child: const Text('Masuk'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          : null,
                      child: isUnlocked ? const Text('Mulai') : const Text('Terkunci'),
                    )
                  : const Text('Kosong', style: TextStyle(color: Colors.grey)),
            ),

            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [Icon(Icons.lock, size: 28, color: Colors.black45), SizedBox(height: 6), Text('Terkunci — capai 80% di level sebelumnya', style: TextStyle(fontSize: 12, color: Colors.black45))],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Level', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            levelCard('Level Satu (Mudah)', Difficulty.mudah, Colors.green.shade700, Icons.looks_one, 'Level Satu'),
            if ((_recent[Difficulty.mudah] ?? []).isNotEmpty)
              ExpansionTile(
                title: Text('Riwayat (${(_recent[Difficulty.mudah]?.length ?? 0)} terakhir)'),
                children: (_recent[Difficulty.mudah] as List)
                    .map((r) => ListTile(
                          dense: true,
                          title: Text('${r.percent.toStringAsFixed(0)}% — ${r.date.toLocal().toString().split('.').first}'),
                          subtitle: Text('Score: ${r.score}/${r.total}'),
                        ))
                    .toList(),
              ),

            levelCard('Level Dua (Susah)', Difficulty.susah, Colors.orange.shade700, Icons.looks_two, 'Level Dua'),
            if ((_recent[Difficulty.susah] ?? []).isNotEmpty)
              ExpansionTile(
                title: Text('Riwayat (${(_recent[Difficulty.susah]?.length ?? 0)} terakhir)'),
                children: (_recent[Difficulty.susah] as List)
                    .map((r) => ListTile(
                          dense: true,
                          title: Text('${r.percent.toStringAsFixed(0)}% — ${r.date.toLocal().toString().split('.').first}'),
                          subtitle: Text('Score: ${r.score}/${r.total}'),
                        ))
                    .toList(),
              ),

            levelCard('Level Tiga (Sangat Susah)', Difficulty.sangatSusah, Colors.red.shade700, Icons.looks_3, 'Level Tiga'),
            if ((_recent[Difficulty.sangatSusah] ?? []).isNotEmpty)
              ExpansionTile(
                title: Text('Riwayat (${(_recent[Difficulty.sangatSusah]?.length ?? 0)} terakhir)'),
                children: (_recent[Difficulty.sangatSusah] as List)
                    .map((r) => ListTile(
                          dense: true,
                          title: Text('${r.percent.toStringAsFixed(0)}% — ${r.date.toLocal().toString().split('.').first}'),
                          subtitle: Text('Score: ${r.score}/${r.total}'),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 16),
            const Text('Tip: Pilih level untuk memulai kuis pada tingkat kesulitan yang diinginkan.'),
          ],
        ),
      ),
    );
  }

  String _labelForDifficulty(Difficulty d) {
    switch (d) {
      case Difficulty.mudah:
        return 'Level Satu (Mudah)';
      case Difficulty.susah:
        return 'Level Dua (Susah)';
      case Difficulty.sangatSusah:
        return 'Level Tiga (Sangat Susah)';
    }
  }
}
