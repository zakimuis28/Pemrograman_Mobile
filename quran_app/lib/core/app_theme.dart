import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _seed = Colors.green;

  static TextStyle get arabic => GoogleFonts.amiri(
    fontSize: 24,
    height: 1.6,
  );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
        useMaterial3: true,
      );

  // Dekorasi gradient lembut untuk latar belakang
  static BoxDecoration gradientBg(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          cs.primary.withOpacity(0.08),
          cs.secondary.withOpacity(0.06),
          cs.surface.withOpacity(0.0),
        ],
      ),
    );
  }
}
