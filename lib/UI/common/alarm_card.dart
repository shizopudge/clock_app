import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../bloc/edit_alarms/edit_alarms_cubit.dart';
import '../../constants/ui_constants.dart';
import '../../core/router.dart';
import '../../core/utils.dart';
import '../../models/alarm.dart';
import '../../repositories/alarms_repository.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final AlarmsRepository _alarmsRepository;

  const AlarmCard({
    super.key,
    required this.alarm,
    required AlarmsRepository alarmsRepository,
  }) : _alarmsRepository = alarmsRepository;

  void _onAddOneAlarm(BuildContext context) =>
      context.read<EditAlarmsCubit>().addOneAlarm(alarm);

  void _goToEditAlarm(BuildContext context) {
    context.read<AddEditAlarmCubit>().setId(alarm.id);
    context.read<AddEditAlarmCubit>().setName(alarm.name ?? '');
    context.read<AddEditAlarmCubit>().setDays(alarm.weekdays);
    context.read<AddEditAlarmCubit>().setHour(alarm.time.hour);
    context.read<AddEditAlarmCubit>().setMinute(alarm.time.minute);
    AppRouter.goToEditAlarmRoute(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> days = UIConstants.launchedDays(
      alarm.weekdays,
    );
    final EditAlarmsState editAlarmsState =
        context.watch<EditAlarmsCubit>().state;
    return Card(
      color: Pallete.blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          if (editAlarmsState.isEditMode) {
            _onAddOneAlarm(context);
          } else {
            _goToEditAlarm(context);
          }
        },
        borderRadius: BorderRadius.circular(21),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: editAlarmsState.isEditMode
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (editAlarmsState.isEditMode)
                          Checkbox(
                            value: editAlarmsState.alarms.contains(alarm),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            onChanged: (value) => _onAddOneAlarm(context),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                alarm.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppFonts.labelStyle.copyWith(fontSize: 12),
                              ),
                              Text(
                                AppUtils.formatTime(
                                  alarm.time,
                                ),
                                style: AppFonts.timeStyle,
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: alarm.islaunched,
                          onChanged: (isLaunched) => !editAlarmsState.isEditMode
                              ? _alarmsRepository.launchAlarm(alarm.id)
                              : null,
                          inactiveTrackColor: Colors.grey.shade700,
                          inactiveThumbColor: Colors.black45,
                          activeColor: Pallete.blueColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...days,
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            alarm.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.labelStyle.copyWith(fontSize: 12),
                          ),
                          Text(
                            AppUtils.formatTime(
                              alarm.time,
                            ),
                            style: AppFonts.timeStyle,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Switch.adaptive(
                          value: alarm.islaunched,
                          onChanged: (isLaunched) => !editAlarmsState.isEditMode
                              ? _alarmsRepository.launchAlarm(alarm.id)
                              : null,
                          inactiveTrackColor: Colors.grey.shade700,
                          inactiveThumbColor: Colors.black45,
                          activeColor: Pallete.blueColor,
                        ),
                        Row(
                          children: [
                            ...days,
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
