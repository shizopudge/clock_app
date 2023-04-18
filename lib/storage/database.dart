import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/alarm.dart';

late final ValueListenable<Box<AlarmModel>> alarmsBoxListener;

class DatabaseHelper {
  static const String alarmsBox = 'alarms';
  static const String settingsBox = 'settings';

  @pragma('vm:entry-point')
  static Future<void> initDatabase() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    Hive.registerAdapter(AlarmModelAdapter());
    await Hive.openBox<AlarmModel>(alarmsBox);
    await Hive.openBox(settingsBox);
  }
}
