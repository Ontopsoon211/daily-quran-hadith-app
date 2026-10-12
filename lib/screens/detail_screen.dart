import 'package:flutter/material.dart';
import 'package:daily_quran_hadith/models/models.dart';

class DetailScreen extends StatelessWidget {
  final dynamic item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isQuran = item is QuranVerse;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B2A),
        foregroundColor: Colors.white,
        title: Text(isQuran ? item.surah : item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isQuran)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.surah,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ayah ${item.ayah}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB98A3A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EDE0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.arabic,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 28,
                        height: 2,
                        color: Color(0xFF173B2A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Translation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\"${item.translation}\"',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Reflection',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.note,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B2A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Source: ${item.source}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB98A3A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EDE0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.arabic,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 26,
                        height: 2,
                        color: Color(0xFF173B2A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'English Translation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\"${item.english}\"',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
