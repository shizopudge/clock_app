import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../core/utils.dart';
import '../../theme/fonts.dart';

class AlarmSchedule extends StatelessWidget {
  final bool isAlarm;
  const AlarmSchedule({super.key, required this.isAlarm});

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfTheWeek =
        context.watch<AddEditAlarmCubit>().state.weekdays;
    if (daysOfTheWeek.length == 7) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Everyday',
            style: AppFonts.labelStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      if (daysOfTheWeek.isNotEmpty) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Every - ${AppUtils.daysOfTheWeekToString(daysOfTheWeek)}.',
              style: AppFonts.labelStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Tomorrow - ${AppUtils.getTomorrowDate()}.',
              style: AppFonts.labelStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    }
  }
}
