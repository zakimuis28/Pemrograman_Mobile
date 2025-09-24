import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Latar belakang gelap
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Pemutar Musik"),
        ),
        body: const Center(
          child: Text(
            "Pemutar Musik",
            style: TextStyle(fontSize: 20),
          ),
        ),
        // Control Bar ditempatkan di bawah layar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          color: Colors.black54, // Latar control bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Shuffle
              const Expanded(
                child: Icon(Icons.shuffle, color: Colors.white, size: 28),
              ),

              // Tombol Previous
              const Expanded(
                child: Icon(Icons.skip_previous, color: Colors.white, size: 28),
              ),

              // Tombol Play (lebih besar dengan Flexible flex:2)
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 45),
              ),

              // Tombol Next
              const Expanded(
                child: Icon(Icons.skip_next, color: Colors.white, size: 28),
              ),

              // Tombol Repeat
              const Expanded(
                child: Icon(Icons.repeat, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
