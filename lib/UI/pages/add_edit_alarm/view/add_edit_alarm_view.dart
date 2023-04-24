import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';

import '../../../../storage/database.dart';
import '../../../../theme/pallete.dart';
import '../../../../theme/theme.dart';
import '../controller/add_edit_alarm_controller.dart';
import '../widgets/alarm_picker.dart';
import '../../../common/alarm_schedule.dart';
import '../../../common/add_edit_settings.dart';

class AddEditAlarmView extends StatefulWidget {
  final bool isAddAlarm;
  final AddEditAlarmController _addEditAlarmController;

  const AddEditAlarmView(
      {super.key,
      required this.isAddAlarm,
      required AddEditAlarmController addEditAlarmController})
      : _addEditAlarmController = addEditAlarmController;

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
    init(
      context,
      isAddAlarm: widget.isAddAlarm,
    );
  }

  void init(
    BuildContext context, {
    required bool isAddAlarm,
  }) {
    if (isAddAlarm) {
      widget._addEditAlarmController.reset(context);
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

  @override
  void dispose() {
    super.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddEditAlarmState addEditAlarmState =
        context.watch<AddEditAlarmCubit>().state;
    final String theme = Hive.box(DatabaseHelper.settingsBox)
        .get('theme', defaultValue: AppTheme.defaultTheme);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: theme == AppTheme.darkThemeName
              ? PalleteDark.backgroundColor
              : null,
          gradient: theme == AppTheme.lightThemeName
              ? PalleteLight.backgroundGradient
              : null,
        ),
        child: Column(
          children: [
            Expanded(
              child: AlarmPicker(
                hourController: _hourController,
                minuteController: _minuteController,
                currentHour: addEditAlarmState.hour,
                currentMinute: addEditAlarmState.minute,
                onHourChanged: (hour) =>
                    widget._addEditAlarmController.onHourChanged(context, hour),
                onMinuteChanged: (minute) => widget._addEditAlarmController
                    .onMinuteChanged(context, minute),
              ),
            ),
            const AlarmSchedule(),
            AddEditSettings(
              onSave: () => widget._addEditAlarmController.onSave(
                context,
                id: addEditAlarmState.id,
                isAddAlarm: widget.isAddAlarm,
                name: addEditAlarmState.name,
                hour: addEditAlarmState.hour,
                minute: addEditAlarmState.minute,
                weekdays: addEditAlarmState.weekdays,
              ),
              nameController: _nameController,
              nameHintText: 'Alarm name',
              isAlarm: true,
            ),
          ],
        ),
      ),
    );
  }
}
