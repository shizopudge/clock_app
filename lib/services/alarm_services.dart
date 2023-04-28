import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/utils.dart';

import '../models/alarm/alarm.dart';
import '../models/habit/habit.dart';
import '../repositories/alarms_repository.dart';
import '../storage/database.dart';
import 'notification_services.dart';

abstract class IAlarmServices {
  Future<void> scheduleAlarms();

  Future<void> cancelAlarmNotification(String alarmNotificationId);

  Future<void> dismissPreAlarmNotification(String preAlarmNotificationId);

  Future<void> scheduleHabit(Habit habit);

  Future<void> scheduleHabits(List<Habit> habits);

  Future<void> cancelHabitSchedule(String habitId);

  Future<void> cancelHabitSchedules(List<String> habitsIds);

  Future<void> scheduleOneAlarmNotification(
      {required DateTime alarmTime,
      required Alarm alarm,
      required int alarmNotificationId,
      required int preAlarmNotificationId});

  Future<void> scheduleOnePreAlarmNotification(
      {required DateTime preAlarmNotificationTime,
      required Alarm alarm,
      required int alarmNotificationId,
      required int preAlarmNotificationId});

  Future<void> onAlarmFromLockScreen();
}

class AlarmServices extends IAlarmServices {
  static final AlarmServices _alarmServices = AlarmServices._internal();

  factory AlarmServices() {
    return _alarmServices;
  }

  AlarmServices._internal();

  @override
  Future<void> scheduleAlarms() async {
    DateTime alarmTime;
    DateTime preAlarmNotificationTime;
    await AwesomeNotifications()
        .cancelSchedulesByChannelKey('alarm_notifications_channel');
    await AwesomeNotifications()
        .cancelSchedulesByChannelKey('pre_alarm_notifications_channel');
    final List<Alarm> enabledAlarms = AlarmsRepository().getEnabledAlarms();
    for (Alarm alarm in enabledAlarms) {
      if (alarm.weekdays.isEmpty) {
        alarmTime =
            AppUtils.getNotificationTime(alarm.time.hour, alarm.time.minute);
        preAlarmNotificationTime = AppUtils.getNotificationTime(
            alarm.time.hour, alarm.time.minute - 15);
        if (alarmTime.isAfter(DateTime.now())) {
          debugPrint(alarmTime.toIso8601String());
          final int alarmNotificationId = Random().nextInt(959883616);
          final int preAlarmNotificationId = Random().nextInt(959883616);
          scheduleOneAlarmNotification(
            alarmTime: alarmTime,
            alarm: alarm,
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
          );
          if (preAlarmNotificationTime.isAfter(DateTime.now())) {
            scheduleOnePreAlarmNotification(
              preAlarmNotificationTime: preAlarmNotificationTime,
              alarm: alarm,
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
            );
          }
        } else {
          alarmTime = AppUtils.getNotificationTime(
            alarm.time.hour,
            alarm.time.minute,
            isTomorrow: true,
          );
          preAlarmNotificationTime = AppUtils.getNotificationTime(
            alarm.time.hour,
            alarm.time.minute - 15,
            isTomorrow: true,
          );
          debugPrint(alarmTime.toIso8601String());
          final int alarmNotificationId = Random().nextInt(959883616);
          final int preAlarmNotificationId = Random().nextInt(959883616);
          scheduleOneAlarmNotification(
            alarmTime: alarmTime,
            alarm: alarm,
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
          );
          scheduleOnePreAlarmNotification(
            preAlarmNotificationTime: preAlarmNotificationTime,
            alarm: alarm,
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
          );
        }
      } else {
        alarmTime =
            AppUtils.getNotificationTime(alarm.time.hour, alarm.time.minute);
        preAlarmNotificationTime = AppUtils.getNotificationTime(
            alarm.time.hour, alarm.time.minute - 15);
        if (alarmTime.isAfter(DateTime.now()) &&
            alarm.weekdays
                .contains(AppUtils.convertIntDayToString(alarmTime.weekday))) {
          debugPrint(alarmTime.toIso8601String());
          final int alarmNotificationId = Random().nextInt(959883616);
          final int preAlarmNotificationId = Random().nextInt(959883616);
          scheduleOneAlarmNotification(
            alarmTime: alarmTime,
            alarm: alarm,
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
          );
          if (preAlarmNotificationTime.isAfter(DateTime.now())) {
            scheduleOnePreAlarmNotification(
              preAlarmNotificationTime: preAlarmNotificationTime,
              alarm: alarm,
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
            );
          }
        } else {
          alarmTime = AppUtils.getNotificationTime(
            alarm.time.hour,
            alarm.time.minute,
            isTomorrow: true,
          );
          preAlarmNotificationTime = AppUtils.getNotificationTime(
            alarm.time.hour,
            alarm.time.minute - 15,
            isTomorrow: true,
          );
          if (alarm.weekdays
              .contains(AppUtils.convertIntDayToString(alarmTime.weekday))) {
            debugPrint(alarmTime.toIso8601String());
            final int alarmNotificationId = Random().nextInt(959883616);
            final int preAlarmNotificationId = Random().nextInt(959883616);
            scheduleOneAlarmNotification(
              alarmTime: alarmTime,
              alarm: alarm,
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
            );
            scheduleOnePreAlarmNotification(
              preAlarmNotificationTime: preAlarmNotificationTime,
              alarm: alarm,
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
            );
          }
        }
      }
    }
    final listScheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();
    debugPrint(listScheduledNotifications.length.toString());
  }

