import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:wakelock/wakelock.dart';

import '../core/utils.dart';

import '../models/habit/habit.dart';
import '../repositories/habits_repository.dart';
import '../storage/database.dart';
import 'alarm_services.dart';
import 'notification_services.dart';

class AppLaunchServices {
  static final AppLaunchServices _appLaunchServices =
      AppLaunchServices._internal();

  factory AppLaunchServices() {
    return _appLaunchServices;
  }

  AppLaunchServices._internal();

  Future<void> onAppLaunch() async {
    await DatabaseHelper.initDatabase();
    await NotificationServices.initializeNotifications();
    await _onAppStartWork();
  }

  Future<void> _onAppStartWork() async {
    final bool isSettingsBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    final bool isAlarmsBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    late final bool isFirstLaunch;
    if (isSettingsBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      final String timezone = await AppUtils.getCurrentTimeZone();
      await settingsBox.put(
        'timezone',
        timezone,
      );
      isFirstLaunch = settingsBox.get('isFirstLaunch', defaultValue: true);
    }
    if (isAlarmsBoxOpened && !isFirstLaunch) {
      final List<Habit> enabledHabits = HabitsRepository().getEnabledHabits();
      await AlarmServices().scheduleAlarms().whenComplete(
            () => debugPrint(
                'Alarms scheduling on app start is success! ${DateTime.now()}'),
          );
      await AlarmServices()
          .scheduleHabits(
            enabledHabits,
          )
          .whenComplete(
            () => debugPrint(
                'Habits scheduling on app start is success! ${DateTime.now()}'),
          );
    }
    final bool isKeepScreenOn = await KeepScreenOn.isOn ?? false;
    if (!isKeepScreenOn) {
      KeepScreenOn.turnOn();
    }
    final bool wakelockEnabled = await Wakelock.enabled;
    if (!wakelockEnabled) {
      Wakelock.enable();
    }
    FlutterNativeSplash.remove();
  }
}
