import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../constants/ui_constants.dart';
import '../../../core/enums.dart';
import '../../../core/utils.dart';
import '../../../models/alarm/alarm.dart';
import '../../../repositories/alarms_repository.dart';
import '../../common/exit_dialog.dart';
import '../view/base.dart';

abstract class IBaseController {
  void goBackToDefaultMode(BuildContext context);

  void onPageChange(BuildContext context,
      {required int page, required int currentPage});

  void onTapInEditMode(
      BuildContext context, int index, AlarmViewCubitState alarmViewState);

  void onDelete(List<Alarm> alarms, BuildContext context);

  void onSwitch(List<Alarm> alarms, BuildContext context);

  void scrollToTop(BuildContext context, int currentPage);

  Future<bool> onWillPop(BuildContext context);
}

class BaseController extends IBaseController {
  final AlarmsRepository _alarmsRepository;
  BaseController({
    required AlarmsRepository alarmsRepository,
  }) : _alarmsRepository = alarmsRepository;

  @override
  void goBackToDefaultMode(BuildContext context) {
    context.read<AlarmViewCubit>().toggleEditMode();
    context.read<AlarmViewCubit>().clearAlarms();
    context.read<AlarmViewCubit>().setFilterType(FilterType.none);
  }

  @override
  void onPageChange(BuildContext context,
      {required int page, required int currentPage}) {
    context.read<PageCubit>().changePage(page);
    if (currentPage == 0) {
      UIConstants.alarmsNestedScrollViewKey.currentState?.outerController
          .jumpTo(0);
    } else if (currentPage == 1) {
      UIConstants.habitsNestedScrollViewKey.currentState?.outerController
          .jumpTo(0);
    }
  }

  @override
  void onTapInEditMode(
      BuildContext context, int index, AlarmViewCubitState alarmViewState) {
    if (index == 0) {
      goBackToDefaultMode(context);
    } else if (index == 1) {
      if (alarmViewState.currentlyChangingAlarms.isNotEmpty) {
        onSwitch(alarmViewState.currentlyChangingAlarms, context);
      }
    } else if (index == 2) {
      if (alarmViewState.currentlyChangingAlarms.isNotEmpty) {
        onDelete(alarmViewState.currentlyChangingAlarms, context);
      }
    }
  }

  @override
  void onDelete(List<Alarm> alarms, BuildContext context) {
    if (alarms.length > 1) {
      List<String> ids = [];
      for (Alarm alarm in alarms) {
        ids.add(alarm.id);
      }
      _alarmsRepository.deleteAlarms(ids);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context);
    } else if (alarms.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _alarmsRepository.deleteAlarm(alarms.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context);
    }
  }

  @override
  void onSwitch(List<Alarm> alarms, BuildContext context) {
    if (alarms.length > 1) {
      List<String> ids = [];
      for (Alarm alarm in alarms) {
        ids.add(alarm.id);
      }
      _alarmsRepository.enableAlarms(ids);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context);
    } else if (alarms.isEmpty) {
      AppUtils.showSnackBar(context, 'No alarms selected');
    } else {
      _alarmsRepository.enableAlarm(alarms.first.id);
      context.read<AlarmViewCubit>().clearAlarms();
      goBackToDefaultMode(context);
    }
  }

  @override
  void scrollToTop(BuildContext context, int currentPage) {
    if (currentPage == 0) {
      UIConstants.alarmsNestedScrollViewKey.currentState?.outerController
          .animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    } else if (currentPage == 1) {
      UIConstants.habitsNestedScrollViewKey.currentState?.outerController
          .animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    }
  }

  @override
  Future<bool> onWillPop(BuildContext context) async {
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
}
