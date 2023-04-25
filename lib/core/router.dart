import 'package:flutter/material.dart';

import '../UI/pages/add_edit_alarm/view/add_edit_alarm_view.dart';
import '../UI/pages/add_edit_habit/view/add_edit_habit_view.dart';
import '../UI/pages/alarm_page/view/alarm_page_view.dart';
import '../UI/pages/settings/view/settings_view.dart';
import '../constants/core_constants.dart';

class AppRouter {
  static final AppRouter _appRouter = AppRouter._internal();

  factory AppRouter() {
    return _appRouter;
  }

  AppRouter._internal();

  static final Widget settingsPage = SettingsView(
    settingsController: CoreConstants.settingsController,
  );

  static final Widget addAlarmPage = AddEditAlarmView(
    isAddAlarm: true,
    addEditAlarmController: CoreConstants.addEditAlarmController,
  );

  static final Widget editAlarmPage = AddEditAlarmView(
    isAddAlarm: false,
    addEditAlarmController: CoreConstants.addEditAlarmController,
  );

  static final Widget addHabitPage = AddEditHabitView(
    isAddHabit: true,
    addEditHabitController: CoreConstants.addEditHabitController,
  );

  static final Widget editHabitPage = AddEditHabitView(
    isAddHabit: false,
    addEditHabitController: CoreConstants.addEditHabitController,
  );
  static final Widget alarmPageView =
      AlarmPageView(alarmPageController: CoreConstants.alarmPageController);

  static void navigateWithSlideTransition(BuildContext context, Widget page) =>
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
}
