class DateUtils {
  static String formatHijriDate() {
    // This is a placeholder - in production, use a proper Hijri calendar library
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year} AH';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static String getTimeFromMinutes(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static int calculateReadingStreak(DateTime lastReadDate) {
    final now = DateTime.now();
    final difference = now.difference(lastReadDate).inDays;

    if (difference == 0) {
      return 1;
    } else if (difference == 1) {
      return 1; // Reset if skipped a day
    }
    return 0;
  }
}
