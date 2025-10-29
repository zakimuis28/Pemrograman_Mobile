import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/surah_provider.dart';
import '../../widgets/glass_card.dart';
import '../../core/app_theme.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final ctrl = TextEditingController();
  String q = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final p = context.read<SurahProvider>();
      if (p.all.isEmpty) await p.loadSurahs();
      // Bangun index bertahap; hilangkan limit bila ingin full. Bisa juga limit=20 untuk cepat.
      // ignore: unawaited_futures
      p.buildIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SurahProvider>();
    final hits = p.searchAyat(q);

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Ayat')),
      body: Container(
        decoration: AppTheme.gradientBg(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: ctrl,
                autofocus: true,
                onChanged: (v) => setState(() => q = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Ketik kata kunci (Arab atau terjemahan)...',
                  suffixIcon: p.indexing
                      ? Padding(padding: const EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
                      : (p.indexedSurahCount > 0 ? Padding(padding: const EdgeInsets.only(right: 12), child: Text('${p.indexedSurahCount}/${p.all.length} surat')) : null),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: hits.isEmpty && q.isEmpty
                  ? const Center(child: Text('Mulai mengetik untuk mencari ayat...'))
                  : ListView.builder(
                      itemCount: hits.length,
                      itemBuilder: (context, i) {
                        final h = hits[i];
                        return GlassCard(
                          onTap: () => Navigator.pushNamed(context, '/surah-detail', arguments: {'number': h.surahNumber, 'name': h.surahName}),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${h.surahName} • ${h.surahNumber}:${h.ayahNumber}', style: Theme.of(context).textTheme.labelMedium),
                              const SizedBox(height: 8),
                              Align(alignment: Alignment.centerRight, child: Text(h.arab, textAlign: TextAlign.right, style: AppTheme.arabic)),
                              const SizedBox(height: 8),
                              Text(h.translation),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

