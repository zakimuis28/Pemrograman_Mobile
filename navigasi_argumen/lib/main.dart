// lib/main.dart
import 'home.dart';
import 'tujuan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat status bar transparan (atas layar)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0081c9),
        ),
        useMaterial3: true,
      ),

      // rute awal aplikasi
      initialRoute: '/',

      // daftar named routes
      routes: {
        Tujuan.routeName: (context) => const Tujuan(),
        '/': (context) => const Home(),
      },
    );
  }
}
