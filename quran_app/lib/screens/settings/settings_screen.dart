import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(auth.name ?? 'Profil'),
          subtitle: Text(auth.email ?? '-'),
          trailing: TextButton(onPressed: () async {
            final nameCtrl = TextEditingController(text: auth.name ?? '');
            final newName = await showDialog<String>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Edit Nama'),
                content: TextField(controller: nameCtrl),
                actions: [
                  TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Batal')),
                  ElevatedButton(onPressed: ()=> Navigator.pop(context, nameCtrl.text), child: const Text('Simpan')),
                ],
              ),
            );
            if (newName != null) {
              await context.read<AuthProvider>().updateProfile(name: newName);
            }
          }, child: const Text('Edit')),
        ),
        const SizedBox(height: 16),
        const Text('Tampilan', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
            ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
            ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.auto_mode)),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (s) => settings.setThemeMode(s.first),
        ),
        const SizedBox(height: 16),
        const Text('Ukuran Teks'),
        Slider(
          value: settings.fontScale,
          min: 0.8,
          max: 1.6,
          divisions: 8,
          label: settings.fontScale.toStringAsFixed(2),
          onChanged: settings.setFontScale,
        ),
        const SizedBox(height: 16),
        const Text('Bahasa Terjemahan'),
        DropdownButton<String>(
          value: settings.translation,
          items: const [
            DropdownMenuItem(value: 'id', child: Text('Indonesia')),
            DropdownMenuItem(value: 'en', child: Text('English')),
          ],
          onChanged: (v) { if (v != null) settings.setTranslation(v); },
        ),
        const SizedBox(height: 32),
        FilledButton.tonal(
          onPressed: () => context.read<AuthProvider>().logout(),
          child: const Text('Keluar'),
        )
      ],
    );
  }
}
