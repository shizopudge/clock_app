import 'package:flutter_bloc/flutter_bloc.dart';

import '../UI/base.dart';
import '../UI/common/clock.dart';
import '../UI/pages/alarm/widgets/alarm_appbar.dart';
import '../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../bloc/alarm_view/alarm_view_cubit.dart';
import '../bloc/alarms_timer/alarm_timer_cubit.dart';
import '../repositories/alarms_repository.dart';

class AppProviders {
  static final cubits = <dynamic>[
    BlocProvider(
      create: (_) => ClockCubit()..startClock(),
    ),
    BlocProvider(
      create: (_) => AlarmTimerCubit(
        alarmsRepository: AlarmsRepository(),
      ),
    ),
    BlocProvider(
      create: (_) => AlarmViewCubit(),
    ),
    BlocProvider(
      create: (_) => PageCubit(),
    ),
    BlocProvider(
      create: (_) => AlarmViewCubit(),
    ),
    BlocProvider(
      create: (_) => AlarmAppBarCubit(),
    ),
    BlocProvider(
      create: (_) => AddEditAlarmCubit(),
    ),
  ];
}
