import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daily_quran_hadith/models/models.dart';

class QuranService {
  static const String baseUrl = 'https://api.quran.com/api/v4';

  // Fetch a single surah
  static Future<Surah?> fetchSurah(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/quran/verses/uthmani?chapter_number=$surahNumber'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['verses'] != null && data['verses'].isNotEmpty) {
          return Surah(
            number: surahNumber,
            name: 'Surah $surahNumber',
            englishName: 'Chapter $surahNumber',
            numberOfAyahs: data['verses'].length,
            revelationType: 'Unknown',
            ayahs: (data['verses'] as List)
                .map((v) => Ayah(
                      number: v['id'],
                      text: v['text_uthmani'] ?? '',
                      numberInSurah: v['verse_number']?.toString() ?? '',
                      juz: '',
                      manzil: '',
                      page: '',
                      ruku: '',
                      hizbQuarter: '',
                      sajdah: false,
                    ))
                .toList(),
          );
        }
      }
      return null;
    } catch (e) {
      print('Error fetching surah: $e');
      return null;
    }
  }

  // Fetch all surahs list
  static Future<List<Surah>> fetchAllSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chapters?language=en'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['chapters'] != null) {
          return (data['chapters'] as List)
              .map((c) => Surah(
                    number: c['id'],
                    name: c['name_arabic'] ?? '',
                    englishName: c['name_simple'] ?? '',
                    numberOfAyahs: c['verses_count'] ?? 0,
                    revelationType: c['revelation_place'] ?? '',
                    ayahs: [],
                  ))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching surahs: $e');
      return [];
    }
  }

  // Get random ayah
  static Future<QuranVerse?> getRandomAyah() async {
    try {
      final surahNumber = (DateTime.now().millisecond % 114) + 1;
      final response = await http.get(
        Uri.parse('$baseUrl/quran/verses/uthmani?chapter_number=$surahNumber'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['verses'] != null && data['verses'].isNotEmpty) {
          final verses = data['verses'] as List;
          final randomVerse =
              verses[DateTime.now().millisecond % verses.length];
          return QuranVerse(
            surah: 'Chapter $surahNumber',
            ayah: '${randomVerse['verse_number']}',
            arabic: randomVerse['text_uthmani'] ?? '',
            translation: 'Arabic verse',
            note: 'Random verse from the Quran',
          );
        }
      }
      return null;
    } catch (e) {
      print('Error getting random ayah: $e');
      return null;
    }
  }
}
