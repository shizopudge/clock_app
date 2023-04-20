import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rate_limiter/rate_limiter.dart';

import '../../../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../../bloc/alarms_timer/alarm_timer_cubit.dart';
import '../../../../core/enums.dart';
import '../../../../core/router.dart';
import '../../../../core/utils.dart';
import '../../../../models/alarm/alarm.dart';
import '../../../../repositories/alarms_repository.dart';
import '../../../../services/alarm_services.dart';
import '../widgets/alarm_appbar.dart';

abstract class IAlarmController {
  void init(BuildContext context, Box<Alarm> alarmsBox,
      ScrollController scrollController);

  void onScroll(BuildContext context, ScrollController scrollController);

  void startTimer(BuildContext context);

  void onAlarmsChange(BuildContext context);

  void onChanged(
    BuildContext context, {
    required int editAlarmsLength,
    required List<Alarm> shownAlarms,
  });

  void goToAddAlarm(
    BuildContext context, {
    required List<Alarm> alarms,
  });

  List<Alarm> sortAndFilterAlarms(
      {required Box<Alarm> alarmsBox,
      required SortType sort,
      required FilterType filter});

  void onAddOneAlarm(BuildContext context, Alarm alarm);

  void goToEditAlarm(BuildContext context, Alarm alarm);

  void enableAlarm(String alarmId);
}

class AlarmController extends IAlarmController {
  final AlarmsRepository _alarmsRepository;

  AlarmController({required AlarmsRepository alarmsRepository})
      : _alarmsRepository = alarmsRepository;

  final Debounce scheduleNotifications = debounce(
    () async {
      final List<Alarm> launchedAlarms = AlarmsRepository().getEnabledAlarms();
      await AlarmServices().scheduleAlarms(launchedAlarms);
    },
    const Duration(
      milliseconds: 1000,
    ),
  );

  @override
  void init(BuildContext context, Box<Alarm> alarmsBox,
      ScrollController scrollController) {
    startTimer(context);
    alarmsBox.listenable().addListener(() => onAlarmsChange(context));
    scrollController.addListener(() => onScroll(context, scrollController));
  }

  @override
  void onScroll(BuildContext context, ScrollController scrollController) {
    if (scrollController.offset > 55) {
      context.read<AlarmAppBarCubit>().collapse();
    } else {
      context.read<AlarmAppBarCubit>().expand();
    }
  }

  @override
  void startTimer(BuildContext context) =>
      context.read<AlarmTimerCubit>().startAlarmTimer();

  @override
  void onAlarmsChange(BuildContext context) {
    startTimer(context);
    scheduleNotifications();
  }

  @override
  void onChanged(
    BuildContext context, {
    required int editAlarmsLength,
    required List<Alarm> shownAlarms,
  }) {
    if (editAlarmsLength == shownAlarms.length) {
      context.read<AlarmViewCubit>().clearAlarms();
    } else {
      context.read<AlarmViewCubit>().setAllAlarms(shownAlarms);
    }
  }

  @override
  void goToAddAlarm(
    BuildContext context, {
    required List<Alarm> alarms,
  }) {
    if (alarms.length == 100) {
      AppUtils.showSnackBar(context, 'You cannot create more than 100 alarms.');
    } else {
      AppRouter.navigateWithSlideTransition(context, AppRouter.addAlarmPage);
    }
  }

  @override
  List<Alarm> sortAndFilterAlarms(
      {required Box<Alarm> alarmsBox,
      required SortType sort,
      required FilterType filter}) {
    List<Alarm> alarms;
    if (sort == SortType.ascending) {
      alarms = alarmsBox.values.toList()
        ..sort(
          (a, b) => a.time.compareTo(b.time),
        );
    } else {
      alarms = alarmsBox.values.toList()
        ..sort(
          (a, b) => b.time.compareTo(a.time),
        );
    }
    if (filter == FilterType.onlyEnabled) {
      alarms = alarms.where((alarm) => alarm.isEnabled).toList();
    }
    if (filter == FilterType.onlyDisabled) {
      alarms = alarms.where((alarm) => !alarm.isEnabled).toList();
    }
    return alarms;
  }

  @override
  void onAddOneAlarm(BuildContext context, Alarm alarm) =>
      context.read<AlarmViewCubit>().addOneAlarm(alarm);

  @override
  void goToEditAlarm(BuildContext context, Alarm alarm) {
    context.read<AddEditAlarmCubit>().setId(alarm.id);
    context.read<AddEditAlarmCubit>().setName(alarm.name ?? '');
    context.read<AddEditAlarmCubit>().setDays(alarm.weekdays);
    context.read<AddEditAlarmCubit>().setHour(alarm.time.hour);
    context.read<AddEditAlarmCubit>().setMinute(alarm.time.minute);
    AppRouter.navigateWithSlideTransition(context, AppRouter.editAlarmPage);
  }

  @override
  void enableAlarm(String alarmId) {
    _alarmsRepository.enableAlarm(alarmId);
  }
}
