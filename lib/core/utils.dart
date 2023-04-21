import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:intl/intl.dart';

class AppUtils {
  static final DateFormat _dateFormat = DateFormat('EEE, d MMM');

  static final DateFormat _timeFormat = DateFormat('Hm');

  static void showSnackBar(
    BuildContext context,
    String content, {
    int duration = 3000,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
        ),
        duration: Duration(
          milliseconds: duration,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String formatSecondsBeforeNextAlarm(int secondsBeforeNextAlarm) {
    late final int hours;
    late final int minutes;
    late final int seconds;
    if (secondsBeforeNextAlarm > 3600) {
      hours = (secondsBeforeNextAlarm / 3600).floor();
      minutes = (secondsBeforeNextAlarm % 3600 / 60).floor();
      seconds = (secondsBeforeNextAlarm % 3600 % 60).floor();
      return '$hours h. $minutes min. $seconds sec.';
    } else if (secondsBeforeNextAlarm == 3600) {
      hours = 1;
      return '$hours h.';
    } else if (secondsBeforeNextAlarm < 3600 && secondsBeforeNextAlarm > 60) {
      minutes = (secondsBeforeNextAlarm % 3600 / 60).floor();
      seconds = (secondsBeforeNextAlarm % 3600 % 60).floor();
      return '$minutes min. $seconds sec.';
    } else if (secondsBeforeNextAlarm == 60) {
      minutes = 1;
      return '$minutes min.';
    } else {
      seconds = (secondsBeforeNextAlarm % 3600 % 60).floor();
      return '$seconds sec.';
    }
  }

  static String getTomorrowDate() {
    final DateTime now = DateTime.now();
    final DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    return _dateFormat.format(tomorrow);
  }

  static DateTime getNotificationTime(
    int hour,
    int minute, {
    bool isTomorrow = false,
  }) =>
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        isTomorrow ? DateTime.now().day + 1 : DateTime.now().day,
        hour,
        minute,
      );

  static String formatTime(DateTime time) => _timeFormat.format(time);

  static String daysOfTheWeekToString(List<String> days) {
    return days.join(', ');
  }

  static Future<String> getCurrentTimeZone() async =>
      await FlutterTimezone.getLocalTimezone();

  static String convertIntDayToString(int dayNum) {
    switch (dayNum) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '?';
    }
  }

  static DateTime convertNotificationScheduleToDateTime(
      Map<String, dynamic>? schedule) {
    return DateTime(
        schedule?['year'] as int,
        schedule?['month'] as int,
        schedule?['day'] as int,
        schedule?['hour'] as int,
        schedule?['minute'] as int);
  }

  static String formatInterval(int interval) {
    int formatedInterval;
    String unit;
    if (interval < 3600) {
      formatedInterval = interval ~/ 60;
      unit = 'm';
    } else if (interval >= 3600 && interval < 86400) {
      formatedInterval = interval ~/ 3600;
      unit = 'h';
    } else {
      formatedInterval = interval ~/ 86400;
      unit = 'd';
    }
    return '$formatedInterval $unit';
  }
}
