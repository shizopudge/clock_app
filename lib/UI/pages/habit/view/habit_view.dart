import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../bloc/habit_view/habit_view_cubit.dart';
import '../../../../core/ui_utils.dart';
import '../../../../core/enums.dart';
import '../../../../models/habit/habit.dart';
import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
import '../../../common/habit_card.dart';
import '../controller/habit_controller.dart';
import '../widgets/habit_appbar.dart';

class HabitView extends StatefulWidget {
  final HabitController _habitController;
  const HabitView({super.key, required HabitController habitController})
      : _habitController = habitController;

  @override
  State<HabitView> createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
  static final ScrollController _scrollController = ScrollController();
  final Box<Habit> habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);

  @override
  void initState() {
    super.initState();
    widget._habitController.init(context, _scrollController);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final SortType sort = context.watch<HabitViewCubit>().state.sort;
    final FilterType filter = context.watch<HabitViewCubit>().state.filter;
    return ValueListenableBuilder(
      valueListenable: habitsBox.listenable(),
      builder: (context, box, _) {
        List<Habit> habits = widget._habitController
            .sortAndFilterHabits(habitsBox: box, sort: sort, filter: filter);
        return NestedScrollView(
          key: UIUtils.habitsNestedScrollViewKey,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            HabitAppBar(
              height: height,
              habits: habitsBox.values.toList(),
              shownHabits: habits,
              habitController: widget._habitController,
            ),
          ],
          controller: _scrollController,
          body: habits.isEmpty
              ? Center(
                  child: Text(
                    filter == FilterType.onlyEnabled
                        ? 'No enabled habits'
                        : filter == FilterType.onlyDisabled
                            ? 'No disabled habits'
                            : 'No habits',
                    style: AppFonts.headerStyle,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Scrollbar(
                    controller: UIUtils.habitsNestedScrollViewKey.currentState
                        ?.innerController,
                    thickness: 2.5,
                    thumbVisibility: false,
                    interactive: true,
                    radius: const Radius.circular(12),
                    child: ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final Habit habit = habits[index];
                        if (index == habits.length - 1) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: HabitCard(
                              habit: habit,
                              habitController: widget._habitController,
                            ),
                          );
                        }
                        return HabitCard(
                          habit: habit,
                          habitController: widget._habitController,
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }
}
