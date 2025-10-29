import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  SettingsProvider(this.prefs) {
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    _fontScale = prefs.getDouble('fontScale') ?? 1.0;
    _translation = prefs.getString('translation') ?? 'id';
  }

  late ThemeMode _themeMode;
  double _fontScale = 1.0;
  String _translation = 'id';

  ThemeMode get themeMode => _themeMode;
  double get fontScale => _fontScale;
  String get translation => _translation;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  void setFontScale(double scale) {
    _fontScale = scale;
    prefs.setDouble('fontScale', scale);
    notifyListeners();
  }

  void setTranslation(String code) {
    _translation = code;
    prefs.setString('translation', code);
    notifyListeners();
  }
}
