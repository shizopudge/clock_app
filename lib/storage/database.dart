import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/alarm/alarm.dart';
import '../models/habit/habit.dart';

late final ValueListenable<Box<Alarm>> alarmsBoxListener;

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal();

  static const String alarmsBox = 'alarms';
  static const String habitsBox = 'habits';
  static const String settingsBox = 'settings';

  @pragma('vm:entry-point')
  static Future<void> initDatabase() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    Hive.registerAdapter(AlarmAdapter());
    Hive.registerAdapter(HabitAdapter());
    await Hive.openBox<Alarm>(alarmsBox);
    await Hive.openBox<Habit>(habitsBox);
    await Hive.openBox(settingsBox);
  }
}
