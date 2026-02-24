import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/score_result.dart';
import '../models/question.dart';
import '../services/settings_service.dart';

class StorageService {
  static String _keyForUser(String user) => 'quiz_history_$user';

  static Future<void> saveResult(ScoreResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForUser(result.user);
    final list = prefs.getStringList(key) ?? [];
    list.add(jsonEncode(result.toJson()));
    await prefs.setStringList(key, list);
  }

  static Future<List<ScoreResult>> getResults({String? forUser}) async {
    final prefs = await SharedPreferences.getInstance();
    final user = forUser ?? await SettingsService.getCurrentUser();
    final list = prefs.getStringList(_keyForUser(user)) ?? [];
    return list
        .map((e) => ScoreResult.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> clearResults({String? forUser}) async {
    final prefs = await SharedPreferences.getInstance();
    final user = forUser ?? await SettingsService.getCurrentUser();
    await prefs.remove(_keyForUser(user));
  }

  static Future<String> exportCsv({String? forUser}) async {
    final user = forUser ?? await SettingsService.getCurrentUser();
    final results = await getResults(forUser: user);
    final rows = <List<String>>[];
    rows.add([
      'user',
      'subject',
      'difficulty',
      'score',
      'total',
      'percent',
      'date',
      'selectedAnswers',
      'perQuestionTime',
    ]);
    for (final r in results) {
      rows.add([
        r.user,
        r.subject,
        r.difficulty.toString().split('.').last,
        r.score.toString(),
        r.total.toString(),
        r.percent.toStringAsFixed(1),
        r.date.toIso8601String(),
        r.selectedAnswers.join('|'),
        r.perQuestionTime.join('|'),
      ]);
    }

    final csv = rows
        .map((r) => r.map((c) => '"${c.toString().replaceAll('"', '""')}"').join(','))
        .join('\n');

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/quiz_history_$user.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  // get best percent for subject + difficulty for current or specific user
  static Future<double> getBestPercent(String subject, Difficulty difficulty, {String? forUser}) async {
    final results = await getResults(forUser: forUser);
    final filtered = results.where((r) => r.subject == subject && r.difficulty == difficulty);
    if (filtered.isEmpty) return 0.0;
    return filtered.map((r) => r.percent).reduce((a, b) => a > b ? a : b);
  }

  static Future<List<ScoreResult>> getResultsFiltered(String subject, Difficulty difficulty, {String? forUser, int limit = 5}) async {
    final results = await getResults(forUser: forUser);
    final filtered = results
        .where((r) => r.subject == subject && r.difficulty == difficulty)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (filtered.length <= limit) return filtered;
    return filtered.sublist(0, limit);
  }

  // Determine if a difficulty level is unlocked. Level 'mudah' (first) is always unlocked.
  // Subsequent levels unlock when the previous level best percent >= 80.0
  static Future<bool> isLevelUnlocked(String subject, Difficulty difficulty, {String? forUser}) async {
    final enforce = await SettingsService.getEnforceUnlocks();
    if (!enforce) return true;
    if (difficulty == Difficulty.mudah) return true;
    final prev = difficulty == Difficulty.susah ? Difficulty.mudah : Difficulty.susah;
    final bestPrev = await getBestPercent(subject, prev, forUser: forUser);
    return bestPrev >= 80.0;
  }
}
