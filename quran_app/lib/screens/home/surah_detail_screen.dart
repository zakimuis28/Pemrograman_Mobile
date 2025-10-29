import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/surah_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../core/app_theme.dart';
import '../../providers/settings_provider.dart';


class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  const SurahDetailScreen({super.key, required this.surahNumber, required this.surahName});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final player = AudioPlayer();
  int? lastAyah;

  @override
  void initState() {
    super.initState();
    _loadLastPosition();
  }

  Future<void> _loadLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastAyah = prefs.getInt('last_read_${widget.surahNumber}');
    });
  }

  Future<void> _saveLastPosition(int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_${widget.surahNumber}', ayah);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahProv = context.watch<SurahProvider>();
    final favProv = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('${widget.surahName} (${widget.surahNumber})')),
      body: FutureBuilder(
        future: surahProv.loadAyahs(widget.surahNumber),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final ayahs = snap.data!;
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: ayahs.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, i) {
              final a = ayahs[i];
              final isFav = favProv.isFavorited(widget.surahNumber, a.numberInSurah);
              final isLast = (lastAyah != null && lastAyah == a.numberInSurah);
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(alignment: Alignment.centerRight, child: Text(a.arab, textAlign: TextAlign.right, style: const TextStyle(fontSize: 22))),
                    const SizedBox(height: 6),
                    Text(a.translationId),
                    if (isLast) Padding(padding: const EdgeInsets.only(top: 4), child: Text('· Terakhir dibaca', style: TextStyle(color: Theme.of(context).colorScheme.primary)))
                  ],
                ),
                leading: CircleAvatar(child: Text('${a.numberInSurah}')),
                trailing: Wrap(spacing: 8, children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: a.audioUrl == null ? null : () async {
                      try {
                        await player.setUrl(a.audioUrl!);
                        player.play();
                      } catch (_) {}
                    },
                  ),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    onPressed: () async {
                      if (isFav) {
                        favProv.removeFavorite(widget.surahNumber, a.numberInSurah);
                      } else {
                        favProv.addFavorite(
                          surah: widget.surahNumber,
                          ayah: a.numberInSurah,
                          arab: a.arab,
                          translation: a.translationId,
                        );
                      }
                    },
                  ),
                ]),
                onTap: () => _saveLastPosition(a.numberInSurah),
              );
            },
          );
        },
      ),
    );
  }
}
