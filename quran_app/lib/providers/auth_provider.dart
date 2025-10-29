import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  AuthProvider(this.prefs) {
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _name = prefs.getString('user_name');
    _email = prefs.getString('user_email');
    _photo = prefs.getString('user_photo');
  }

  bool _isLoggedIn = false;
  String? _name;
  String? _email;
  String? _photo;

  bool get isLoggedIn => _isLoggedIn;
  String? get name => _name;
  String? get email => _email;
  String? get photo => _photo;

  Future<void> login(String email, String password) async {
    // Mock: selalu sukses
    _isLoggedIn = true;
    _email = email;
    _name = email.split('@').first;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('user_email', _email!);
    await prefs.setString('user_name', _name!);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    // Mock register
    _isLoggedIn = true;
    _name = name;
    _email = email;
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('user_email', _email!);
    await prefs.setString('user_name', _name!);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? photo}) async {
    if (name != null) {
      _name = name;
      await prefs.setString('user_name', name);
    }
    if (photo != null) {
      _photo = photo;
      await prefs.setString('user_photo', photo);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}
