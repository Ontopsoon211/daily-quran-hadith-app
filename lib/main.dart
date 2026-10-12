import 'dart:convert';

import 'package:daily_quran_hadith/models/models.dart';
import 'package:daily_quran_hadith/providers/favorites_provider.dart';
import 'package:daily_quran_hadith/providers/theme_provider.dart';
import 'package:daily_quran_hadith/screens/detail_screen.dart';
import 'package:daily_quran_hadith/services/notification_service.dart';
import 'package:daily_quran_hadith/services/quran_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {\n  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const DailyQuranHadithApp(),
    ),
  );
}

class DailyQuranHadithApp extends StatelessWidget {
  const DailyQuranHadithApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Daily Quran & Hadith',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode
          ? themeProvider.getDarkTheme()
          : themeProvider.getLightTheme(),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    QuranScreen(),
    HadithScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_rounded), label: 'Quran'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_rounded), label: 'Hadith'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_rounded), label: 'Favorites'),
          NavigationDestination(
              icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  QuranVerse? _todayVerse;
  HadithItem? _todayHadith;

  @override
  void initState() {
    super.initState();
    _loadDailyContent();
  }

  Future<void> _loadDailyContent() async {
    setState(() => _isLoading = true);

    final verse = await QuranService.getRandomAyah();
    final hadith = const HadithItem(
      title: 'Seeking knowledge',
      arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا',
      english:
          'Whoever travels a path in search of knowledge, Allah will make the path to Paradise easy for him.',
      source: 'Sahih Muslim',
    );

    setState(() {
      _todayVerse = verse ??
          QuranVerse(
            surah: 'Al-Mulk',
            ayah: '67:2',
            arabic: 'ٱللّٰهِ ۚ',
            translation: 'Allah is the Creator of all things.',
            note:
                'This reminds us to reflect on Allah's wisdom and the greatness of His creation.',
          );
      _todayHadith = hadith;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDailyContent,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily guidance',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB98A3A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Today's reflection',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _loadDailyContent,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              _contentCard(
                title: 'Quran of the day',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF173B2A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_todayVerse?.surah} ${_todayVerse?.ayah}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB98A3A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _todayVerse?.arabic ?? '',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.8,
                        color: isDark ? Colors.white : const Color(0xFF173B2A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"${_todayVerse?.translation ?? ''}"',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _todayVerse?.note ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _contentCard(
                title: 'Hadith of the day',
                icon: Icons.auto_stories_rounded,
                color: const Color(0xFFB98A3A),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todayHadith?.title ?? 'Hadith',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB98A3A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _todayHadith?.arabic ?? '',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 26,
                        height: 1.8,
                        color: isDark ? Colors.white : const Color(0xFF173B2A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"${_todayHadith?.english ?? ''}"',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _todayHadith?.source ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Reflection topics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
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
                  TopicChip(title: 'Sabr'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _contentCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B262B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3D40) : const Color(0xFFE7EFEA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF173B2A),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final List<QuranVerse> _verses = [
    QuranVerse(
      surah: 'Al-Fatihah',
      ayah: '1:1',
      arabic: 'الْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِينَ',
      translation: 'All praise is due to Allah, Lord of the worlds.',
      note: 'A perfect start to the day with gratitude.',
    ),
    QuranVerse(
      surah: 'Al-Mulk',
      ayah: '67:1',
      arabic: 'تَبٰرَكَ ٱلَّذِي بِيَدِهِ ٱلْمُلْكُ',
      translation: 'Blessed is He in whose hand is dominion.',
      note: 'A reminder of Allah's sovereign power.',
    ),
    QuranVerse(
      surah: 'Al-Ikhlas',
      ayah: '112:1',
      arabic: 'قُلْ هُوَ ٱللّٰهُ أَحَدٌ',
      translation: 'Say: He is Allah, the One.',
      note: 'An affirmation of monotheism and devotion.',
    ),
    QuranVerse(
      surah: 'An-Nas',
      ayah: '114:1',
      arabic: 'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
      translation: 'Say: I seek refuge in the Lord of mankind.',
      note: 'A dua for protection and peace.',
    ),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);
    final filtered = _verses.where((verse) {
      final query = _query.toLowerCase();
      return verse.surah.toLowerCase().contains(query) ||
          verse.translation.toLowerCase().contains(query) ||
          verse.note.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                hintText: 'Search Quran verses',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final verse = filtered[index];
                  final isSaved = favorites.favorites.any((item) =>
                      item['surah'] == verse.surah && item['ayah'] == verse.ayah);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      title: Text(
                        '${verse.surah} ${verse.ayah}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(verse.translation),
                      trailing: IconButton(
                        onPressed: () async {
                          final entry = verse.toMap();
                          if (isSaved) {
                            final list = favorites.favorites;
                            final idx = list.indexWhere((item) =>
                                item['surah'] == verse.surah &&
                                item['ayah'] == verse.ayah);
                            if (idx >= 0) {
                              await favorites.removeFavorite(idx);
                            }
                          } else {
                            await favorites.addFavorite(entry);
                          }
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: const Color(0xFFB98A3A),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(item: verse),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
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
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);
    final filtered = _hadiths.where((item) {
      final query = _query.toLowerCase();
      return item.title.toLowerCase().contains(query) ||
          item.english.toLowerCase().contains(query) ||
          item.source.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                hintText: 'Search hadith',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final hadith = filtered[index];
                  final isSaved = favorites.favorites.any((item) =>
                      item['title'] == hadith.title && item['source'] == hadith.source);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      title: Text(
                        hadith.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        hadith.english,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          final entry = hadith.toMap();
                          if (isSaved) {
                            final list = favorites.favorites;
                            final idx = list.indexWhere((item) =>
                                item['title'] == hadith.title &&
                                item['source'] == hadith.source);
                            if (idx >= 0) {
                              await favorites.removeFavorite(idx);
                            }
                          } else {
                            await favorites.addFavorite(entry);
                          }
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: const Color(0xFFB98A3A),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(item: hadith),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context).favorites;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Saved favorites',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: favorites.isEmpty
                  ? const Center(
                      child: Text('No favorites saved yet.'),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final item = favorites[index];
                        final title = item['surah'] ?? item['title'] ?? 'Saved item';
                        final text = item['arabic'] ?? item['english'] ?? '';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(
                              text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 22),
          SwitchListTile.adaptive(
            title: const Text('Dark mode'),
            subtitle: const Text('Use a dark theme for reading at night.'),
            value: themeProvider.isDarkMode,
            onChanged: (_) async {
              await themeProvider.toggleTheme();
              setState(() {});
            },
          ),
          const Divider(),
          SwitchListTile.adaptive(
            title: const Text('Daily reminder'),
            subtitle: const Text('Get a notification each morning.'),
            value: _reminderEnabled,
            onChanged: (value) async {
              setState(() => _reminderEnabled = value);
              if (value) {
                await NotificationService().scheduleDailyNotification(
                  hour: 8,
                  minute: 0,
                  title: 'Daily Quran & Hadith',
                  body: 'Your daily reflection is ready.',
                );
              } else {
                await NotificationService().cancelAllNotifications();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Send test notification'),
            onTap: () async {
              await NotificationService().showNotification(
                title: 'Daily Quran & Hadith',
                body: 'This is a test notification for your daily reminder.',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('App version'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
