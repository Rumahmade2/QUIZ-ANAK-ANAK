import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_3/models/score_result.dart';
import 'package:flutter_application_3/models/question.dart';
import 'package:flutter_application_3/services/storage_service.dart';
import 'package:flutter_application_3/services/settings_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('save result and get best percent by difficulty', () async {
    final r1 = ScoreResult(
      subject: 'Matematika',
      user: 'default',
      score: 4,
      total: 5,
      date: DateTime.now(),
      selectedAnswers: [0,1,2,3,4],
      perQuestionTime: [5,6,7,8,9],
      difficulty: Difficulty.mudah,
    );

    final r2 = ScoreResult(
      subject: 'Matematika',
      user: 'default',
      score: 5,
      total: 5,
      date: DateTime.now(),
      selectedAnswers: [0,1,2,3,4],
      perQuestionTime: [5,6,7,8,9],
      difficulty: Difficulty.mudah,
    );

    await StorageService.saveResult(r1);
    await StorageService.saveResult(r2);

    final best = await StorageService.getBestPercent('Matematika', Difficulty.mudah);
    expect(best, closeTo(100.0, 0.01));

    // unlocking behavior: after achieving 100% in Level 1, Level 2 should be unlocked
    var unlockedLevel2 = await StorageService.isLevelUnlocked('Matematika', Difficulty.susah);
    expect(unlockedLevel2, isTrue);

    // Level 3 remains locked until level 2 has high score
    var unlockedLevel3 = await StorageService.isLevelUnlocked('Matematika', Difficulty.sangatSusah);
    expect(unlockedLevel3, isFalse);

    // If enforcement is disabled, everything should be unlocked
    await SettingsService.setEnforceUnlocks(false);
    unlockedLevel2 = await StorageService.isLevelUnlocked('Matematika', Difficulty.susah);
    unlockedLevel3 = await StorageService.isLevelUnlocked('Matematika', Difficulty.sangatSusah);
    expect(unlockedLevel2, isTrue);
    expect(unlockedLevel3, isTrue);

    // getResultsFiltered returns recent results
    final filtered = await StorageService.getResultsFiltered('Matematika', Difficulty.mudah);
    expect(filtered.length, greaterThanOrEqualTo(2));
  });
}
