import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/habits_repository.dart';
import '../widgets/habit_appbar.dart';

abstract class IHabitController {
  void init(BuildContext context, ScrollController scrollController);

  void onScroll(BuildContext context, ScrollController scrollController);
}

class HabitController extends IHabitController {
  final HabitsRepository _habitsRepository;

  HabitController({required HabitsRepository habitsRepository})
      : _habitsRepository = habitsRepository;

  @override
  void init(BuildContext context, ScrollController scrollController) {
    scrollController.addListener(
      () => onScroll(context, scrollController),
    );
  }

  @override
  void onScroll(BuildContext context, ScrollController scrollController) {
    if (scrollController.offset > 55) {
      context.read<HabitAppBarCubit>().collapse();
    } else {
      context.read<HabitAppBarCubit>().expand();
    }
  }
}
