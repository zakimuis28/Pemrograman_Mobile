import 'package:flutter/material.dart';

class SurahTile extends StatelessWidget {
  final int number;
  final String name;
  final String latin;
  final int totalAyah;
  final VoidCallback? onTap;

  const SurahTile({super.key, required this.number, required this.name, required this.latin, required this.totalAyah, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('$number')),
      title: Text(latin),
      subtitle: Text('$name · $totalAyah ayat'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

