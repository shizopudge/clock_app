import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  static void _onLetsStartTap() async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (isBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('isFirstLaunch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              'Welcome',
              style: AppFonts.headerStyle,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: _onLetsStartTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Lets start!',
                    style: AppFonts.labelStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
