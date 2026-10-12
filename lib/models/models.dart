class QuranVerse {
  final String surah;
  final String ayah;
  final String arabic;
  final String translation;
  final String note;
  bool isSaved;

  QuranVerse({
    required this.surah,
    required this.ayah,
    required this.arabic,
    required this.translation,
    required this.note,
    this.isSaved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'surah': surah,
      'ayah': ayah,
      'arabic': arabic,
      'translation': translation,
      'note': note,
      'type': 'quran',
    };
  }

  factory QuranVerse.fromMap(Map<String, dynamic> map) {
    return QuranVerse(
      surah: map['surah'] ?? '',
      ayah: map['ayah'] ?? '',
      arabic: map['arabic'] ?? '',
      translation: map['translation'] ?? '',
      note: map['note'] ?? '',
    );
  }
}

class HadithItem {
  final String title;
  final String arabic;
  final String english;
  final String source;
  bool isSaved;

  HadithItem({
    required this.title,
    required this.arabic,
    required this.english,
    required this.source,
    this.isSaved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'arabic': arabic,
      'english': english,
      'source': source,
      'type': 'hadith',
    };
  }

  factory HadithItem.fromMap(Map<String, dynamic> map) {
    return HadithItem(
      title: map['title'] ?? '',
      arabic: map['arabic'] ?? '',
      english: map['english'] ?? '',
      source: map['source'] ?? '',
    );
  }
}

class QuranApiResponse {
  final List<Surah> surahs;

  QuranApiResponse({required this.surahs});

  factory QuranApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['surahs'] as List;
    List<Surah> surahs = list.map((i) => Surah.fromJson(i)).toList();
    return QuranApiResponse(surahs: surahs);
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final int numberOfAyahs;
  final String revelationType;
  final List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var ayahsList = (json['ayahs'] as List? ?? [])
        .map((i) => Ayah.fromJson(i))
        .toList();
    return Surah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
      ayahs: ayahsList,
    );
  }
}

class Ayah {
  final int number;
  final String text;
  final String numberInSurah;
  final String juz;
  final String manzil;
  final String page;
  final String ruku;
  final String hizbQuarter;
  final bool sajdah;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajdah,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      numberInSurah: json['numberInSurah']?.toString() ?? '',
      juz: json['juz']?.toString() ?? '',
      manzil: json['manzil']?.toString() ?? '',
      page: json['page']?.toString() ?? '',
      ruku: json['ruku']?.toString() ?? '',
      hizbQuarter: json['hizbQuarter']?.toString() ?? '',
      sajdah: json['sajdah'] ?? false,
    );
  }
}
