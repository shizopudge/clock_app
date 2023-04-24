import 'package:alarm_app/services/alarm_services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../repositories/alarms_repository.dart';
import '../storage/database.dart';

class NotificationServices {
  static final NotificationServices _notificationServices =
      NotificationServices._internal();

  factory NotificationServices() {
    return _notificationServices;
  }

  NotificationServices._internal();

  @pragma('vm:entry-point')
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'alarm_notifications_channel_group',
          channelKey: 'alarm_notifications_channel',
          channelName: 'Alarm notifications',
          channelDescription: 'Alarm notification channel',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          enableVibration: false,
          playSound: true,
          defaultPrivacy: NotificationPrivacy.Public,
          criticalAlerts: true,
          soundSource: 'resource://raw/alarm',
        ),
        NotificationChannel(
          channelGroupKey: 'pre_alarm_notifications_channel_group',
          channelKey: 'pre_alarm_notifications_channel',
          channelName: 'Pre alarm notifications',
          channelDescription: 'Pre alarm notification channel',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
          enableVibration: false,
          playSound: false,
        ),
        NotificationChannel(
          channelGroupKey: 'habit_notifications_channel_group',
          channelKey: 'habit_notifications_channel',
          channelName: 'Habit notifications',
          channelDescription: 'Habit notification channel',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          enableVibration: true,
          playSound: true,
        ),
        NotificationChannel(
          channelGroupKey: 'service_notifications_channel_group',
          channelKey: 'service_notifications_channel',
          channelName: 'Service notifications',
          channelDescription: 'Service notification channel',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
          enableVibration: false,
          playSound: false,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupName: 'Alarm notifications group',
          channelGroupKey: 'alarm_notifications_channel_group',
        ),
        NotificationChannelGroup(
          channelGroupName: 'Pre Alarm notifications group',
          channelGroupKey: 'pre_alarm_notifications_channel_group',
        ),
        NotificationChannelGroup(
          channelGroupName: 'Habit notifications group',
          channelGroupKey: 'habit_notifications_channel_group',
        ),
        NotificationChannelGroup(
          channelGroupName: 'Service notifications group',
          channelGroupKey: 'service_notifications_channel_group',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications()
              .requestPermissionToSendNotifications(permissions: [
            NotificationPermission.Alert,
            NotificationPermission.Car,
            NotificationPermission.Badge,
            NotificationPermission.CriticalAlert,
            NotificationPermission.FullScreenIntent,
            NotificationPermission.Light,
            NotificationPermission.OverrideDnD,
            NotificationPermission.PreciseAlarms,
            NotificationPermission.Provisional,
            NotificationPermission.Sound,
            NotificationPermission.Vibration,
          ]);
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> scheduleNotification({
    required int id,
    required final String title,
    required final String body,
    required final DateTime dateTime,
    required final String channelKey,
    required final String groupKey,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationCategory? notificationCategory,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final bool showWhen = true,
    final bool fullScreenIntent = false,
    final bool criticalAlert = true,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        groupKey: groupKey,
        displayOnForeground: true,
        displayOnBackground: true,
        wakeUpScreen: true,
        criticalAlert: criticalAlert,
        fullScreenIntent: fullScreenIntent,
        notificationLayout: notificationLayout,
        category: notificationCategory,
        payload: payload,
        title: title,
        body: body,
        showWhen: showWhen,
        summary: summary,
        bigPicture: bigPicture,
        actionType: actionType,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar.fromDate(
              date: dateTime,
              allowWhileIdle: true,
              preciseAlarm: true,
            )
          : null,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> scheduleHabit({
    required int id,
    required final String title,
    required final String body,
    required final String channelKey,
    required final String groupKey,
    required final int interval,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationCategory notificationCategory =
        NotificationCategory.Reminder,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = true,
    final bool showWhen = true,
    final bool fullScreenIntent = false,
    final bool criticalAlert = true,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        groupKey: groupKey,
        displayOnForeground: true,
        displayOnBackground: true,
        wakeUpScreen: true,
        criticalAlert: criticalAlert,
        fullScreenIntent: fullScreenIntent,
        notificationLayout: notificationLayout,
        category: notificationCategory,
        payload: payload,
        title: title,
        body: body,
        showWhen: showWhen,
        summary: summary,
        bigPicture: bigPicture,
        actionType: actionType,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              allowWhileIdle: true,
              preciseAlarm: true,
            )
          : null,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedNotification action) async {
    final payload = action.payload ?? {};
    if (action.channelKey == 'alarm_notifications_channel') {
      if (payload['action'] == 'Stop alarm') {
        await DatabaseHelper.initDatabase();
        final String alarmId = payload['alarmId'] ?? '';
        final String preAlarmNotificationId =
            payload['preAlarmNotificationId'] ?? '';
        final bool isRepeatingAlarm =
            AlarmsRepository().checkIsRepeatingAlarm(alarmId) ?? false;
        if (!isRepeatingAlarm) {
          await AlarmsRepository().disableAlarm(alarmId);
        }
        await AlarmServices()
            .dismissPreAlarmNotification(preAlarmNotificationId);
        debugPrint('STOP ALARM!');
      }
    }
    if (payload['action'] == 'Switch off' &&
        action.channelKey == 'pre_alarm_notifications_channel') {
      await DatabaseHelper.initDatabase();
      final String alarmId = payload['alarmId'] ?? '';
      final String alarmNotificationId = payload['alarmNotificationId'] ?? '';
      final bool isRepeatingAlarm =
          AlarmsRepository().checkIsRepeatingAlarm(alarmId) ?? false;
      if (!isRepeatingAlarm) {
        await AlarmsRepository().disableAlarm(alarmId);
      }
      await AlarmServices().cancelAlarmNotification(alarmNotificationId);
      debugPrint('SWITCH OFF!');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification action) async {}

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification action) async {
    if (action.channelKey == 'alarm_notifications_channel') {
      await DatabaseHelper.initDatabase();
      final payload = action.payload ?? {};
      final String alarmId = payload['alarmId'] ?? '';
      final String preAlarmNotificationId =
          payload['preAlarmNotificationId'] ?? '';
      final bool isRepeatingAlarm =
          AlarmsRepository().checkIsRepeatingAlarm(alarmId) ?? false;
      if (!isRepeatingAlarm) {
        await AlarmsRepository().disableAlarm(alarmId);
      }
      await AlarmServices().dismissPreAlarmNotification(preAlarmNotificationId);
    }
    debugPrint('NOTIFICATION DISPLAYED!');
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification action) async {
    debugPrint('NOTIFICATION DISSMISSED!');
  }
}
