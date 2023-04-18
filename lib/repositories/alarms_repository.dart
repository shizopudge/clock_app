import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../storage/database.dart';
import '../models/alarm.dart';

abstract class IAlarmsRepository {
  Future<void> createAlarm({
    required String? name,
    required DateTime time,
    required List<String> weekdays,
  });

  Future<void> updateAlarm({
    required String id,
    required String? name,
    required DateTime time,
    required List<String> weekdays,
  });

  Future<List<AlarmModel>> getAlarms();

  Future<List<AlarmModel>> getLaunchedAlarms();

  Future<void> launchAlarm(String id);

  Future<void> deleteAlarm(String id);

  bool? checkIsRepeatingAlarm(String id);

  int? secondsBeforeNextAlarm(List<AlarmModel> alarms);
}

class AlarmsRepository extends IAlarmsRepository {
  @override
  Future<void> createAlarm({
    required String? name,
    required DateTime time,
    required List<String> weekdays,
  }) async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      final List<AlarmModel> alarms = alarmsBox.values.toList();
      for (AlarmModel e in alarms) {
        if (e.time == time) {
          await alarmsBox.put(
            e.id,
            e.copyWith(
              name: name,
              time: time,
              weekdays: weekdays,
              islaunched: true,
            ),
          );
          return;
        }
      }
      final String id = const Uuid().v1();
      final AlarmModel alarm = AlarmModel(
        id: id,
        name: name,
        time: time,
        weekdays: weekdays,
        islaunched: true,
      );
      await alarmsBox.put(
        id,
        alarm,
      );
    } else {
      debugPrint('Alarms box is closed!');
    }
  }

  @override
  Future<void> updateAlarm({
    required String id,
    required String? name,
    required DateTime time,
    required List<String> weekdays,
  }) async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      final AlarmModel alarm = AlarmModel(
        id: id,
        name: name,
        time: time,
        weekdays: weekdays,
        islaunched: true,
      );
      await alarmsBox.put(
        id,
        alarm,
      );
    } else {
      debugPrint('Alarms box is closed!');
    }
  }

  @override
  Future<List<AlarmModel>> getAlarms() async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      final List<AlarmModel> alarms = alarmsBox.values.toList()
        ..sort(
          (a, b) => a.time.compareTo(b.time),
        );
      return alarms;
    } else {
      debugPrint('Alarms box is closed!');
      return [];
    }
  }

  @pragma('vm:entry-point')
  @override
  Future<List<AlarmModel>> getLaunchedAlarms() async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      List<AlarmModel> launchedAlarms = [];
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      final List<AlarmModel> allAlarms = alarmsBox.values.toList();
      for (AlarmModel e in allAlarms) {
        if (e.islaunched) {
          launchedAlarms.add(e);
        }
      }
      return launchedAlarms;
    } else {
      debugPrint('Alarms box is closed!');
      return [];
    }
  }

  @override
  Future<void> launchAlarm(String id) async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      final AlarmModel? alarm = alarmsBox.get(id);
      if (alarm != null) {
        if (alarm.islaunched) {
          final AlarmModel updatedAlarm = alarm.copyWith(islaunched: false);
          await alarmsBox.put(id, updatedAlarm);
        } else {
          final AlarmModel updatedAlarm = alarm.copyWith(islaunched: true);
          await alarmsBox.put(id, updatedAlarm);
        }
      }
    } else {
      debugPrint('Alarms box is closed!');
    }
  }

  @override
  Future<void> deleteAlarm(String id) async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      await alarmsBox.delete(id);
    } else {
      debugPrint('Alarms box is closed!');
    }
  }

  @override
  int? secondsBeforeNextAlarm(List<AlarmModel> alarms) {
    final DateTime now = DateTime.now();
    late int secondsBeforeNextAlarm;
    for (int i = 0; i < alarms.length; i++) {
      final DateTime checkDate = DateTime(
        now.year,
        now.month,
        now.day,
        alarms[i].time.hour,
        alarms[i].time.minute,
        alarms[i].time.second,
      );
      if (now.isBefore(checkDate)) {
        if (i == 0) {
          secondsBeforeNextAlarm = checkDate.difference(now).inSeconds;
        } else {
          if (checkDate.difference(now).inSeconds < secondsBeforeNextAlarm) {
            secondsBeforeNextAlarm = checkDate.difference(now).inSeconds;
          }
        }
      } else {
        final DateTime checkDate = DateTime(
          now.year,
          now.month,
          now.day + 1,
          alarms[i].time.hour,
          alarms[i].time.minute,
          alarms[i].time.second,
        );
        if (i == 0) {
          secondsBeforeNextAlarm = checkDate.difference(now).inSeconds;
        } else {
          if (checkDate.difference(now).inSeconds < secondsBeforeNextAlarm) {
            secondsBeforeNextAlarm = checkDate.difference(now).inSeconds;
          }
        }
      }
    }
    return secondsBeforeNextAlarm;
  }

  @override
  bool? checkIsRepeatingAlarm(String id) {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
    if (isBoxOpened) {
      final Box<AlarmModel> alarmsBox =
          Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
      final AlarmModel? alarm = alarmsBox.get(id);
      if (alarm != null) {
        if (alarm.weekdays.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }
    }
    debugPrint('Alarms box is closed!');
    return null;
  }
}
