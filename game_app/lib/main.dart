import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_app/view/home.dart';
import 'package:game_app/view/detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  PageRoute _detailRoute(RouteSettings settings) {
    final gameId = settings.arguments as int;
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, a1, a2) => Detail(gameTerpilih: gameId),
      transitionsBuilder: (_, anim, __, child) {
        final slide = Tween(begin: const Offset(0.05, 0.08), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic))
            .animate(anim);
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(position: slide, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 420),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final seed = const Color(0xFF7C4DFF); // purple-cyan vibes
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Game Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') return _detailRoute(settings);
        if (settings.name == '/' || settings.name == null) {
          return MaterialPageRoute(builder: (_) => const Home());
        }
        return null;
      },
      initialRoute: '/',
    );
  }
}
