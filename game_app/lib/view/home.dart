import 'package:flutter/material.dart';
import 'package:game_app/model/game.dart';
import 'package:game_app/viewmodel/fetchgame.dart';
import 'dart:ui';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _query = '';
  String? _platformFilter; // e.g. 'PC (Windows)' / 'Web Browser'

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ====== SliverAppBar neon gradient ======
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF00D1FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      left: -30,
                      child: _Blob(color: Colors.white.withOpacity(0.18), size: 180),
                    ),
                    Positioned(
                      bottom: -60,
                      right: -40,
                      child: _Blob(color: Colors.black.withOpacity(0.10), size: 160),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Game Store',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                )),
                            SizedBox(height: 6),
                            Text(
                              'Discover & play — curated for you',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: cs.primary,
          ),

          // ====== Search + filter chips (glass) ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.45), width: 1),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: Column(
                      children: [
                        TextField(
                          cursorColor: cs.primary,
                          onChanged: (v) => setState(() => _query = v.trim()),
                          decoration: InputDecoration(
                            hintText: 'Cari game...',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                            prefixIcon: Icon(Icons.search_rounded, color: cs.primary),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.6),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder<List<Game>>(
                          future: fetchGames(),
                          builder: (context, snap) {
                            if (!snap.hasData) return const SizedBox.shrink();
                            final platforms = snap.data!
                                .map((g) => g.platform)
                                .toSet()
                                .toList()
                              ..sort();
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _FilterChip(
                                    label: 'All',
                                    selected: _platformFilter == null,
                                    onTap: () => setState(() => _platformFilter = null),
                                  ),
                                  const SizedBox(width: 8),
                                  for (final p in platforms) ...[
                                    _FilterChip(
                                      label: p,
                                      selected: _platformFilter == p,
                                      onTap: () => setState(() => _platformFilter = p),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ====== List games ======
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
            sliver: FutureBuilder<List<Game>>(
              future: fetchGames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Tidak ada data game.'),
                    )),
                  );
                }

                // filter
                var games = snapshot.data!;
                if (_query.isNotEmpty) {
                  final q = _query.toLowerCase();
                  games = games.where((g) =>
                    g.title.toLowerCase().contains(q) ||
                    g.genre.toLowerCase().contains(q) ||
                    g.publisher.toLowerCase().contains(q) ||
                    g.platform.toLowerCase().contains(q)
                  ).toList();
                }
                if (_platformFilter != null) {
                  games = games.where((g) => g.platform == _platformFilter).toList();
                }

                // batasi 50 item untuk performa
                games = games.take(50).toList();

                return SliverList.separated(
                  itemBuilder: (_, i) {
                    final game = games[i];
                    return InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: game.id,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: _GameCard(game: game),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: games.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ======= Widgets & helpers =======

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A00), Color(0xFFFF3D81)],
          begin: Alignment.centerLeft, end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // thumbnail + Hero
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              child: Hero(
                tag: 'game_${game.id}',
                child: Image.network(
                  game.thumbnail,
                  width: 120, height: 110, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120, height: 110, color: Colors.grey[300],
                    alignment: Alignment.center, child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // texts
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(game.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6, runSpacing: 6,
                      children: [
                        _Pill(text: game.genre, icon: Icons.sports_esports),
                        _Pill(text: game.platform, icon: Icons.devices_other),
                        _Pill(text: 'Release: ${game.releaseDate}', icon: Icons.event),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('FREE', style: TextStyle(
                            color: cs.primary, fontWeight: FontWeight.w800, letterSpacing: 0.6,
                          )),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_rounded, color: cs.primary),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ]),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? cs.primary : Colors.white.withOpacity(0.7)),
          boxShadow: selected ? [BoxShadow(color: cs.primary.withOpacity(0.3), blurRadius: 14, offset: const Offset(0,6))] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
