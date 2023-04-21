import 'package:flutter_bloc/flutter_bloc.dart';

import '../UI/base/view/base.dart';
import '../UI/common/clock.dart';
import '../UI/pages/alarm/widgets/alarm_appbar.dart';
import '../UI/pages/habits/widgets/habit_appbar.dart';
import '../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../bloc/add_edit_habit/add_edit_habit_cubit.dart';
import '../bloc/alarm_view/alarm_view_cubit.dart';
import '../bloc/alarms_timer/alarm_timer_cubit.dart';
import '../bloc/habit_view/habit_view_cubit.dart';
import '../repositories/alarms_repository.dart';

class AppProviders {
  static final defaultProviders = <dynamic>[
    BlocProvider(
      create: (_) => ClockCubit()..startClock(),
    ),
    BlocProvider(
      create: (_) => PageCubit(),
    ),
  ];

  static final alarmProviders = <dynamic>[
    BlocProvider(
      create: (_) => AlarmTimerCubit(
        alarmsRepository: AlarmsRepository(),
      ),
    ),
    BlocProvider(
      create: (_) => AddEditAlarmCubit(),
    ),
    BlocProvider(
      create: (_) => AlarmAppBarCubit(),
    ),
    BlocProvider(
      create: (_) => AlarmViewCubit(),
    ),
  ];

  static final habitProviders = <dynamic>[
    BlocProvider(
      create: (_) => HabitViewCubit(),
    ),
    BlocProvider(
      create: (_) => AddEditHabitCubit(),
    ),
    BlocProvider(
      create: (_) => HabitAppBarCubit(),
    ),
  ];
}
