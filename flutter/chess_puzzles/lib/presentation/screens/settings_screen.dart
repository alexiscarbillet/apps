import 'package:flutter/material.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/board_themes.dart';
import '../../core/audio/sound_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSettingsChanged;

  const SettingsScreen({super.key, required this.onSettingsChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late BoardThemeType _selectedTheme;
  late bool _soundEnabled;
  late bool _hapticsEnabled;
  late bool _showCoordinates;

  @override
  void initState() {
    super.initState();
    _selectedTheme = LocalStorage.getBoardTheme();
    _soundEnabled = LocalStorage.getSoundEnabled();
    _hapticsEnabled = LocalStorage.getHapticsEnabled();
    _showCoordinates = LocalStorage.getShowCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Themes', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Board Themes Section
          const Text(
            'Board Theme',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Column(
            children: BoardThemeType.values.map((theme) {
              final isSelected = theme == _selectedTheme;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.amber : const Color(0xFF334155),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () async {
                    setState(() => _selectedTheme = theme);
                    await LocalStorage.setBoardTheme(theme);
                    widget.onSettingsChanged();
                  },
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: Container(color: theme.lightSquare)),
                              Expanded(child: Container(color: theme.darkSquare)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: Container(color: theme.darkSquare)),
                              Expanded(child: Container(color: theme.lightSquare)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(theme.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.amber)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Audio & Interaction Settings
          const Text(
            'Audio & Feedback',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  subtitle: const Text('Move, capture, and victory chimes'),
                  value: _soundEnabled,
                  onChanged: (val) async {
                    setState(() => _soundEnabled = val);
                    SoundService.soundEnabled = val;
                    await LocalStorage.setSoundEnabled(val);
                    widget.onSettingsChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Haptic Vibration'),
                  subtitle: const Text('Vibrations on move and error feedback'),
                  value: _hapticsEnabled,
                  onChanged: (val) async {
                    setState(() => _hapticsEnabled = val);
                    SoundService.hapticsEnabled = val;
                    await LocalStorage.setHapticsEnabled(val);
                    widget.onSettingsChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Show Board Coordinates'),
                  subtitle: const Text('Display rank (1-8) and file (a-h) labels'),
                  value: _showCoordinates,
                  onChanged: (val) async {
                    setState(() => _showCoordinates = val);
                    await LocalStorage.setShowCoordinates(val);
                    widget.onSettingsChanged();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
