import 'package:flutter/material.dart';

import '../UI/pages/add_alarm/widgets/weekdays.dart';
import '../UI/pages/alarm/view/alarm_view.dart';
import '../UI/pages/stopwatch/view/stopwatch_view.dart';
import '../UI/pages/timer/view/timer_view.dart';
import '../theme/fonts.dart';
import '../theme/pallete.dart';

class UIConstants {
  static const pages = [
    AlarmView(),
    StopwatchView(),
    TimerView(),
  ];

  static const List<String> daysList = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  static AppBar appBarDefault() => AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      );

  static List<Widget> daysOfTheWeek() => List.generate(
        7,
        (dayOfTheWeek) => daysOfTheWeekSwitch(dayOfTheWeek),
      );

  static const bottomBarItems = [
    BottomNavigationBarItem(
      label: 'Alarm',
      icon: Icon(
        Icons.alarm,
      ),
      activeIcon: Icon(
        Icons.alarm,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Stopwatch',
      icon: Icon(
        Icons.timer_10_rounded,
      ),
      activeIcon: Icon(
        Icons.timer_10_rounded,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Timer',
      icon: Icon(
        Icons.timer,
      ),
      activeIcon: Icon(
        Icons.timer,
      ),
    ),
  ];

  static List<Widget> launchedDays(List<String> days) => List.generate(
        daysList.length,
        (index) {
          final String day = daysList[index];
          if (days.contains(day)) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 1.2,
                    backgroundColor: Pallete.blueColor,
                  ),
                  Text(
                    day,
                    style: AppFonts.labelStyle.copyWith(
                      color: Pallete.blueColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                day,
                style: AppFonts.labelStyle.copyWith(
                  fontSize: 11,
                ),
              ),
            );
          }
        },
      );

  static Widget daysOfTheWeekSwitch(int dayOfTheWeek) {
    switch (dayOfTheWeek) {
      case 0:
        return Weekdays(
          day: 'Mon',
          dayLetter: 'M',
          style: AppFonts.labelStyle.copyWith(color: Pallete.blueColor),
        );
      case 1:
        return Weekdays(
          day: 'Tue',
          dayLetter: 'T',
          style: AppFonts.labelStyle.copyWith(color: Pallete.blueColor),
        );
      case 2:
        return Weekdays(
          day: 'Wed',
          dayLetter: 'W',
          style: AppFonts.labelStyle.copyWith(color: Pallete.blueColor),
        );
      case 3:
        return Weekdays(
          day: 'Thu',
          dayLetter: 'T',
          style: AppFonts.labelStyle.copyWith(color: Pallete.blueColor),
        );
      case 4:
        return Weekdays(
          day: 'Fri',
          dayLetter: 'F',
          style: AppFonts.labelStyle.copyWith(color: Pallete.blueColor),
        );
      case 5:
        return Weekdays(
          day: 'Sat',
          dayLetter: 'S',
          style: AppFonts.labelStyle.copyWith(color: Pallete.blueGreyColor),
        );
      case 6:
        return Weekdays(
          day: 'Sun',
          dayLetter: 'S',
          style: AppFonts.labelStyle.copyWith(color: Pallete.redColor),
        );
      default:
        return Text(
          '?',
          style: AppFonts.labelStyle.copyWith(color: Pallete.redColor),
        );
    }
  }
}
