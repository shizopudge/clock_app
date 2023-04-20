import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/utils.dart';

import '../models/alarm/alarm.dart';
import '../repositories/alarms_repository.dart';
import '../storage/database.dart';
import 'alarm_services.dart';

class AppLaunchServices {
  static final AppLaunchServices _appLaunchServices =
      AppLaunchServices._internal();

  factory AppLaunchServices() {
    return _appLaunchServices;
  }

  AppLaunchServices._internal();

  static Future<void> onAppLaunch() async {
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
      final List<Alarm> launchedAlarms = AlarmsRepository().getEnabledAlarms();
      await AlarmServices()
          .scheduleAlarms(
            launchedAlarms,
            isFromWorkmanager: true,
          )
          .whenComplete(
            () => debugPrint(
                'Alarms scheduling on app start is success! ${DateTime.now()}'),
          );
    }
  }
}