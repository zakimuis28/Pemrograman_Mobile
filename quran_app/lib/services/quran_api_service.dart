import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/ayah.dart';

class QuranApiService {
// Default ke Sutanlab API
  static const String baseUrl = 'https://api.quran.sutanlab.id';

  Future<List<Surah>> fetchSurahs() async {
    final res = await http.get(Uri.parse('$baseUrl/surah'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = data['data'] as List;
      return list
          .map((e) => Surah.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal memuat daftar surat');
  }

  Future<List<Ayah>> fetchAyahs(int surahNumber,
      {String translation = 'id'}) async {
    final res = await http.get(Uri.parse('$baseUrl/surah/$surahNumber'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final verses = data['data']['verses'] as List;
      return verses
          .map((e) => Ayah.fromSutanlab(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal memuat ayat');
  }
}
