import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import "package:google_fonts/google_fonts.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // gunakan Poppins
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Weather App',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 225, 224, 224),
        ),
        body: const WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF232526), // abu gelap
            Color(0xFF414345), // hitam ke abu
            Color(0xFF283E51), // biru gelap
            Color(0xFF485563), // biru maskulin
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'Malang',
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _scaleAnim,
              child: Text(
                '25°',
                style: GoogleFonts.poppins(
                  fontSize: 110,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255), 
                  shadows: [
                    Shadow(
                      color: const Color.fromARGB(255, 145, 158, 171).withOpacity(0.7), 
                      blurRadius: 18,
                      offset: Offset(2, 6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: WeatherItem(
                    day: 'Minggu',
                    icon: Icons.wb_sunny,
                    temp: '20°C',
                    color: Colors.amber[700]!,
                    bgColor: Colors.grey[900]!,
                  ),
                ),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: WeatherItem(
                    day: 'Senin',
                    icon: Icons.cloudy_snowing,
                    temp: '23°C',
                    color: Colors.lightBlueAccent,
                    bgColor: Colors.grey[900]!,
                  ),
                ),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: WeatherItem(
                    day: 'Selasa',
                    icon: Icons.cloud,
                    temp: '22°C',
                    color: Colors.white70,
                    bgColor: Colors.grey[900]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherItem extends StatelessWidget {
  final String day;
  final IconData icon;
  final String temp;
  final Color color;
  final Color bgColor;

  const WeatherItem({
    super.key,
    required this.day,
    required this.icon,
    required this.temp,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 7,
      shadowColor: color.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 38,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              temp,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
