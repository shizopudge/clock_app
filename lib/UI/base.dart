import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/alarm_view/alarm_view_cubit.dart';
import '../constants/ui_constants.dart';
import '../core/utils.dart';
import '../models/alarm.dart';
import '../repositories/alarms_repository.dart';
import '../theme/pallete.dart';
import 'common/exit_dialog.dart';
import 'pages/alarm/widgets/alarm_appbar.dart';

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  void changePage(int page) => emit(page);
}

class Base extends StatelessWidget {
  final AlarmsRepository _alarmsRepository;
  const Base({
    super.key,
    required AlarmsRepository alarmsRepository,
  }) : _alarmsRepository = alarmsRepository;

  static void _goBackToDefaultMode(BuildContext context) {
    context.read<AlarmViewCubit>().toggleEditMode();
    context.read<AlarmViewCubit>().clearAlarms();
    context.read<AlarmViewCubit>().setFilterType(FilterType.none);
  }

  static void _onPageChange(int page, BuildContext context) =>
      context.read<PageCubit>().changePage(page);

  void _onTapInEditMode(
      BuildContext context, int index, AlarmViewCubitState alarmViewState) {
    if (index == 0) {
      _goBackToDefaultMode(context);
    } else if (index == 1) {
      if (alarmViewState.currentlyChangingAlarms.isNotEmpty) {
        _onSwitchAlarm(alarmViewState.currentlyChangingAlarms, context);
      }
    } else if (index == 2) {
      if (alarmViewState.currentlyChangingAlarms.isNotEmpty) {
        _onDelete(alarmViewState.currentlyChangingAlarms, context);
      }
    }
  }

  void _onDelete(List<AlarmModel> alarms, BuildContext context) {
    if (alarms.length > 1) {
      List<String> ids = [];
      for (AlarmModel alarm in alarms) {
        ids.add(alarm.id);
      }
      _alarmsRepository.deleteAlarms(ids);
      context.read<AlarmViewCubit>().clearAlarms();
      _goBackToDefaultMode(context);
    } else if (alarms.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _alarmsRepository.deleteAlarm(alarms.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      _goBackToDefaultMode(context);
    }
  }

  void _onSwitchAlarm(List<AlarmModel> alarms, BuildContext context) {
    if (alarms.length > 1) {
      _alarmsRepository.launchAlarms(alarms);
      context.read<AlarmViewCubit>().clearAlarms();
      _goBackToDefaultMode(context);
    } else if (alarms.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _alarmsRepository.launchAlarm(alarms.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      _goBackToDefaultMode(context);
    }
  }

  static void _scrollToTop(BuildContext context) =>
      UIConstants.nestedScrollViewKey.currentState?.outerController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );

  static Future<bool> _onWillPop(BuildContext context) async {
    final bool isEditMode = context.read<AlarmViewCubit>().state.isEditMode;
    if (isEditMode) {
      context.read<AlarmViewCubit>().toggleEditMode();
      return false;
    } else {
      return await showDialog(
            context: context,
            builder: (context) => const ExitDialog(),
          ) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.watch<PageCubit>().state;
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
    final bool isCollapsed = context.watch<AlarmAppBarCubit>().state;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: IndexedStack(
          index: currentPage,
          children: UIConstants.pages,
        ),
        extendBody: true,
        floatingActionButton: isCollapsed
            ? IconButton(
                onPressed: () => _scrollToTop(context),
                icon: const Icon(
                  Icons.arrow_circle_up_rounded,
                  size: 28,
                  color: Pallete.whiteColor,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: alarmViewState.isEditMode
            ? Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
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
                    onTap: (index) =>
                        _onTapInEditMode(context, index, alarmViewState),
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
                  ),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: BottomNavigationBar(
                    onTap: (page) => _onPageChange(page, context),
                    currentIndex: currentPage,
                    items: UIConstants.bottomBarItems,
                  ),
                ),
              ),
      ),
    );
  }
}
