import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_quran_hadith/utils/constants.dart';
import 'package:daily_quran_hadith/utils/date_utils.dart' as app_date_utils;

class ReadingStatsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  int _readingStreak = 0;
  DateTime? _lastReadDate;
  int _totalVersesRead = 0;
  int _totalHadithRead = 0;

  int get readingStreak => _readingStreak;
  DateTime? get lastReadDate => _lastReadDate;
  int get totalVersesRead => _totalVersesRead;
  int get totalHadithRead => _totalHadithRead;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadStats();
  }

  void _loadStats() {
    _readingStreak = _prefs.getInt(AppConstants.keyReadingStreak) ?? 0;
    final lastReadDateStr =
        _prefs.getString(AppConstants.keyLastReadDate);
    if (lastReadDateStr != null) {
      _lastReadDate = DateTime.parse(lastReadDateStr);
    }
    _totalVersesRead = _prefs.getInt('totalVersesRead') ?? 0;
    _totalHadithRead = _prefs.getInt('totalHadithRead') ?? 0;
  }

  Future<void> recordVerseRead() async {
    _totalVersesRead++;
    await _updateStreak();
    await _prefs.setInt('totalVersesRead', _totalVersesRead);
    notifyListeners();
  }

  Future<void> recordHadithRead() async {
    _totalHadithRead++;
    await _updateStreak();
    await _prefs.setInt('totalHadithRead', _totalHadithRead);
    notifyListeners();
  }

  Future<void> _updateStreak() async {
    final now = DateTime.now();
    if (_lastReadDate == null) {
      _readingStreak = 1;
    } else if (app_date_utils.DateUtils.isToday(_lastReadDate!)) {
      // Already read today, streak continues
    } else if (_lastReadDate!
        .add(const Duration(days: 1))
        .isBefore(now)) {
      // Missed a day, reset streak
      _readingStreak = 1;
    } else {
      _readingStreak++;
    }

    _lastReadDate = now;
    await _prefs.setInt(AppConstants.keyReadingStreak, _readingStreak);
    await _prefs.setString(
      AppConstants.keyLastReadDate,
      now.toIso8601String(),
    );
  }

  String getStreakMessage() {
    if (_readingStreak == 0) {
      return 'Start your reading journey';
    } else if (_readingStreak == 1) {
      return 'Great! You\'re on a 1-day streak';
    } else if (_readingStreak < 7) {
      return 'Excellent! $_readingStreak days in a row';
    } else if (_readingStreak < 30) {
      return 'Amazing! $_readingStreak days streak - keep it up!';
    } else {
      return 'Mashallah! You\'ve been consistent for $_readingStreak days';
    }
  }
}
