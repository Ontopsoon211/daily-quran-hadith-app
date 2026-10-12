import 'package:flutter/material.dart';
import 'package:daily_quran_hadith/data/repositories/hadith_repository.dart';
import 'package:daily_quran_hadith/data/repositories/quran_repository.dart';
import 'package:daily_quran_hadith/models/models.dart';

class AppStateProvider extends ChangeNotifier {
  final QuranRepository _quranRepository = QuranRepository();
  final HadithRepository _hadithRepository = HadithRepository();

  // State variables
  List<Surah> _surahs = [];
  List<HadithItem> _hadiths = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Surah> get surahs => _surahs;
  List<HadithItem> get hadiths => _hadiths;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize app data
  Future<void> initializeAppData() async {
    _setLoading(true);
    try {
      await Future.wait([
        _loadSurahs(),
        _loadHadiths(),
      ]);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadSurahs() async {
    try {
      _surahs = await _quranRepository.fetchAllSurahs();
    } catch (e) {
      _error = 'Failed to load Surahs';
    }
  }

  Future<void> _loadHadiths() async {
    try {
      _hadiths = await _hadithRepository.getAllHadiths();
    } catch (e) {
      _error = 'Failed to load Hadiths';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<QuranVerse?> getRandomQuranVerse() async {
    return await _quranRepository.getRandomAyah();
  }

  Future<HadithItem?> getRandomHadith() async {
    return await _hadithRepository.getRandomHadith();
  }
}
