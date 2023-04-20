import 'package:flutter/material.dart';

import '../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../bloc/habit_view/habit_view_cubit.dart';
import '../../constants/ui_constants.dart';
import '../base/controller/base_controller.dart';

class BottomNavBar extends StatelessWidget {
  final int currentPage;
  final AlarmViewCubitState alarmViewState;
  final HabitViewCubitState habitViewState;
  final BaseController _baseController;
  const BottomNavBar({
    super.key,
    required this.alarmViewState,
    required this.habitViewState,
    required BaseController baseController,
    required this.currentPage,
  }) : _baseController = baseController;

  @override
  Widget build(BuildContext context) {
    if (alarmViewState.isEditMode || habitViewState.isEditMode) {
      return BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        enableFeedback: false,
        onTap: (index) =>
            _baseController.onTapInEditMode(context, index, alarmViewState),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            ),
            label: 'Go back',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.alarm_rounded,
              size: 24,
              color: alarmViewState.currentlyChangingAlarms.isEmpty
                  ? Colors.grey
                  : null,
            ),
            label: 'Switch on/off',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 24,
              color: alarmViewState.currentlyChangingAlarms.isEmpty
                  ? Colors.grey
                  : null,
            ),
            label: 'Delete',
          ),
        ],
      );
    } else {
      return BottomNavigationBar(
        onTap: (page) => _baseController.onPageChange(
          context,
          page: page,
          currentPage: currentPage,
        ),
        currentIndex: currentPage,
        items: UIConstants.bottomBarItems,
      );
    }
  }
}
