import 'package:flutter/material.dart';
import 'home.dart';
import 'tujuan.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF7C4DFF);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gen Z Navigation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/tujuan': (context) => const TujuanPage(),
      },
      onGenerateRoute: (settings) {
        final routes = {
          '/': (context) => const HomePage(),
          '/tujuan': (context) => const TujuanPage(),
        };
        final builder = routes[settings.name];
        if (builder == null) return null;

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(opacity: animation, child: builder(context)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offset = Tween(begin: const Offset(0.06, 0.08), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
            return SlideTransition(position: offset, child: child);
          },
          transitionDuration: const Duration(milliseconds: 420),
        );
      },
    );
  }
}
