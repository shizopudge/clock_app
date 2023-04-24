import 'package:flutter/material.dart';

import '../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../bloc/habit_view/habit_view_cubit.dart';
import '../../core/ui_utils.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';
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
    if (alarmViewState.isEditMode) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            enableFeedback: false,
            unselectedLabelStyle: AppFonts.labelStyle,
            selectedLabelStyle: AppFonts.labelStyle,
            selectedItemColor: Pallete.actionColor,
            unselectedItemColor: Pallete.actionColor,
            onTap: (index) => _baseController.onTapInEditAlarmsMode(
                context, index, alarmViewState),
            items: const [
              BottomNavigationBarItem(
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
                ),
                label: 'Switch on/off',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 24,
                ),
                label: 'Delete',
              ),
            ],
          ),
        ),
      );
    } else if (habitViewState.isEditMode) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            enableFeedback: false,
            unselectedLabelStyle: AppFonts.labelStyle,
            selectedLabelStyle: AppFonts.labelStyle,
            selectedItemColor: Pallete.actionColor,
            unselectedItemColor: Pallete.actionColor,
            onTap: (index) => _baseController.onTapInEditHabitsMode(
                context, index, habitViewState),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                label: 'Go back',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                  size: 24,
                ),
                label: 'Switch on/off',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 24,
                ),
                label: 'Delete',
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            onTap: (page) => _baseController.onPageChange(
              context,
              page: page,
              currentPage: currentPage,
            ),
            currentIndex: currentPage,
            items: UIUtils.bottomBarItems,
          ),
        ),
      );
    }
  }
}
