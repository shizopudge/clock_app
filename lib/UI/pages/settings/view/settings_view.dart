import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';
import '../../../../theme/theme.dart';
import '../controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  final SettingsController _settingsController;
  const SettingsView(
      {super.key, required SettingsController settingsController})
      : _settingsController = settingsController;

  @override
  Widget build(BuildContext context) {
    final String theme = Hive.box(DatabaseHelper.settingsBox)
        .get('theme', defaultValue: AppTheme.defaultTheme);
    return Container(
      decoration: BoxDecoration(
        gradient: theme == AppTheme.lightThemeName
            ? PalleteLight.backgroundGradient
            : null,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Settings',
            style: AppFonts.titleStyle,
          ),
        ),
        body: Column(
          children: [
            SettingsListTile(
              onTap: () async {
                showMenu(
                  context: context,
                  position:
                      const RelativeRect.fromLTRB(double.infinity, 120, 8, 0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  items: [
                    PopupMenuItem(
                      onTap: () => _settingsController.toggleTheme(),
                      child: Text(
                        'Dark',
                        style: AppFonts.labelStyle,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _settingsController.toggleTheme(),
                      child: Text(
                        'Light',
                        style: AppFonts.labelStyle,
                      ),
                    ),
                  ],
                );
              },
              currentSetting:
                  theme == AppTheme.darkThemeName ? 'Dark' : 'Light',
              title: 'Theme',
              icon: theme == AppTheme.darkThemeName
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String currentSetting;
  final IconData icon;
  const SettingsListTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.currentSetting,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        leading: Icon(
          icon,
          size: 32,
        ),
        title: Text(
          title,
          style: AppFonts.titleStyle,
        ),
        subtitle: Text(
          currentSetting,
          style: AppFonts.titleStyle,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 21,
        ),
      ),
    );
  }
}
