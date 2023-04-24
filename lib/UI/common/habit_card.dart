import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/habit_view/habit_view_cubit.dart';
import '../../core/utils.dart';
import '../../models/habit/habit.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';
import '../pages/habit/controller/habit_controller.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final HabitController _habitController;
  const HabitCard(
      {super.key,
      required this.habit,
      required HabitController habitController})
      : _habitController = habitController;

  void _onLongPress(BuildContext context) {
    context.read<HabitViewCubit>().toggleEditMode();
    _habitController.onAddOneHabit(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    final HabitViewCubitState habitViewState =
        context.watch<HabitViewCubit>().state;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onLongPress: () {
          if (!habitViewState.isEditMode) {
            _onLongPress(context);
          }
        },
        onTap: () {
          if (habitViewState.isEditMode) {
            _habitController.onAddOneHabit(context, habit);
          } else {
            _habitController.goToEditHabit(context, habit);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: habitViewState.isEditMode
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (habitViewState.isEditMode)
                          Checkbox(
                            value: habitViewState.currentlyChangingHabits
                                .contains(habit),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            onChanged: (value) =>
                                _habitController.onAddOneHabit(context, habit),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                habit.name,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppFonts.labelStyle.copyWith(fontSize: 16),
                              ),
                              if (habit.description != null)
                                Text(
                                  habit.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppFonts.labelStyle
                                      .copyWith(fontSize: 12),
                                ),
                              RichText(
                                text: TextSpan(
                                  text: 'Every ',
                                  style:
                                      AppFonts.timeStyle.copyWith(fontSize: 24),
                                  children: [
                                    TextSpan(
                                      text: AppUtils.formatInterval(
                                        habit.interval,
                                      ),
                                      style: AppFonts.timeStyle
                                          .copyWith(fontSize: 48),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          inactiveTrackColor: Colors.grey.shade700,
                          inactiveThumbColor: Colors.grey,
                          value: habit.isEnabled,
                          onChanged: (isLaunched) =>
                              _habitController.enableHabit(habit.id),
                          activeColor: Pallete.actionColor,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            habit.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.labelStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          if (habit.description != null)
                            Text(
                              habit.description ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.labelStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          RichText(
                            text: TextSpan(
                              text: 'Every ',
                              style: AppFonts.timeStyle.copyWith(fontSize: 32),
                              children: [
                                TextSpan(
                                  text: AppUtils.formatInterval(
                                    habit.interval,
                                  ),
                                  style:
                                      AppFonts.timeStyle.copyWith(fontSize: 48),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Switch.adaptive(
                          inactiveTrackColor: Colors.grey.shade700,
                          inactiveThumbColor: Colors.grey,
                          value: habit.isEnabled,
                          onChanged: (isLaunched) =>
                              _habitController.enableHabit(habit.id),
                          activeColor: Pallete.actionColor,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
