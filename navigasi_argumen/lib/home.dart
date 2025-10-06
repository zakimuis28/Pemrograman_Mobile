// lib/home.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'screen_arguments.dart';
import 'tujuan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Variabel penampung data game
  String? title, thumbnail, short_description, description;
  String? genre, platform, release, cover, gameid, publisher;

  // Ambil satu game berdasarkan id
  Future<void> getGame(String gameid) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/game?id=$gameid'),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data (status: ${response.statusCode})');
      }

      final results = jsonDecode(response.body) as Map<String, dynamic>;

      setState(() {
        this.gameid = gameid;
        title = results['title']?.toString();
        thumbnail = results['thumbnail']?.toString();
        short_description = results['short_description']?.toString();
        description = results['description']?.toString();
        genre = results['genre']?.toString();
        platform = results['platform']?.toString();
        publisher = results['publisher']?.toString();
        release = results['release_date']?.toString();

        // ambil cover dari screenshots index 0 bila ada
        final shots = results['screenshots'];
        if (shots is List && shots.isNotEmpty) {
          cover = (shots.first as Map<String, dynamic>)['image']?.toString();
        } else {
          cover = thumbnail; // fallback
        }
      });
    } catch (e) {
      // Tampilkan error sederhana di UI
      if (!mounted) return;
      setState(() {
        this.gameid = null;
        title = 'Gagal memuat data';
        short_description = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // ambil 1 game default
    getGame('475');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0081c9),
      body: SafeArea(
        child: Center(
          child: gameid == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Kirim data ke halaman detail (Tujuan)
                        Navigator.pushNamed(
                          context,
                          Tujuan.routeName,
                          arguments: ScreenArguments(
                            cover ?? thumbnail ?? '',
                            title ?? '-',
                            description ?? '-',
                            short_description ?? '-',
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            // Gambar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                thumbnail ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 160,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image, size: 42),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Judul
                            Text(
                              title ?? '-',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            // Meta info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Genre: ${genre ?? '-'}"),
                                    Text("Platform: ${platform ?? '-'}"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Publisher: ${publisher ?? '-'}"),
                                    Text("Release: ${release ?? '-'}"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
