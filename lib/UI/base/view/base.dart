import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../bloc/habit_view/habit_view_cubit.dart';
import '../../../core/ui_utils.dart';
import '../../../theme/pallete.dart';
import '../../../theme/theme.dart';
import '../../common/bottom_nav_bar.dart';
import '../../pages/alarm/widgets/alarm_appbar.dart';
import '../../pages/habits/widgets/habit_appbar.dart';
import '../controller/base_controller.dart';

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  void changePage(int page) => emit(page);
}

class Base extends StatelessWidget {
  final BaseController _baseController;
  final String theme;
  const Base({
    super.key,
    required BaseController baseController,
    required this.theme,
  }) : _baseController = baseController;

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.watch<PageCubit>().state;
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
    final HabitViewCubitState habitViewState =
        context.watch<HabitViewCubit>().state;
    final bool isAlarmAppBarCollapsed = context.watch<AlarmAppBarCubit>().state;
    final bool isHabitAppBarCollapsed = context.watch<HabitAppBarCubit>().state;
    return WillPopScope(
      onWillPop: () => _baseController.onWillPop(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: theme == AppTheme.lightThemeName
                ? PalleteLight.backgroundGradient
                : null,
          ),
          child: IndexedStack(
            index: currentPage,
            children: UIUtils.pages,
          ),
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        floatingActionButton: isAlarmAppBarCollapsed || isHabitAppBarCollapsed
            ? IconButton(
                onPressed: () =>
                    _baseController.scrollToTop(context, currentPage),
                icon: const Icon(
                  Icons.arrow_circle_up_rounded,
                  size: 32,
                  color: PalleteLight.actionColor,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomNavBar(
          alarmViewState: alarmViewState,
          habitViewState: habitViewState,
          baseController: _baseController,
          currentPage: currentPage,
        ),
      ),
    );
  }
}
