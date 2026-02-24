import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/score_result.dart';

class ResultScreen extends StatefulWidget {
  final ScoreResult result;
  final List<Question> questions;

  const ResultScreen({Key? key, required this.result, required this.questions})
    : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    if (widget.result.percent >= 80) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = widget.result.percent;
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Kuis')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.result.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: pct),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) => Text(
                    'Skor: ${widget.result.score} / ${widget.result.total} (${value.toStringAsFixed(0)}%)',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) {
                      final q = widget.questions[index];
                      final selected =
                          index < widget.result.selectedAnswers.length
                          ? widget.result.selectedAnswers[index]
                          : -1;
                      final correct = q.answerIndex;
                      final isCorrect = selected == correct;
                      final time = index < widget.result.perQuestionTime.length
                          ? widget.result.perQuestionTime[index]
                          : 0;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Soal ${index + 1} - ${q.text}',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${time}s',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Jawaban Anda: ${selected >= 0 ? q.options[selected] : 'Tidak menjawab'}',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              ),
                              Text('Jawaban Benar: ${q.options[correct]}'),
                              if (q.explanation != null) ...[
                                const SizedBox(height: 8),
                                Text('Penjelasan: ${q.explanation}', style: const TextStyle(color: Colors.black87)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst),
                        child: const Text('Selesai'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
