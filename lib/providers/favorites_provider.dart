import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_quran_hadith/models/models.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];
  late SharedPreferences _prefs;

  List<Map<String, dynamic>> get favorites => _favorites;

  FavoritesProvider() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final List<String> saved = _prefs.getStringList('favorites') ?? [];
      _favorites = saved
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> addFavorite(Map<String, dynamic> item) async {
    _favorites.add(item);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(int index) async {
    _favorites.removeAt(index);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> item) {
    return _favorites.any((fav) =>
        fav['surah'] == item['surah'] || fav['title'] == item['title']);
  }

  Future<void> _saveFavorites() async {
    final List<String> saved =
        _favorites.map((item) => jsonEncode(item)).toList();
    await _prefs.setStringList('favorites', saved);
  }
}
