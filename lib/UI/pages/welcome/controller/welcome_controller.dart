import 'package:hive_flutter/hive_flutter.dart';

import '../../../../storage/database.dart';

abstract class IWelcomeController {
  void onLetsStartTap();
}

class WelcomeController extends IWelcomeController {
  @override
  void onLetsStartTap() async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (isBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('isFirstLaunch', false);
    }
  }
}
