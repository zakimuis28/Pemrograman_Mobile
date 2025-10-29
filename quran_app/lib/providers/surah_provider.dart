import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../services/quran_api_service.dart';

class AyahHit {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String arab;
  final String translation;
  AyahHit({required this.surahNumber, required this.surahName, required this.ayahNumber, required this.arab, required this.translation});
}

class SurahProvider extends ChangeNotifier {
  final _api = QuranApiService();
  List<Surah> all = [];
  List<Surah> filtered = [];
  Map<int, List<Ayah>> cache = {};
  bool loadingList = false;
  bool loadingDetail = false;
  String? error;

  // --- Indexer ayat lintas surat ---
  bool indexing = false;
  int indexedSurahCount = 0; // jumlah surat yang sudah di-index

  Future<void> loadSurahs() async {
    loadingList = true; error = null; notifyListeners();
    try {
      all = await _api.fetchSurahs();
      filtered = all;
    } catch (e) {
      error = e.toString();
    } finally {
      loadingList = false; notifyListeners();
    }
  }

  void searchSurah(String q) {
    q = q.trim().toLowerCase();
    if (q.isEmpty) { filtered = all; } else {
      filtered = all.where((s) => s.nameLatin.toLowerCase().contains(q) || s.number.toString() == q).toList();
    }
    notifyListeners();
  }

  Future<List<Ayah>> loadAyahs(int number) async {
    if (cache[number] != null) return cache[number]!;
    loadingDetail = true; error = null; notifyListeners();
    try {
      final list = await _api.fetchAyahs(number);
      cache[number] = list;
      return list;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loadingDetail = false; notifyListeners();
    }
  }

  // Membangun index ayat secara bertahap (on-demand). Panggil sekali (mis. saat buka layar search).
  Future<void> buildIndex({int? limit}) async {
    if (indexing) return;
    indexing = true; indexedSurahCount = 0; notifyListeners();
    try {
      for (final s in all) {
        if (limit != null && indexedSurahCount >= limit) break;
        if (!cache.containsKey(s.number)) {
          try { await loadAyahs(s.number); } catch (_) {}
        }
        indexedSurahCount++;
        notifyListeners();
      }
    } finally {
      indexing = false; notifyListeners();
    }
  }

  // Pencarian lintas ayat di surat yang sudah tervalidasi di cache.
  List<AyahHit> searchAyat(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final List<AyahHit> hits = [];
    for (final entry in cache.entries) {
      final surahNo = entry.key;
      final ayahs = entry.value;
      final surahName = all.firstWhere((s) => s.number == surahNo, orElse: ()=> Surah(number: surahNo, name: '-', nameLatin: '-', ayahs: ayahs.length)).nameLatin;
      for (final a in ayahs) {
        if (a.translationId.toLowerCase().contains(q) || a.arab.contains(query)) {
          hits.add(AyahHit(
            surahNumber: surahNo,
            surahName: surahName,
            ayahNumber: a.numberInSurah,
            arab: a.arab,
            translation: a.translationId,
          ));
        }
      }
    }
    return hits;
  }
}
