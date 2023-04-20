import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../constants/ui_constants.dart';
import '../../../../models/habit/habit.dart';
import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
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
    return ValueListenableBuilder(
      valueListenable: habitsBox.listenable(),
      builder: (context, box, widget) {
        List<Habit> habits = box.values.toList();
        return NestedScrollView(
          key: UIConstants.habitsNestedScrollViewKey,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            HabitAppBar(height: height, habits: habits, shownHabits: habits)
          ],
          controller: _scrollController,
          body: habits.isEmpty
              ? Center(
                  child: Text(
                    'No habits',
                    style: AppFonts.headerStyle,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Scrollbar(
                    controller: UIConstants.habitsNestedScrollViewKey
                        .currentState?.innerController,
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
                            child: Text(
                              habit.toString(),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            habit.toString(),
                          ),
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
