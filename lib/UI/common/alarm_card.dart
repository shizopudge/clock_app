import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../bloc/alarm_view/alarm_view_cubit.dart';
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
      context.read<AlarmViewCubit>().addOneAlarm(alarm);

  void _goToEditAlarm(BuildContext context) {
    context.read<AddEditAlarmCubit>().setId(alarm.id);
    context.read<AddEditAlarmCubit>().setName(alarm.name ?? '');
    context.read<AddEditAlarmCubit>().setDays(alarm.weekdays);
    context.read<AddEditAlarmCubit>().setHour(alarm.time.hour);
    context.read<AddEditAlarmCubit>().setMinute(alarm.time.minute);
    AppRouter.navigateWithSlideTransition(context, AppRouter.editAlarmPage);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> days = UIConstants.launchedDays(
      alarm.weekdays,
    );
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
    return Card(
      color: Pallete.blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          if (alarmViewState.isEditMode) {
            _onAddOneAlarm(context);
          } else {
            _goToEditAlarm(context);
          }
        },
        borderRadius: BorderRadius.circular(21),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: alarmViewState.isEditMode
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (alarmViewState.isEditMode)
                          Checkbox(
                            value: alarmViewState.currentlyChangingAlarms
                                .contains(alarm),
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
                          onChanged: (isLaunched) {},
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
                          onChanged: (isLaunched) => !alarmViewState.isEditMode
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
