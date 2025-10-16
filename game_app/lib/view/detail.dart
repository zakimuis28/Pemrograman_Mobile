import 'package:flutter/material.dart';
import 'package:game_app/viewmodel/fetchgame.dart';
import 'package:game_app/model/detailgame.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui';

class Detail extends StatelessWidget {
  final int gameTerpilih;
  const Detail({super.key, required this.gameTerpilih});

  Future<DetailGame> fetchData() async {
    final jsonData = await fetchDataFromAPI(gameTerpilih);
    return DetailGame.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.amberAccent.shade400,
      body: FutureBuilder<DetailGame>(
        future: fetchData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snap.error}'));
          } else if (!snap.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final game = snap.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 320,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'game_${game.id}',
                        child: Image.network(
                          game.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter, end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16, left: 16, right: 16,
                        child: Text(
                          game.title,
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D1FF), Color(0xFFFF7AD9)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.30),
                            border: Border.all(color: Colors.white.withOpacity(0.40)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              _MiniStat(icon: Icons.category, label: 'Genre', value: game.genre),
                              const SizedBox(width: 10),
                              _MiniStat(icon: Icons.devices_other, label: 'Platform', value: game.platform),
                              const SizedBox(width: 10),
                              _MiniStat(icon: Icons.calendar_today_rounded, label: 'Release', value: game.release_date),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            'Minimum System Requirements',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        _requirementRow('OS',        game.minimum_system_requirements.os),
                        _requirementRow('Processor', game.minimum_system_requirements.processor),
                        _requirementRow('Memory',    game.minimum_system_requirements.memory),
                        _requirementRow('Graphics',  game.minimum_system_requirements.graphics),
                        _requirementRow('Storage',   game.minimum_system_requirements.storage),
                      ],
                    ),
                  ),
                ),
              ),

              // screenshots
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _itemList(game.screenshots[0].image),
                      const SizedBox(width: 15),
                      _itemList(game.screenshots[1].image),
                      const SizedBox(width: 15),
                      _itemList(game.screenshots[2].image),
                    ],
                  ),
                ),
              ),

              // description
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0,6))],
                    ),
                    child: ReadMoreText(
                      game.description,
                      trimLines: 3,
                      colorClickableText: Colors.amberAccent.shade400,
                      trimMode: TrimMode.Line,
                      style: TextStyle(color: Colors.black87.withOpacity(0.8), height: 1.5),
                      trimCollapsedText: 'more',
                      trimExpandedText: 'less',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.65),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

// ==== helpers (seperti modul, tapi dibikin lebih rapi) ====

SizedBox _itemList(String url) {
  return SizedBox(
    width: 260,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      ),
    ),
  );
}

Row _requirementRow(String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 3, child: Text(title, style: TextStyle(color: Colors.black54.withOpacity(0.8)))),
      const SizedBox(width: 4),
      const Text(':'),
      const SizedBox(width: 6),
      Expanded(flex: 8, child: Text(value, style: TextStyle(color: Colors.black87.withOpacity(0.9)))),
    ],
  );
}

