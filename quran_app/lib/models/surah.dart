class Surah {
  final int number;
  final String name;
  final String nameLatin;
  final int ayahs;

  Surah(
      {required this.number,
      required this.name,
      required this.nameLatin,
      required this.ayahs});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      name: json['name']?['short'] ?? json['name'] as String? ?? '-',
      nameLatin:
          json['name']?['transliteration']?['id'] ?? json['englishName'] ?? '-',
      ayahs: json['numberOfVerses'] ?? json['ayahs']?.length ?? 0,
    );
  }
}
