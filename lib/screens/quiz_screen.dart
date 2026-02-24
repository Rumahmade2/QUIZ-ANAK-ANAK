import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/question.dart';
import '../widgets/question_card.dart';
import '../models/score_result.dart';
import '../services/storage_service.dart';
import '../services/settings_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final List<Question> questions;
  final int timePerQuestion;
  final Difficulty difficulty;

  const QuizScreen({
    Key? key,
    required this.subject,
    required this.questions,
    this.timePerQuestion = 15,
    required this.difficulty,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  int _selected = -1;
  bool _answered = false;
  late List<int> _selectedAnswers;
  late List<int> _timeSpent;

  Timer? _timer;
  late int _timeLeft;

  // settings
  late int _timePerQuestion;
  bool _autoAdvance = true;
  int _advanceDelay = 700;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int>.filled(widget.questions.length, -1);
    _timeSpent = List<int>.filled(widget.questions.length, 0);
    _timePerQuestion = widget.timePerQuestion;
    _loadSettings();
    _startTimer();
  }

  Future<void> _loadSettings() async {
    final t = await SettingsService.getTimePerQuestion();
    final a = await SettingsService.getAutoAdvance();
    final d = await SettingsService.getAdvanceDelay();
    if (!mounted) return;
    setState(() {
      _timePerQuestion = t;
      _autoAdvance = a;
      _advanceDelay = d;
    });
    // restart timer with new time if changed
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          t.cancel();
          _onTimeout();
        }
      });
    });
  }

  void _onTimeout() {
    if (!_answered) {
      setState(() {
        _selected = -1;
        _answered = true;
        _selectedAnswers[_index] = -1;
        _timeSpent[_index] = _timePerQuestion; // used full time
      });
      if (_autoAdvance)
        Future.delayed(Duration(milliseconds: _advanceDelay), () => _goNext());
    }
  }

  void _selectOption(int i) {
    if (_answered) return;
    _timer?.cancel();
    setState(() {
      _selected = i;
      _answered = true;
      _selectedAnswers[_index] = i;
      _timeSpent[_index] = _timePerQuestion - _timeLeft;
      if (i == widget.questions[_index].answerIndex) _score++;
    });
    if (_autoAdvance)
      Future.delayed(Duration(milliseconds: _advanceDelay), () => _goNext());
  }

  void _goNext() {
    if (_index < widget.questions.length - 1) {
      setState(() {
        _index++;
        _selected = -1;
        _answered = false;
      });
      _startTimer();
    } else {
      _finish();
    }
  }

  void _manualNext() {
    // allow user to manually proceed earlier
    _timer?.cancel();
    if (_index < widget.questions.length - 1) {
      setState(() {
        _index++;
        _selected = -1;
        _answered = false;
      });
      _startTimer();
    } else {
      _finish();
    }
  }

  void _finish() async {
    _timer?.cancel();
    final user = await SettingsService.getCurrentUser();
    final result = ScoreResult(
      subject: widget.subject,
      user: user,
      score: _score,
      total: widget.questions.length,
      date: DateTime.now(),
      selectedAnswers: _selectedAnswers,
      perQuestionTime: _timeSpent,
      difficulty: widget.difficulty,
    );
    await StorageService.saveResult(result);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            ResultScreen(result: result, questions: widget.questions),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_index];
    final pct = (_timeLeft / _timePerQuestion);
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: SvgPicture.asset('assets/images/wave.svg', fit: BoxFit.cover),
            ),
          ),
          // decorative background shapes
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 300,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soal ${_index + 1} / ${widget.questions.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Skor: $_score',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: pct, minHeight: 8),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Waktu: $_timeLeft s',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: QuestionCard(
                      question: q,
                      index: _index,
                      selectedIndex: _selected,
                      answered: _answered,
                      onSelect: _selectOption,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _answered ? _manualNext : null,
                        child: Text(
                          _index < widget.questions.length - 1
                              ? 'Berikutnya'
                              : 'Selesai',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
