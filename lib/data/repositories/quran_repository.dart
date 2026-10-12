import 'package:daily_quran_hadith/models/models.dart';
import 'package:daily_quran_hadith/services/quran_service.dart';
import 'package:daily_quran_hadith/utils/app_logger.dart';

class QuranRepository {
  final QuranService _quranService = QuranService();

  Future<List<Surah>> fetchAllSurahs() async {
    try {
      AppLogger.log('Fetching all surahs...');
      final surahs = await _quranService.fetchAllSurahs();
      AppLogger.logSuccess('Fetched ${surahs.length} surahs');
      return surahs;
    } catch (e) {
      AppLogger.logError('Error fetching surahs', error: e);
      rethrow;
    }
  }

  Future<Surah?> fetchSurah(int surahNumber) async {
    try {
      AppLogger.log('Fetching surah $surahNumber...');
      final surah = await _quranService.fetchSurah(surahNumber);
      if (surah != null) {
        AppLogger.logSuccess('Fetched surah ${surah.number}');
      }
      return surah;
    } catch (e) {
      AppLogger.logError('Error fetching surah $surahNumber', error: e);
      return null;
    }
  }

  Future<QuranVerse?> getRandomAyah() async {
    try {
      AppLogger.log('Fetching random ayah...');
      final verse = await _quranService.getRandomAyah();
      if (verse != null) {
        AppLogger.logSuccess('Random ayah fetched: ${verse.surah}');
      }
      return verse;
    } catch (e) {
      AppLogger.logError('Error fetching random ayah', error: e);
      return null;
    }
  }

  Future<List<QuranVerse>> searchVerses(String query) async {
    try {
      AppLogger.log('Searching verses with query: $query');
      // This would integrate with a search API in production
      return [];
    } catch (e) {
      AppLogger.logError('Error searching verses', error: e);
      return [];
    }
  }
}
