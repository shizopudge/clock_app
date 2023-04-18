import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../repositories/alarms_repository.dart';

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
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
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
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        groupKey: groupKey,
        displayOnForeground: true,
        displayOnBackground: true,
        wakeUpScreen: true,
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
            )
          : null,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedNotification action) async {
    final payload = action.payload ?? {};
    final String alarmId = payload['alarmId'] ?? '';
    final String alarmNotificationId = payload['alarmNotificationId'] ?? '';
    if (payload['action'] == 'Stop alarm') {
      debugPrint('STOP!');
    }
    if (payload['action'] == 'Switch off') {
      await AwesomeNotifications()
          .cancelSchedule(int.parse(alarmNotificationId));
      final bool isRepeatingAlarm =
          AlarmsRepository().checkIsRepeatingAlarm(alarmId) ?? false;
      if (!isRepeatingAlarm) {
        await AlarmsRepository().launchAlarm(alarmId);
      }
      debugPrint('SWITCH OFF!');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification action) async {}

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification action) async {
    final payload = action.payload ?? {};
    final String alarmId = payload['alarmId'] ?? '';
    final String preAlarmNotificationId =
        payload['preAlarmNotificationId'] ?? '';
    if (action.channelKey == 'alarm_notifications_channel') {
      await AwesomeNotifications().dismiss(int.parse(preAlarmNotificationId));
      final bool isRepeatingAlarm =
          AlarmsRepository().checkIsRepeatingAlarm(alarmId) ?? false;
      if (!isRepeatingAlarm) {
        await AlarmsRepository().launchAlarm(alarmId);
      }
    }
    debugPrint('NOTIFICATION DISPLAYED!');
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification action) async {
    debugPrint('NOTIFICATION DISSMISSED!');
  }
}
