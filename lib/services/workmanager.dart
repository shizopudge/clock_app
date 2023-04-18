import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '../models/alarm.dart';
import '../repositories/alarms_repository.dart';
import '../storage/database.dart';
import 'alarm_services.dart';
import 'notification_services.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'Schedule':
        try {
          debugPrint('Schedule is running! ${DateTime.now()}');
          await DatabaseHelper.initDatabase();
          await NotificationServices.initializeNotifications();
          final List<AlarmModel> launchedAlarms =
              await AlarmsRepository().getLaunchedAlarms();
          await AlarmServices.scheduleAlarms(launchedAlarms).whenComplete(
            () => debugPrint('Alarms scheduling is success! ${DateTime.now()}'),
          );
          debugPrint('Schedule is stoping! ${DateTime.now()}');
          return Future.value(true);
        } on Exception catch (e) {
          return Future.error(e.toString());
        }
    }

    return Future.value(true);
  });
}

// @pragma('vm:entry-point')
// Future<void> workmanagerInitialize() async {
//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true,
//   );
//   await Workmanager().registerPeriodicTask(
//     'Alarms schedule',
//     'Schedule',
//     frequency: const Duration(minutes: 15),
//   );
// }

class WorkManagerHeleper {
  @pragma('vm:entry-point')
  static Future<void> workmanagerInitialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    await Workmanager().registerPeriodicTask(
      'Alarms schedule',
      'Schedule',
      frequency: const Duration(minutes: 15),
    );
  }
}
