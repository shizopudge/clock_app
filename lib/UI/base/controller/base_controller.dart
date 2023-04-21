import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../bloc/habit_view/habit_view_cubit.dart';
import '../../../core/ui_utils.dart';
import '../../../core/enums.dart';
import '../../../core/utils.dart';
import '../../../models/alarm/alarm.dart';
import '../../../models/habit/habit.dart';
import '../../../repositories/alarms_repository.dart';
import '../../../repositories/habits_repository.dart';
import '../../common/exit_dialog.dart';
import '../view/base.dart';

abstract class IBaseController {
  void goBackToDefaultMode(BuildContext context, bool isAlarm);

  void onPageChange(BuildContext context,
      {required int page, required int currentPage});

  void onTapInEditAlarmsMode(
      BuildContext context, int index, AlarmViewCubitState alarmViewState);

  void onTapInEditHabitsMode(
      BuildContext context, int index, HabitViewCubitState habitViewState);

  void onDeleteAlarms(List<Alarm> alarms, BuildContext context);

  void onSwitchAlarms(List<Alarm> alarms, BuildContext context);

  void onDeleteHabits(List<Habit> habits, BuildContext context);

  void onSwitchHabits(List<Habit> habits, BuildContext context);

  void scrollToTop(BuildContext context, int currentPage);

  Future<bool> onWillPop(BuildContext context);
}

class BaseController extends IBaseController {
  final AlarmsRepository _alarmsRepository;
  final HabitsRepository _habitsRepository;
  BaseController(
      {required AlarmsRepository alarmsRepository,
      required HabitsRepository habitsRepository})
      : _alarmsRepository = alarmsRepository,
        _habitsRepository = habitsRepository;

  @override
  void goBackToDefaultMode(BuildContext context, bool isAlarm) {
    if (isAlarm) {
      context.read<AlarmViewCubit>().toggleEditMode();
      context.read<AlarmViewCubit>().clearAlarms();
      context.read<AlarmViewCubit>().setFilterType(FilterType.none);
    } else {
      context.read<HabitViewCubit>().toggleEditMode();
      context.read<HabitViewCubit>().clearHabits();
      context.read<HabitViewCubit>().setFilterType(FilterType.none);
    }
  }

  @override
  void onPageChange(BuildContext context,
      {required int page, required int currentPage}) {
    context.read<PageCubit>().changePage(page);
    if (currentPage == 0) {
      UIUtils.alarmsNestedScrollViewKey.currentState?.outerController.jumpTo(0);
    } else if (currentPage == 1) {
      UIUtils.habitsNestedScrollViewKey.currentState?.outerController.jumpTo(0);
    }
  }

  @override
  void onTapInEditAlarmsMode(
      BuildContext context, int index, AlarmViewCubitState alarmViewState) {
    if (index == 0) {
      goBackToDefaultMode(context, true);
    } else if (index == 1) {
      if (alarmViewState.currentlyChangingAlarms.isNotEmpty) {
        onSwitchAlarms(alarmViewState.currentlyChangingAlarms, context);
      }
    } else if (index == 2) {
      if (alarmViewState.currentlyChangingAlarms.isNotEmpty) {
        onDeleteAlarms(alarmViewState.currentlyChangingAlarms, context);
      }
    }
  }

  @override
  void onTapInEditHabitsMode(
      BuildContext context, int index, HabitViewCubitState habitViewState) {
    if (index == 0) {
      goBackToDefaultMode(context, false);
    } else if (index == 1) {
      if (habitViewState.currentlyChangingHabits.isNotEmpty) {
        onSwitchHabits(habitViewState.currentlyChangingHabits, context);
      }
    } else if (index == 2) {
      if (habitViewState.currentlyChangingHabits.isNotEmpty) {
        onDeleteHabits(habitViewState.currentlyChangingHabits, context);
      }
    }
  }

  @override
  void onDeleteAlarms(List<Alarm> alarms, BuildContext context) {
    if (alarms.length > 1) {
      List<String> ids = [];
      for (Alarm alarm in alarms) {
        ids.add(alarm.id);
      }
      _alarmsRepository.deleteAlarms(ids);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context, true);
    } else if (alarms.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _alarmsRepository.deleteAlarm(alarms.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context, true);
    }
  }

  @override
  void onSwitchAlarms(List<Alarm> alarms, BuildContext context) {
    if (alarms.length > 1) {
      List<String> ids = [];
      for (Alarm alarm in alarms) {
        ids.add(alarm.id);
      }
      _alarmsRepository.enableAlarms(ids);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context, true);
    } else if (alarms.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _alarmsRepository.enableAlarm(alarms.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context, true);
    }
  }

  @override
  void onDeleteHabits(List<Habit> habits, BuildContext context) {
    if (habits.length > 1) {
      List<String> ids = [];
      for (Habit habit in habits) {
        ids.add(habit.id);
      }
      _habitsRepository.deleteHabits(ids);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context, false);
    } else if (habits.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _habitsRepository.deleteHabit(habits.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context, false);
    }
  }

  @override
  void onSwitchHabits(List<Habit> habits, BuildContext context) {
    if (habits.length > 1) {
      List<String> ids = [];
      for (Habit habit in habits) {
        ids.add(habit.id);
      }
      _habitsRepository.enableHabits(ids);
      context.read<HabitViewCubit>().clearHabits();
      goBackToDefaultMode(context, false);
    } else if (habits.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _habitsRepository.enableHabit(habits.first.id);
      context.read<HabitViewCubit>().clearHabits();
      goBackToDefaultMode(context, false);
    }
  }

  @override
  void scrollToTop(BuildContext context, int currentPage) {
    if (currentPage == 0) {
      UIUtils.alarmsNestedScrollViewKey.currentState?.outerController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    } else if (currentPage == 1) {
      UIUtils.habitsNestedScrollViewKey.currentState?.outerController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    }
  }

  @override
  Future<bool> onWillPop(BuildContext context) async {
    final bool isEditMode = context.read<AlarmViewCubit>().state.isEditMode;
    if (isEditMode) {
      context.read<AlarmViewCubit>().toggleEditMode();
      return false;
    } else {
      return await showDialog(
            context: context,
            builder: (context) => const ExitDialog(),
          ) ??
          false;
    }
  }
}
