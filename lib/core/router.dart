import 'package:alarm_app/repositories/alarms_repository.dart';
import 'package:flutter/material.dart';

import '../UI/pages/add_alarm/view/add_edit_alarm_view.dart';

class AppRouter {
  static final AppRouter _appRouter = AppRouter._internal();

  factory AppRouter() {
    return _appRouter;
  }

  AppRouter._internal();

  static final Widget addAlarmPage = AddEditAlarmView(
    isAddAlarm: true,
    alarmsRepository: AlarmsRepository(),
  );

  static final Widget editAlarmPage = AddEditAlarmView(
    isAddAlarm: false,
    alarmsRepository: AlarmsRepository(),
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
