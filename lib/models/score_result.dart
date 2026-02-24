import 'package:flutter_application_3/models/question.dart';

class ScoreResult {
  final String subject;
  final String user;
  final int score;
  final int total;
  final DateTime date;
  final List<int> selectedAnswers;
  final List<int> perQuestionTime; // seconds spent per question
  final Difficulty difficulty;

  ScoreResult({
    required this.subject,
    required this.user,
    required this.score,
    required this.total,
    required this.date,
    required this.selectedAnswers,
    required this.perQuestionTime,
    required this.difficulty,
  });

  double get percent => total == 0 ? 0 : (score / total) * 100;

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'user': user,
    'score': score,
    'total': total,
    'date': date.toIso8601String(),
    'selectedAnswers': selectedAnswers,
    'perQuestionTime': perQuestionTime,
    'difficulty': difficulty.toString().split('.').last,
  };

  factory ScoreResult.fromJson(Map<String, dynamic> json) => ScoreResult(
    subject: json['subject'] as String,
    user: json['user'] as String? ?? 'default',
    score: json['score'] as int,
    total: json['total'] as int,
    date: DateTime.parse(json['date'] as String),
    selectedAnswers: List<int>.from(
      (json['selectedAnswers'] ?? []).map((e) => e as int),
    ),
    perQuestionTime: List<int>.from(
      (json['perQuestionTime'] ?? []).map((e) => e as int),
    ),
    difficulty: _parseDifficulty(json['difficulty'] as String?),
  );

  static Difficulty _parseDifficulty(String? s) {
    switch (s) {
      case 'mudah':
        return Difficulty.mudah;
      case 'susah':
        return Difficulty.susah;
      case 'sangatSusah':
      case 'sangat_susah':
      case 'sangat-susah':
        return Difficulty.sangatSusah;
      default:
        return Difficulty.mudah;
    }
  }
} 
