import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../bloc/add_edit_habit/add_edit_habit_cubit.dart';
import '../../../../bloc/habit_view/habit_view_cubit.dart';
import '../../../../core/enums.dart';
import '../../../../core/router.dart';
import '../../../../core/ui_utils.dart';
import '../../../../core/utils.dart';
import '../../../../models/habit/habit.dart';
import '../../../../repositories/habits_repository.dart';
import '../widgets/habit_appbar.dart';

abstract class IHabitController {
  void init(BuildContext context, ScrollController scrollController);

  void onScroll(BuildContext context, ScrollController scrollController);

  void onChanged(
    BuildContext context, {
    required int editHabitsLength,
    required List<Habit> shownHabits,
  });

  void goToAddHabit(
    BuildContext context, {
    required List<Habit> habits,
  });

  List<Habit> sortAndFilterHabits(
      {required Box<Habit> habitsBox,
      required SortType sort,
      required FilterType filter});

  void onAddOneHabit(BuildContext context, Habit habit);

  void goToEditHabit(BuildContext context, Habit habit);

  void enableHabit(String habitId);
}

class HabitController extends IHabitController {
  final HabitsRepository _habitsRepository;

  HabitController({required HabitsRepository habitsRepository})
      : _habitsRepository = habitsRepository;

  @override
  void init(BuildContext context, ScrollController scrollController) {
    UIUtils.habitsNestedScrollViewKey.currentState?.outerController.animateTo(
      500,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );
    scrollController.addListener(
      () => onScroll(context, scrollController),
    );
  }

  @override
  void onScroll(BuildContext context, ScrollController scrollController) {
    if (scrollController.offset > 200) {
      context.read<HabitAppBarCubit>().collapse();
    } else {
      context.read<HabitAppBarCubit>().expand();
    }
  }

  @override
  void onChanged(
    BuildContext context, {
    required int editHabitsLength,
    required List<Habit> shownHabits,
  }) {
    if (editHabitsLength == shownHabits.length) {
      context.read<HabitViewCubit>().clearHabits();
    } else {
      context.read<HabitViewCubit>().setAllHabits(shownHabits);
    }
  }

  @override
  void goToAddHabit(
    BuildContext context, {
    required List<Habit> habits,
  }) {
    if (habits.length == 100) {
      AppUtils.showSnackBar(context, 'You cannot create more than 100 habits.');
    } else {
      AppRouter.navigateWithSlideTransition(context, AppRouter.addHabitPage);
    }
  }

  @override
  List<Habit> sortAndFilterHabits(
      {required Box<Habit> habitsBox,
      required SortType sort,
      required FilterType filter}) {
    List<Habit> habits;
    if (sort == SortType.ascending) {
      habits = habitsBox.values.toList()
        ..sort(
          (a, b) => a.name.compareTo(b.name),
        );
    } else {
      habits = habitsBox.values.toList()
        ..sort(
          (a, b) => b.name.compareTo(a.name),
        );
    }
    if (filter == FilterType.onlyEnabled) {
      habits = habits.where((habit) => habit.isEnabled).toList();
    }
    if (filter == FilterType.onlyDisabled) {
      habits = habits.where((habit) => !habit.isEnabled).toList();
    }
    return habits;
  }

  @override
  void onAddOneHabit(BuildContext context, Habit habit) =>
      context.read<HabitViewCubit>().addOneHabit(habit);

  @override
  void goToEditHabit(BuildContext context, Habit habit) {
    context.read<AddEditHabitCubit>().setId(habit.id);
    context.read<AddEditHabitCubit>().setName(habit.name);
    context.read<AddEditHabitCubit>().setDescription(habit.description ?? '');
    context.read<AddEditHabitCubit>().setInterval(habit.interval);
    AppRouter.navigateWithSlideTransition(context, AppRouter.editHabitPage);
  }

  @override
  void enableHabit(String habitId) {
    _habitsRepository.enableHabit(habitId);
  }
}
