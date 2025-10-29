import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoriteProvider>();
    final items = fav.favorites;

    if (items.isEmpty) {
      return const Center(child: Text('Belum ada favorit'));
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, i) {
        final m = items[i];
        return ListTile(
          leading: CircleAvatar(child: Text('${m['ayah']}')),
          title: Text(m['arab'], textAlign: TextAlign.right),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m['translation']),
            const SizedBox(height: 6),
            Text(m['note'].toString().isEmpty ? 'Catatan: (kosong)' : 'Catatan: ${m['note']}')
          ]),
          trailing: PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'edit') {
                final noteCtrl = TextEditingController(text: m['note']);
                final newNote = await showDialog<String>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Edit Catatan'),
                    content: TextField(controller: noteCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Tulis catatan...')),
                    actions: [
                      TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Batal')),
                      ElevatedButton(onPressed: ()=> Navigator.pop(context, noteCtrl.text), child: const Text('Simpan')),
                    ],
                  ),
                );
                if (newNote != null) {
                  fav.updateNote(m['surah'] as int, m['ayah'] as int, newNote);
                }
              } else if (v == 'hapus') {
                fav.removeFavorite(m['surah'] as int, m['ayah'] as int);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit catatan')),
              PopupMenuItem(value: 'hapus', child: Text('Hapus')),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, '/surah-detail', arguments: {'number': m['surah'], 'name': 'Surah'}),
        );
      },
    );
  }
}
