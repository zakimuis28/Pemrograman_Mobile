import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_theme.dart';
import 'core/app_router.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/surah_provider.dart';
import 'providers/favorite_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  final prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
      ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
      ChangeNotifierProvider(create: (_) => SurahProvider()),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ],
    child: const QuranApp(),
  ));
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Aplikasi Al-Qur\'an Digital',
      themeMode: settings.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
    );
  }
}