  @override
  Future<void> cancelAlarmNotification(String alarmNotificationId) async {
    final int id = int.parse(alarmNotificationId);
    await AwesomeNotifications().cancel(id);
  }

  @override
  Future<void> dismissPreAlarmNotification(
      String preAlarmNotificationId) async {
    final int id = int.parse(preAlarmNotificationId);
    await AwesomeNotifications().cancel(id);
  }

  @override
  Future<void> scheduleHabit(Habit habit) async {
    bool isAlreadyExists = false;
    final scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();
    for (NotificationModel notification in scheduledNotifications) {
      final payload = notification.content?.payload ?? {};
      if (payload['habitId'] == habit.id) {
        isAlreadyExists = true;
      }
    }
    if (!isAlreadyExists) {
      final int habitId = Random().nextInt(959883616);
      await NotificationServices.scheduleHabit(
        id: habitId,
        title: habit.name,
        body: habit.description ?? '',
        channelKey: 'habit_notifications_channel',
        groupKey: 'habit_notifications_channel_group',
        interval: habit.interval,
        scheduled: true,
        payload: {
          'habitId': habit.id,
        },
      );
    }
  }

  @override
  Future<void> scheduleHabits(List<Habit> habits) async {
    for (Habit habit in habits) {
      if (habit.isEnabled) {
        await scheduleHabit(habit);
      } else {
        await cancelHabitSchedule(habit.id);
      }
    }
  }

  @override
  Future<void> cancelHabitSchedule(String habitId) async {
    final scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();
    for (NotificationModel notification in scheduledNotifications) {
      final payload = notification.content?.payload ?? {};
      if (payload['habitId'] == habitId) {
        await AwesomeNotifications().cancel(notification.content?.id ?? 0);
      }
    }
  }

  @override
  Future<void> cancelHabitSchedules(List<String> habitsIds) async {
    for (String habitId in habitsIds) {
      await cancelHabitSchedule(habitId);
    }
  }

  @override
  Future<void> scheduleOneAlarmNotification(
      {required DateTime alarmTime,
      required Alarm alarm,
      required int alarmNotificationId,
      required int preAlarmNotificationId}) async {
    await NotificationServices.scheduleNotification(
      id: alarmNotificationId,
      title: AppUtils.formatTime(alarm.time),
      body: alarm.name ?? 'Alarm!',
      channelKey: 'alarm_notifications_channel',
      groupKey: 'alarm_notifications_channel_group',
      dateTime: alarmTime,
      actionButtons: [
        NotificationActionButton(
          key: 'Stop',
          actionType: ActionType.SilentAction,
          label: 'Stop',
        ),
      ],
      payload: {
        'action': 'Stop alarm',
        'preAlarmNotificationId': preAlarmNotificationId.toString(),
        'alarmId': alarm.id,
      },
      criticalAlert: true,
      showWhen: false,
      scheduled: true,
      actionType: ActionType.SilentAction,
      notificationCategory: NotificationCategory.Alarm,
    );
  }

  @override
  Future<void> scheduleOnePreAlarmNotification(
      {required DateTime preAlarmNotificationTime,
      required Alarm alarm,
      required int alarmNotificationId,
      required int preAlarmNotificationId}) async {
    await NotificationServices.scheduleNotification(
      id: preAlarmNotificationId,
      title: 'Alarm clock at ${AppUtils.formatTime(alarm.time)}',
      body: alarm.name != null
          ? '${alarm.name}. The alarm clock will ring soon!'
          : 'The alarm clock will ring soon!',
      channelKey: 'pre_alarm_notifications_channel',
      groupKey: 'pre_alarm_notifications_channel_group',
      dateTime: preAlarmNotificationTime,
      actionButtons: [
        NotificationActionButton(
          key: 'Switch off',
          actionType: ActionType.SilentAction,
          label:
              alarm.weekdays.isNotEmpty ? 'Turn off this time' : 'Switch off',
        ),
      ],
      payload: {
        'action': 'Switch off',
        'alarmNotificationId': alarmNotificationId.toString(),
        'alarmId': alarm.id,
      },
      showWhen: false,
      scheduled: true,
      actionType: ActionType.SilentAction,
      notificationCategory: NotificationCategory.Event,
    );
  }

  @override
  Future<void> onAlarmFromLockScreen() async {
    final isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (!isBoxOpened) {
      await Hive.openBox(DatabaseHelper.settingsBox);
      final settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('isFromAlarm', true);
    } else {
      final settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('isFromAlarm', true);
    }
  }
}
