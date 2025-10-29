import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/surah_provider.dart';
import '../../widgets/surah_tile.dart';
import '../../widgets/hero_header.dart';
import '../../widgets/glass_card.dart';
import '../../core/app_theme.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SurahProvider>().loadSurahs());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<SurahProvider>();

    return Container(
      decoration: AppTheme.gradientBg(context),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                HeroHeader(
                  title: 'Al-Qur\'an Digital',
                  subtitle: 'Baca · Dengar · Simpan Favorit',
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/search'),
                      icon: const Icon(Icons.search),
                      tooltip: 'Cari Ayat',
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: prov.searchSurah,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari surat (nama/nomor)...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (prov.loadingList)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else
            SliverList.builder(
              itemCount: prov.filtered.length,
              itemBuilder: (context, i) {
                final s = prov.filtered[i];
                return GlassCard(
                  onTap: () => Navigator.pushNamed(context, '/surah-detail', arguments: {'number': s.number, 'name': s.nameLatin}),
                  child: SurahTile(
                    number: s.number,
                    name: s.name,
                    latin: s.nameLatin,
                    totalAyah: s.ayahs,
                  ),
                );
              },
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
    );
  }
}

