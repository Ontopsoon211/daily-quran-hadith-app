class AppConstants {
  // App info
  static const String appName = 'Daily Quran & Hadith';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API endpoints
  static const String quranApiBaseUrl = 'https://api.quran.com/api/v4';
  static const String quranApiTimeout = '10'; // seconds

  // Notification settings
  static const String notificationChannelId = 'daily_quran_channel';
  static const String notificationChannelName = 'Daily Quran Notifications';

  // Shared preferences keys
  static const String keyThemeMode = 'isDarkMode';
  static const String keyReminderEnabled = 'reminderEnabled';
  static const String keyReminderTime = 'reminderTime';
  static const String keyReadingStreak = 'readingStreak';
  static const String keyLastReadDate = 'lastReadDate';
  static const String keyFavorites = 'favorites';
  static const String keyLocale = 'locale';

  // Quran data
  static const int totalSurahs = 114;
  static const List<String> arabicNumerals = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];
}
