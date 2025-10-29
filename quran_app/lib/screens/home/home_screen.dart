import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/home/surah_list_screen.dart';
import '../../screens/favorites/favorites_screen.dart';
import '../../screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pages = const [
      SurahListScreen(),
      FavoritesScreen(),
      SettingsScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Al-Qur\'an Digital · ${auth.name ?? 'Pengguna'}'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/search'), icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/login'), icon: const Icon(Icons.switch_account)),
        ],
      ),
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (v) => setState(() => idx = v),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: 'Surat'),
          NavigationDestination(
              icon: Icon(Icons.favorite_outline), label: 'Favorit'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
