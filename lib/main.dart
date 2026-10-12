import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DailyQuranHadithApp());
}

class DailyQuranHadithApp extends StatelessWidget {
  const DailyQuranHadithApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Quran & Hadith',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F1E8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF173B2A),
          secondary: Color(0xFFB98A3A),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.loraTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    QuranPage(),
    HadithPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B2A),
        foregroundColor: Colors.white,
        title: const Text('Daily Quran & Hadith'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Quran'),
          NavigationDestination(icon: Icon(Icons.auto_stories), label: 'Hadith'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Favorites'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuranVerse todayVerse = QuranVerse(
    surah: 'Al-Mulk',
    ayah: '67:2',
    arabic: 'ٱللّٰهِ ۚ',
    translation: 'Allah is the Creator of all things.',
    note: 'This reminds us to reflect on Allah’s wisdom and the greatness of His creation.',
  );

  final HadithItem todayHadith = HadithItem(
    title: 'Seeking knowledge',
    arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا',
    english:
        'Whoever travels a path in search of knowledge, Allah will make the path to Paradise easy for him.',
    source: 'Sahih Muslim',
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today’s guidance',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B2A),
            ),
          ),
          const SizedBox(height: 16),
          _buildVerseCard(todayVerse),
          const SizedBox(height: 20),
          _buildHadithCard(todayHadith),
          const SizedBox(height: 20),
          const Text(
            'Reflection topics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B2A),
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              TopicChip(title: 'Taqwa'),
              TopicChip(title: 'Knowledge'),
              TopicChip(title: 'Gratitude'),
              TopicChip(title: 'Patience'),
              TopicChip(title: 'Dua'),
              TopicChip(title: 'Mercy'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerseCard(QuranVerse verse) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quran of the day',
            style: TextStyle(
              color: Color(0xFFB98A3A),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${verse.surah} ${verse.ayah}',
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF173B2A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            verse.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 32,
              height: 1.8,
              color: Color(0xFF173B2A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '“${verse.translation}”',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            verse.note,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithCard(HadithItem hadith) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDE0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hadith of the day',
            style: TextStyle(
              color: Color(0xFFB98A3A),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hadith.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B2A),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hadith.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 26,
              height: 1.8,
              color: Color(0xFF173B2A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '“${hadith.english}”',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hadith.source,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B2A),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicChip extends StatelessWidget {
  final String title;

  const TopicChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE1E9E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF173B2A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final List<QuranVerse> verses = [
    QuranVerse(
      surah: 'Al-Fatihah',
      ayah: '1:1',
      arabic: 'الْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِينَ',
      translation: 'All praise is due to Allah, Lord of the worlds.',
      note: 'A perfect start to the day with gratitude.',
    ),
    QuranVerse(
      surah: 'Al-Mulk',
      ayah: '67:1',
      arabic: 'تَبٰرَكَ ٱلَّذِي بِيَدِهِ ٱلْمُلْكُ',
      translation: 'Blessed is He in whose hand is dominion.',
      note: 'A reminder that Allah is the ultimate Owner.',
    ),
    QuranVerse(
      surah: 'An-Nas',
      ayah: '114:1',
      arabic: 'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
      translation: 'Say: I seek refuge in the Lord of mankind.',
      note: 'A dua for protection and peace.',
    ),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = verses
        .where((item) =>
            item.surah.toLowerCase().contains(query.toLowerCase()) ||
            item.translation.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Quran verses',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final verse = filtered[index];
                return _VerseCard(verse: verse);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatefulWidget {
  final QuranVerse verse;

  const _VerseCard({required this.verse, super.key});

  @override
  State<_VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<_VerseCard> {
  bool isSaved = false;

  Future<void> _toggleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'fav_quran_${widget.verse.surah}_${widget.verse.ayah}';
    final saved = prefs.getStringList('favorites') ?? [];

    if (isSaved) {
      saved.removeWhere((item) => item == jsonEncode(widget.verse.toMap()));
      prefs.setStringList('favorites', saved);
    } else {
      saved.add(jsonEncode(widget.verse.toMap()));
      prefs.setStringList('favorites', saved);
    }

    setState(() {
      isSaved = !isSaved;
    });

    debugPrint('Saved favorite: $key');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.verse.surah} ${widget.verse.ayah}',
                style: const TextStyle(
                  color: Color(0xFF173B2A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _toggleSave,
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xFFB98A3A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.verse.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 28,
              height: 1.8,
              color: Color(0xFF173B2A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.verse.translation,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  final List<HadithItem> hadiths = [
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
      arabic: 'إِنَّمَا بُعِثْتُ لأُتَمِّمَ مَكارِمَ الأَخْلاقِ',
      english: 'I was sent to perfect noble character.',
      source: 'Muwatta Malik',
    ),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = hadiths
        .where((item) =>
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.english.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search hadith',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173B2A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.arabic,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.8,
                          color: Color(0xFF173B2A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '“${item.english}”',
                        style: const TextStyle(
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.source,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB98A3A),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: favorites.isEmpty
          ? const Center(
              child: Text(
                'No saved favorites yet.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                final decoded = jsonDecode(item);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        decoded['surah'] ?? decoded['title'] ?? 'Saved item',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173B2A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        decoded['arabic'] ?? decoded['english'] ?? '',
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xFF173B2A),
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class QuranVerse {
  final String surah;
  final String ayah;
  final String arabic;
  final String translation;
  final String note;

  QuranVerse({
    required this.surah,
    required this.ayah,
    required this.arabic,
    required this.translation,
    required this.note,
  });

  Map<String, String> toMap() {
    return {
      'surah': surah,
      'ayah': ayah,
      'arabic': arabic,
      'translation': translation,
      'note': note,
    };
  }
}

class HadithItem {
  final String title;
  final String arabic;
  final String english;
  final String source;

  HadithItem({
    required this.title,
    required this.arabic,
    required this.english,
    required this.source,
  });
}
