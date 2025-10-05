import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo GridView.builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo GridView.builder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Data game dari API
  List<Map<String, dynamic>> _games = [];

  /// State UI
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final resp = await http.get(
        Uri.parse('https://www.freetogame.com/api/games'),
      );

      if (resp.statusCode != 200) {
        throw Exception('Gagal memuat data (status: ${resp.statusCode})');
      }

      final decoded = jsonDecode(resp.body);

      if (decoded is! List) {
        throw Exception('Format respons tidak sesuai (bukan List)');
      }

      // Ambil 20 data pertama, ketikkan menjadi Map<String, dynamic>
      final list = decoded
          .cast<Map<String, dynamic>>()
          .take(20)
          .toList(growable: false);

      if (!mounted) return;
      setState(() {
        _games = list;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Terjadi kesalahan: $e';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDetail(Map<String, dynamic> item) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final title = item['title']?.toString() ?? 'Tidak ada judul';
        final genre = item['genre']?.toString() ?? 'Tidak ada genre';
        final release = item['release_date']?.toString() ?? 'Tidak ada tanggal';
        final shortDesc =
            item['short_description']?.toString() ?? 'Tidak ada deskripsi';

        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Genre: $genre'),
              Text('Rilis: $release'),
              const SizedBox(height: 8),
              Text(shortDesc),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _cardItem(Map<String, dynamic> item) {
    final thumb = item['thumbnail']?.toString() ?? '';
    final title = item['title']?.toString() ?? 'Tidak ada judul';
    final genre = item['genre']?.toString() ?? 'Tidak ada genre';
    final release = item['release_date']?.toString() ?? 'Tidak ada tanggal';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDetail(item),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: thumb.isNotEmpty
                      ? Image.network(
                          thumb,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image, size: 36),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported, size: 36),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                genre,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                release,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: FilledButton(
                  onPressed: () => _showDetail(item),
                  child: const Text('Baca Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = () {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_error != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _ambilData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        );
      }
      if (_games.isEmpty) {
        return const Center(child: Text('Data kosong'));
      }

      // GridView.builder (2 kolom di ponsel kecil, 3 di layar lebar)
      return RefreshIndicator(
        onRefresh: _ambilData,
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // ubah sesuai kebutuhan
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: _games.length,
          itemBuilder: (context, index) => _cardItem(_games[index]),
        ),
      );
    }();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: _ambilData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: body,
    );
  }
}
