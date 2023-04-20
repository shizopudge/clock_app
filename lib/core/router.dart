import 'package:flutter/material.dart';

import '../UI/pages/add_edit_alarm/controller/add_edit_alarm_controller.dart';
import '../UI/pages/add_edit_alarm/view/add_edit_alarm_view.dart';
import '../UI/pages/settings/view/settings_view.dart';
import '../constants/core_constants.dart';
import '../repositories/alarms_repository.dart';

class AppRouter {
  static final AppRouter _appRouter = AppRouter._internal();

  factory AppRouter() {
    return _appRouter;
  }

  AppRouter._internal();

  static final Widget addAlarmPage = AddEditAlarmView(
    isAddAlarm: true,
    addEditAlarmController: AddEditAlarmController(
      alarmsRepository: AlarmsRepository(),
    ),
  );

  static final Widget editAlarmPage = AddEditAlarmView(
    isAddAlarm: false,
    addEditAlarmController: AddEditAlarmController(
      alarmsRepository: AlarmsRepository(),
    ),
  );

  static final Widget settingsPage = SettingsView(
    settingsController: CoreConstants.settingsController,
  );

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
