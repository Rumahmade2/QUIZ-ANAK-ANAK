import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/question.dart';
import '../widgets/subject_card.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'subject_levels_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Difficulty _selectedDifficulty = Difficulty.mudah;

  @override
  Widget build(BuildContext context) {
    final subjects = sampleQuizzes.keys.toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFF6E5),
              Color(0xFFFFF9EF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              left: -30,
              child: _bubble(120, Colors.white.withOpacity(.25)),
            ),
            Positioned(
              bottom: 20,
              right: -10,
              child: _bubble(90, Colors.white.withOpacity(.2)),
            ),
            Positioned(
              top: 150,
              right: -20,
              child: _bubble(110, Colors.white.withOpacity(.18)),
            ),

            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text(
                  'Kuis Anak-anak',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  PopupMenuButton<Difficulty>(
                    onSelected: (d) =>
                        setState(() => _selectedDifficulty = d),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                          value: Difficulty.mudah, child: Text('Mudah')),
                      PopupMenuItem(
                          value: Difficulty.susah, child: Text('Susah')),
                      PopupMenuItem(
                        value: Difficulty.sangatSusah,
                        child: Text('Sangat Susah'),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          _labelForDifficulty(_selectedDifficulty),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HistoryScreen()),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),

              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih mata pelajaran',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.05,
                        ),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final key = subjects[index];
                          final questions = sampleQuizzes[key]!
                              .where((q) =>
                                  q.difficulty == _selectedDifficulty)
                              .toList();

                          return SubjectCard(
                            title: key,
                            icon: _iconForSubject(key),
                            questionCount: questions.length,
                            backgroundColor: _colorForSubject(key),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SubjectLevelsScreen(subject: key),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _labelForDifficulty(Difficulty d) {
    switch (d) {
      case Difficulty.mudah:
        return 'Mudah';
      case Difficulty.susah:
        return 'Susah';
      case Difficulty.sangatSusah:
        return 'Sangat Susah';
    }
  }

  IconData _iconForSubject(String key) {
    switch (key) {
      case 'Matematika':
        return Icons.calculate;
      case 'Bahasa Indonesia':
        return Icons.menu_book;
      case 'IPA':
        return Icons.science;
      case 'Bahasa Inggris':
        return Icons.language;
      default:
        return Icons.school;
    }
  }

  Color _colorForSubject(String key) {
    switch (key) {
      case 'Matematika':
        return const Color(0xFF4CAF50);
      case 'Bahasa Indonesia':
        return const Color(0xFFFF7043);
      case 'IPA':
        return const Color(0xFF29B6F6);
      case 'Bahasa Inggris':
        return const Color(0xFFAB47BC);
      default:
        return Colors.blueGrey;
    }
  }
}
