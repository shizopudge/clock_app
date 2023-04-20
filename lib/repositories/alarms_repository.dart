import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/alarm/alarm.dart';
import '../storage/database.dart';

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

  List<Alarm> getAlarms();

  List<Alarm> getEnabledAlarms();

  Future<void> enableAlarm(String id);

  Future<void> enableAlarms(List<String> ids);

  Future<void> deleteAlarm(String id);

  Future<void> deleteAlarms(List<String> ids);

  bool? checkIsRepeatingAlarm(String id);

  int? secondsBeforeNextAlarm(List<Alarm> alarms);
}

class AlarmsRepository extends IAlarmsRepository {
  static final AlarmsRepository _alarmsRepository =
      AlarmsRepository._internal();

  factory AlarmsRepository() {
    return _alarmsRepository;
  }

  AlarmsRepository._internal();

  @override
  Future<void> createAlarm({
    required String? name,
    required DateTime time,
    required List<String> weekdays,
  }) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final List<Alarm> alarms = alarmsBox.values.toList();
        for (Alarm e in alarms) {
          if (e.time == time) {
            await alarmsBox.put(
              e.id,
              e.copyWith(
                name: name,
                time: time,
                weekdays: weekdays,
                isEnabled: true,
              ),
            );
            return;
          }
        }
        final String id = const Uuid().v1();
        final Alarm alarm = Alarm(
          id: id,
          name: name,
          time: time,
          weekdays: weekdays,
          isEnabled: true,
        );
        await alarmsBox.put(
          id,
          alarm,
        );
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> updateAlarm({
    required String id,
    required String? name,
    required DateTime time,
    required List<String> weekdays,
  }) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final Alarm alarm = Alarm(
          id: id,
          name: name,
          time: time,
          weekdays: weekdays,
          isEnabled: true,
        );
        await alarmsBox.put(
          id,
          alarm,
        );
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  List<Alarm> getAlarms() {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final List<Alarm> alarms = alarmsBox.values.toList()
          ..sort(
            (a, b) => a.time.compareTo(b.time),
          );
        return alarms;
      } else {
        debugPrint('Alarms box is closed!');
        return [];
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
      return [];
    }
  }

  @pragma('vm:entry-point')
  @override
  List<Alarm> getEnabledAlarms() {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        List<Alarm> launchedAlarms = [];
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final List<Alarm> allAlarms = alarmsBox.values.toList();
        for (Alarm e in allAlarms) {
          if (e.isEnabled) {
            launchedAlarms.add(e);
          }
        }
        return launchedAlarms;
      } else {
        debugPrint('Alarms box is closed!');
        return [];
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
      return [];
    }
  }

  @override
  Future<void> enableAlarm(String id) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final Alarm? alarm = alarmsBox.get(id);
        if (alarm != null) {
          if (alarm.isEnabled) {
            final Alarm updatedAlarm = alarm.copyWith(isEnabled: false);
            await alarmsBox.put(id, updatedAlarm);
          } else {
            final Alarm updatedAlarm = alarm.copyWith(isEnabled: true);
            await alarmsBox.put(id, updatedAlarm);
          }
        }
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> enableAlarms(List<String> ids) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        List<Alarm> updatedAlarms = [];
        Map<dynamic, Alarm> updatedAlarmsMap = {};
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final alarms = alarmsBox.values.toList();
        for (Alarm alarm in alarms) {
          if (ids.contains(alarm.id)) {
            if (alarm.isEnabled) {
              updatedAlarms.add(alarm.copyWith(isEnabled: false));
            } else {
              updatedAlarms.add(alarm.copyWith(isEnabled: true));
            }
          }
        }
        for (Alarm alarm in updatedAlarms) {
          updatedAlarmsMap[alarm.id] = alarm;
        }
        await alarmsBox.putAll(updatedAlarmsMap);
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> deleteAlarm(String id) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        await alarmsBox.delete(id);
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> deleteAlarms(List<String> ids) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        await alarmsBox.deleteAll(ids);
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  int? secondsBeforeNextAlarm(List<Alarm> alarms) {
    try {
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
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
      return null;
    }
  }

  @override
  bool? checkIsRepeatingAlarm(String id) {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.alarmsBox);
      if (isBoxOpened) {
        final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);
        final Alarm? alarm = alarmsBox.get(id);
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
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
      return null;
    }
  }
}
