import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../../../core/utils.dart';
import '../../../../repositories/alarms_repository.dart';

abstract class IAddEditAlarmController {
  void reset(BuildContext context);

  void onHourChanged(BuildContext context, int hour);

  void onMinuteChanged(BuildContext context, int minute);

  void onSave(
    BuildContext context, {
    String? id,
    required bool isAddAlarm,
    required String name,
    required int hour,
    required int minute,
    required List<String> weekdays,
  });

  void onSaveComplete(BuildContext context, DateTime alarmTime);
}

class AddEditAlarmController extends IAddEditAlarmController {
  final AlarmsRepository _alarmsRepository;

  AddEditAlarmController({required AlarmsRepository alarmsRepository})
      : _alarmsRepository = alarmsRepository;

  @override
  void reset(BuildContext context) => context.read<AddEditAlarmCubit>().reset();

  @override
  void onHourChanged(BuildContext context, int hour) =>
      context.read<AddEditAlarmCubit>().setHour(hour);

  @override
  void onMinuteChanged(BuildContext context, int minute) =>
      context.read<AddEditAlarmCubit>().setMinute(minute);

  @override
  void onSave(
    BuildContext context, {
    String? id,
    required bool isAddAlarm,
    String? name,
    required int hour,
    required int minute,
    required List<String> weekdays,
  }) {
    final DateTime alarmTime = DateTime(0, 0, 0, hour, minute);
    if (isAddAlarm) {
      _alarmsRepository
          .createAlarm(
            name: name,
            time: alarmTime,
            weekdays: weekdays,
          )
          .whenComplete(() => onSaveComplete(context, alarmTime));
    } else {
      _alarmsRepository
          .updateAlarm(
            id: id ?? '',
            name: name,
            time: alarmTime,
            weekdays: weekdays,
          )
          .whenComplete(() => onSaveComplete(context, alarmTime));
    }
  }

  @override
  void onSaveComplete(BuildContext context, DateTime alarmTime) {
    AppUtils.showSnackBar(
      context,
      'Alarm clock successfully set to ${AppUtils.formatTime(alarmTime)}',
    );
    Navigator.pop(context);
  }
}
