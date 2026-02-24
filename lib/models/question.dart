enum Difficulty { mudah, susah, sangatSusah }

class Question {
  final String text;
  final List<String> options;
  final int answerIndex;
  final Difficulty difficulty;
  final String? explanation;

  Question({
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.difficulty,
    this.explanation,
  });
} 
