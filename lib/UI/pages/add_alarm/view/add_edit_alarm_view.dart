import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../../../core/utils.dart';

import '../../../../repositories/alarms_repository.dart';
import '../widgets/alarm_picker.dart';
import '../../../common/alarm_schedule.dart';
import '../widgets/alarm_settings.dart';

class AddEditAlarmView extends StatefulWidget {
  final bool isAddAlarm;
  final AlarmsRepository _alarmsRepository;

  const AddEditAlarmView(
      {super.key,
      required this.isAddAlarm,
      required AlarmsRepository alarmsRepository})
      : _alarmsRepository = alarmsRepository;

  @override
  State<AddEditAlarmView> createState() => _AddEditAlarmViewState();
}

class _AddEditAlarmViewState extends State<AddEditAlarmView> {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _nameController.dispose();
  }

  void _init() {
    if (widget.isAddAlarm) {
      _reset();
      _nameController = TextEditingController();
      _hourController =
          FixedExtentScrollController(initialItem: DateTime.now().hour);
      _minuteController =
          FixedExtentScrollController(initialItem: DateTime.now().minute);
    } else {
      _nameController = TextEditingController(
          text: context.read<AddEditAlarmCubit>().state.name);
      _hourController = FixedExtentScrollController(
          initialItem: context.read<AddEditAlarmCubit>().state.hour);
      _minuteController = FixedExtentScrollController(
          initialItem: context.read<AddEditAlarmCubit>().state.minute);
    }
  }

  void _reset() => context.read<AddEditAlarmCubit>().reset();

  void _onHourChanged(int hour) =>
      context.read<AddEditAlarmCubit>().setHour(hour);

  void _onMinuteChanged(int minute) =>
      context.read<AddEditAlarmCubit>().setMinute(minute);

  void _onSave(AddEditAlarmState addEditAlarmState) {
    if (widget.isAddAlarm) {
      widget._alarmsRepository
          .createAlarm(
        name: addEditAlarmState.name,
        time: DateTime(
          0,
          0,
          0,
          addEditAlarmState.hour,
          addEditAlarmState.minute,
        ),
        weekdays: addEditAlarmState.weekdays,
      )
          .whenComplete(() {
        AppUtils.showSnackBar(
          context,
          'Alarm clock successfully set to ${AppUtils.formatTime(DateTime(0, 0, 0, addEditAlarmState.hour, addEditAlarmState.minute))}',
        );
        Navigator.pop(context);
      });
    } else {
      widget._alarmsRepository
          .updateAlarm(
        id: addEditAlarmState.id ?? '',
        name: addEditAlarmState.name,
        time: DateTime(
          0,
          0,
          0,
          addEditAlarmState.hour,
          addEditAlarmState.minute,
        ),
        weekdays: addEditAlarmState.weekdays,
      )
          .whenComplete(() {
        AppUtils.showSnackBar(
          context,
          'Alarm clock successfully set to ${AppUtils.formatTime(DateTime(0, 0, 0, addEditAlarmState.hour, addEditAlarmState.minute))}',
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddEditAlarmState addEditAlarmState =
        context.watch<AddEditAlarmCubit>().state;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AlarmPicker(
              hourController: _hourController,
              minuteController: _minuteController,
              currentHour: addEditAlarmState.hour,
              currentMinute: addEditAlarmState.minute,
              onHourChanged: _onHourChanged,
              onMinuteChanged: _onMinuteChanged,
            ),
          ),
          const AlarmSchedule(),
          AlarmSettings(
            onSave: () => _onSave(addEditAlarmState),
            nameController: _nameController,
            isAddAlarm: widget.isAddAlarm,
          ),
        ],
      ),
    );
  }
}
