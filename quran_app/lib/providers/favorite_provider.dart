import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteProvider extends ChangeNotifier {
  final _box = Hive.box('favorites');

  List<Map> get favorites {
    return _box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList()
      ..sort((a,b) => (b['createdAt'] as int).compareTo(a['createdAt'] as int));
  }

  bool isFavorited(int surah, int ayah) {
    return _box.containsKey('$surah:$ayah');
  }

  void addFavorite({required int surah, required int ayah, required String arab, required String translation, String? note}) {
    _box.put('$surah:$ayah', {
      'surah': surah,
      'ayah': ayah,
      'arab': arab,
      'translation': translation,
      'note': note ?? '',
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    notifyListeners();
  }

  void updateNote(int surah, int ayah, String note) {
    final key = '$surah:$ayah';
    final data = Map<String, dynamic>.from(_box.get(key));
    data['note'] = note;
    _box.put(key, data);
    notifyListeners();
  }

  void removeFavorite(int surah, int ayah) {
    _box.delete('$surah:$ayah');
    notifyListeners();
  }
}

