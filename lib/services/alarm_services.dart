import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../models/alarm.dart';
import 'notification_services.dart';

class AlarmServices {
  static final AlarmServices _alarmServices = AlarmServices._internal();

  factory AlarmServices() {
    return _alarmServices;
  }

  AlarmServices._internal();

  @pragma('vm:entry-point')
  Future<void> scheduleAlarms(List<AlarmModel> alarms,
      {bool isFromWorkmanager = false}) async {
    DateTime alarmTime;
    DateTime preAlarmNotificationTime;
    await AwesomeNotifications()
        .cancelSchedulesByChannelKey('alarm_notifications_channel');
    await AwesomeNotifications()
        .cancelSchedulesByChannelKey('pre_alarm_notifications_channel');
    for (AlarmModel alarm in alarms) {
      if (alarm.weekdays.isEmpty) {
        alarmTime =
            AppUtils.getNotificationTime(alarm.time.hour, alarm.time.minute);
        preAlarmNotificationTime = AppUtils.getNotificationTime(
            alarm.time.hour, alarm.time.minute - 15);
        if (alarmTime.isAfter(DateTime.now())) {
          debugPrint(alarmTime.toIso8601String());
          final int alarmNotificationId = Random().nextInt(959883616);
          final int preAlarmNotificationId = Random().nextInt(959883616);
          _scheduleOneAlarmNotification(
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
            alarmTime: alarmTime,
            alarm: alarm,
          );
          if (preAlarmNotificationTime.isAfter(DateTime.now())) {
            _scheduleOnePreAlarmNotification(
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
              preAlarmNotificationTime: preAlarmNotificationTime,
              alarm: alarm,
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
          _scheduleOneAlarmNotification(
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
            alarmTime: alarmTime,
            alarm: alarm,
          );
          _scheduleOnePreAlarmNotification(
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
            preAlarmNotificationTime: preAlarmNotificationTime,
            alarm: alarm,
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
          _scheduleOneAlarmNotification(
            alarmNotificationId: alarmNotificationId,
            preAlarmNotificationId: preAlarmNotificationId,
            alarmTime: alarmTime,
            alarm: alarm,
          );
          if (preAlarmNotificationTime.isAfter(DateTime.now())) {
            _scheduleOnePreAlarmNotification(
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
              preAlarmNotificationTime: preAlarmNotificationTime,
              alarm: alarm,
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
            _scheduleOneAlarmNotification(
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
              alarmTime: alarmTime,
              alarm: alarm,
            );
            _scheduleOnePreAlarmNotification(
              alarmNotificationId: alarmNotificationId,
              preAlarmNotificationId: preAlarmNotificationId,
              preAlarmNotificationTime: preAlarmNotificationTime,
              alarm: alarm,
            );
          }
        }
      }
    }
    final a = await AwesomeNotifications().listScheduledNotifications();
    debugPrint(a.length.toString());
  }

  @pragma('vm:entry-point')
  Future<void> _scheduleOneAlarmNotification({
    required int alarmNotificationId,
    required int preAlarmNotificationId,
    required DateTime alarmTime,
    required AlarmModel alarm,
  }) async {
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
          actionType: ActionType.SilentBackgroundAction,
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
      actionType: ActionType.SilentBackgroundAction,
      notificationCategory: NotificationCategory.Alarm,
    );
  }

  @pragma('vm:entry-point')
  Future<void> _scheduleOnePreAlarmNotification({
    required int alarmNotificationId,
    required int preAlarmNotificationId,
    required DateTime preAlarmNotificationTime,
    required AlarmModel alarm,
  }) async {
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
          actionType: ActionType.SilentBackgroundAction,
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
      actionType: ActionType.SilentBackgroundAction,
      notificationCategory: NotificationCategory.Event,
    );
  }
}
