import 'package:flutter/material.dart';

import '../UI/pages/add_edit_alarm/widgets/weekdays.dart';
import '../UI/pages/alarm/view/alarm_view.dart';
import '../UI/pages/habits/view/habit_view.dart';
import '../theme/fonts.dart';
import '../theme/pallete.dart';
import 'core_constants.dart';

class UIConstants {
  static final alarmsNestedScrollViewKey = GlobalKey<NestedScrollViewState>();

  static final habitsNestedScrollViewKey = GlobalKey<NestedScrollViewState>();

  static final pages = [
    AlarmView(
      alarmController: CoreConstants.alarmController,
    ),
    HabitView(
      habitController: CoreConstants.habitController,
    ),
    const SizedBox(),
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
      label: 'Habits',
      icon: Icon(
        Icons.update_rounded,
      ),
      activeIcon: Icon(
        Icons.update_rounded,
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
                  const CircleAvatar(
                    radius: 1.2,
                    backgroundColor: PalleteLight.actionColor,
                  ),
                  Text(
                    day,
                    style: AppFonts.labelStyle.copyWith(
                      color: PalleteLight.actionColor,
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
          style: AppFonts.labelStyle.copyWith(
            color: PalleteLight.actionColor,
            fontWeight: FontWeight.bold,
          ),
        );
      case 1:
        return Weekdays(
          day: 'Tue',
          dayLetter: 'T',
          style: AppFonts.labelStyle.copyWith(
            color: PalleteLight.actionColor,
            fontWeight: FontWeight.bold,
          ),
        );
      case 2:
        return Weekdays(
          day: 'Wed',
          dayLetter: 'W',
          style: AppFonts.labelStyle.copyWith(
            color: PalleteLight.actionColor,
            fontWeight: FontWeight.bold,
          ),
        );
      case 3:
        return Weekdays(
          day: 'Thu',
          dayLetter: 'T',
          style: AppFonts.labelStyle.copyWith(
            color: PalleteLight.actionColor,
            fontWeight: FontWeight.bold,
          ),
        );
      case 4:
        return Weekdays(
          day: 'Fri',
          dayLetter: 'F',
          style: AppFonts.labelStyle.copyWith(
            color: PalleteLight.actionColor,
            fontWeight: FontWeight.bold,
          ),
        );
      case 5:
        return Weekdays(
          day: 'Sat',
          dayLetter: 'S',
          style: AppFonts.labelStyle.copyWith(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        );
      case 6:
        return Weekdays(
          day: 'Sun',
          dayLetter: 'S',
          style: AppFonts.labelStyle.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return Text(
          '?',
          style: AppFonts.labelStyle.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }
}
