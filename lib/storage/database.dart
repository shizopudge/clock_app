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

  static Future<void> initDatabase() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    final isAlarmAdapterRegistered = Hive.isAdapterRegistered(0);
    final isHabitAdapterRegistered = Hive.isAdapterRegistered(1);
    final isAlarmsBoxIsOpened = Hive.isBoxOpen(alarmsBox);
    final isHabitsBoxIsOpened = Hive.isBoxOpen(habitsBox);
    final isSettingsBoxIsOpened = Hive.isBoxOpen(settingsBox);
    if (!isAlarmAdapterRegistered) {
      Hive.registerAdapter(AlarmAdapter());
    }
    if (!isHabitAdapterRegistered) {
      Hive.registerAdapter(HabitAdapter());
    }
    if (!isAlarmsBoxIsOpened) {
      await Hive.openBox<Alarm>(alarmsBox);
    }
    if (!isHabitsBoxIsOpened) {
      await Hive.openBox<Habit>(habitsBox);
    }
    if (!isSettingsBoxIsOpened) {
      await Hive.openBox(settingsBox);
    }
  }
}
