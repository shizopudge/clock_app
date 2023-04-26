import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/habit_view/habit_view_cubit.dart';
import '../../../../models/habit/habit.dart';
import '../../../../theme/fonts.dart';
import '../../../common/menu_popup.dart';
import '../../../common/filter_popup.dart';
import '../controller/habit_controller.dart';

class HabitAppBarCubit extends Cubit<bool> {
  HabitAppBarCubit() : super(false);

  void collapse() => emit(true);

  void expand() => emit(false);
}

class HabitAppBar extends StatelessWidget {
  final double height;
  final List<Habit> habits;
  final List<Habit> shownHabits;
  final HabitController _habitController;
  const HabitAppBar({
    super.key,
    required this.height,
    required this.habits,
    required this.shownHabits,
    required HabitController habitController,
  }) : _habitController = habitController;

  @override
  Widget build(BuildContext context) {
    final bool isCollapsed = context.watch<HabitAppBarCubit>().state;
    final HabitViewCubitState habitViewState =
        context.watch<HabitViewCubit>().state;
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverSafeArea(
        top: false,
        bottom: false,
        sliver: SliverAppBar(
          elevation: 0,
          floating: true,
          pinned: true,
          backgroundColor: Colors.transparent,
          expandedHeight: habitViewState.isEditMode ? 150 : 0,
          bottom: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              50,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: habitViewState.isEditMode
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: habitViewState
                                        .currentlyChangingHabits.length ==
                                    shownHabits.length,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                                onChanged: (value) =>
                                    _habitController.onChanged(
                                      context,
                                      editHabitsLength: habitViewState
                                          .currentlyChangingHabits.length,
                                      shownHabits: shownHabits,
                                    )),
                            Text(
                              'All',
                              style: AppFonts.labelStyle,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(
                                milliseconds: 1000,
                              ),
                              opacity: isCollapsed ? 1 : 0,
                              child: Text(
                                'Selected: ${habitViewState.currentlyChangingHabits.length}',
                                style: AppFonts.labelStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const FilterPopup(
                              isAlarm: false,
                            ),
                            MenuPopup(
                              isListEmpty: habits.isEmpty,
                              isAlarm: false,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Habits',
                          style: AppFonts.titleStyle,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _habitController
                                  .goToAddHabit(context, habits: habits),
                              icon: const Icon(
                                Icons.add_alert_rounded,
                                size: 32,
                              ),
                            ),
                            if (habits.isNotEmpty)
                              const FilterPopup(
                                isAlarm: false,
                              ),
                            MenuPopup(
                              isListEmpty: habits.isEmpty,
                              isAlarm: false,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Center(
              child: AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 600,
                ),
                opacity: isCollapsed ? 0 : 1,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: habitViewState.isEditMode
                      ? Text(
                          'Selected: ${habitViewState.currentlyChangingHabits.length}',
                          style: AppFonts.headerStyle,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            expandedTitleScale: 1,
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}
