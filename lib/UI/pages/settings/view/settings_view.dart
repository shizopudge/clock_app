import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';
import '../../../../theme/theme.dart';
import '../controller/settings_controller.dart';
import '../widgets/settings_list_tile.dart';

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
                await showMenu(
                  context: context,
                  position:
                      const RelativeRect.fromLTRB(double.infinity, 120, 8, 0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  items: [
                    PopupMenuItem(
                      onTap: () => _settingsController
                          .switchTheme(AppTheme.darkThemeName),
                      child: Text(
                        'Dark',
                        style: AppFonts.labelStyle,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _settingsController
                          .switchTheme(AppTheme.lightThemeName),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Clock\nVersion: 1.0.0',
                textAlign: TextAlign.center,
                style: AppFonts.titleStyle.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
