import 'package:daily_quran_hadith/models/models.dart';
import 'package:daily_quran_hadith/utils/app_logger.dart';

class HadithRepository {
  // Sample hadiths data
  final List<HadithItem> _hadiths = [
    HadithItem(
      title: 'Seeking knowledge',
      arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا',
      english:
          'Whoever travels a path in search of knowledge, Allah will make the path to Paradise easy for him.',
      source: 'Sahih Muslim',
    ),
    HadithItem(
      title: 'Remembering Allah',
      arabic: 'مَنْ ذَكَرَنِي فِي نَفْسِهِ ذَكَرْتُهُ فِي نَفْسِي',
      english:
          'Whoever remembers Me in himself, I remember him in Myself.',
      source: 'Sahih al-Bukhari',
    ),
    HadithItem(
      title: 'Good character',
      arabic: 'إِنَّمَا بُعِثْتُ لأُتَمِّمَ مَكارِمَ الأَخْلاقِ',
      english: 'I was sent to perfect noble character.',
      source: 'Muwatta Malik',
    ),
    HadithItem(
      title: 'Best of you',
      arabic: 'خَيْرُكُمْ خَيْرُكُمْ لِأَهْلِهِ',
      english: 'The best of you are those who are best to their families.',
      source: 'Jami\' at-Tirmidhi',
    ),
    HadithItem(
      title: 'Kindness to servants',
      arabic: 'اتَّقُوا اللَّهَ فِي هَذِهِ الْبَهَائِمِ الْمُسَخَّرَةِ',
      english:
          'Fear Allah regarding these beasts that are in your possession.',
      source: 'Sunan Abu Dawud',
    ),
  ];

  Future<List<HadithItem>> getAllHadiths() async {
    try {
      AppLogger.log('Fetching all hadiths...');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      AppLogger.logSuccess('Fetched ${_hadiths.length} hadiths');
      return _hadiths;
    } catch (e) {
      AppLogger.logError('Error fetching hadiths', error: e);
      return [];
    }
  }

  Future<HadithItem?> getRandomHadith() async {
    try {
      AppLogger.log('Fetching random hadith...');
      final random = _hadiths[
          DateTime.now().millisecond % _hadiths.length];
      AppLogger.logSuccess('Random hadith: ${random.title}');
      return random;
    } catch (e) {
      AppLogger.logError('Error fetching random hadith', error: e);
      return null;
    }
  }

  Future<List<HadithItem>> searchHadiths(String query) async {
    try {
      AppLogger.log('Searching hadiths with query: $query');
      final filtered = _hadiths
          .where((h) =>
              h.title.toLowerCase().contains(query.toLowerCase()) ||
              h.english.toLowerCase().contains(query.toLowerCase()) ||
              h.source.toLowerCase().contains(query.toLowerCase()))
          .toList();
      AppLogger.logSuccess('Found ${filtered.length} matching hadiths');
      return filtered;
    } catch (e) {
      AppLogger.logError('Error searching hadiths', error: e);
      return [];
    }
  }
}
