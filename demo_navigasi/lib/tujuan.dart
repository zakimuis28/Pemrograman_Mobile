import 'package:flutter/material.dart';
import 'home.dart'; // gunakan komponen yang sama untuk konsistensi

class TujuanPage extends StatelessWidget {
  const TujuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientScaffold(
      title: 'Halaman Tujuan',
      emoji: '🏝️',
      info:
          'Kamu berhasil sampai di halaman tujuan 🌊\n'
          'Gunakan tombol di kiri atas atau tombol di bawah untuk kembali. '
          'Navigator.pop(context) akan menutup halaman ini dan kembali ke Home.',
      primaryActionLabel: '← Kembali ke Home',
      onPrimaryTap: () => Navigator.pop(context),
      flip: true, // gradasi dibalik biar beda vibe
    );
  }
}
