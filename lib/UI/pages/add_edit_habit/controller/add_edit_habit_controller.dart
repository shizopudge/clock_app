import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/add_edit_habit/add_edit_habit_cubit.dart';
import '../../../../core/utils.dart';
import '../../../../repositories/habits_repository.dart';

abstract class IAddEditHabitController {
  void reset(BuildContext context);

  void onSave(
    BuildContext context, {
    String? id,
    required bool isAddHabit,
    required String name,
    String? description,
    required int interval,
  });

  void onSaveComplete(BuildContext context,
      {required bool isCreated, required int interval});
}

class AddEditHabitController extends IAddEditHabitController {
  final HabitsRepository _habitsRepository;

  AddEditHabitController({required HabitsRepository habitsRepository})
      : _habitsRepository = habitsRepository;

  @override
  void reset(BuildContext context) => context.read<AddEditHabitCubit>().reset();

  @override
  void onSave(
    BuildContext context, {
    String? id,
    required bool isAddHabit,
    required String name,
    String? description,
    required int interval,
  }) {
    if (isAddHabit) {
      _habitsRepository
          .createHabit(
            name: name,
            description: description,
            interval: interval,
          )
          .whenComplete(() =>
              onSaveComplete(context, isCreated: true, interval: interval));
    } else {
      _habitsRepository
          .updateHabit(
            id: id ?? '',
            name: name,
            description: description,
            interval: interval,
          )
          .whenComplete(() =>
              onSaveComplete(context, isCreated: false, interval: interval));
    }
  }

  @override
  void onSaveComplete(BuildContext context,
      {required bool isCreated, required int interval}) {
    AppUtils.showSnackBar(
      context,
      isCreated
          ? 'Habit successfully created, frequency: ${AppUtils.formatInterval(interval)}'
          : 'Habit successfully updated, frequency: ${AppUtils.formatInterval(interval)}',
    );
    Navigator.pop(context);
  }
}
