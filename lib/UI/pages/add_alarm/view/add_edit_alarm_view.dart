import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../../../bloc/alarms/alarms_bloc.dart';
import '../../../../core/utils.dart';

import '../widgets/alarm_picker.dart';
import '../../../common/alarm_schedule.dart';
import '../widgets/alarm_settings.dart';

class AddEditAlarmView extends StatefulWidget {
  final bool isAddAlarm;

  const AddEditAlarmView({
    super.key,
    required this.isAddAlarm,
  });

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
      context.read<AlarmsBloc>().add(
            AlarmsCreateAlarmEvent(
              name: addEditAlarmState.name,
              time: DateTime(
                  0, 0, 0, addEditAlarmState.hour, addEditAlarmState.minute),
              daysOfTheWeek: addEditAlarmState.weekdays,
            ),
          );
    } else {
      context.read<AlarmsBloc>().add(
            AlarmsUpdateAlarmEvent(
              id: addEditAlarmState.id ?? '',
              name: addEditAlarmState.name,
              time: DateTime(
                  0, 0, 0, addEditAlarmState.hour, addEditAlarmState.minute),
              daysOfTheWeek: addEditAlarmState.weekdays,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AddEditAlarmState addEditAlarmState =
        context.watch<AddEditAlarmCubit>().state;
    return BlocListener<AlarmsBloc, AlarmsState>(
      listenWhen: (previous, current) {
        return current.alarms != previous.alarms;
      },
      listener: (context, state) {
        AppUtils.showSnackBar(
          context,
          'Alarm clock successfully set to ${AppUtils.formatTime(DateTime(0, 0, 0, addEditAlarmState.hour, addEditAlarmState.minute))}',
        );
        Navigator.pop(context);
      },
      child: Scaffold(
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
      ),
    );
  }
}
