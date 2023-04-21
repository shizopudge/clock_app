import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../core/ui_utils.dart';
import '../../core/utils.dart';
import '../../models/alarm/alarm.dart';
import '../../storage/database.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';
import '../../theme/theme.dart';
import '../pages/alarm/alarm_controller/alarm_controller.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final AlarmController _alarmController;

  const AlarmCard({
    super.key,
    required this.alarm,
    required AlarmController alarmController,
  }) : _alarmController = alarmController;

  void _onLongPress(BuildContext context) {
    context.read<AlarmViewCubit>().toggleEditMode();
    _alarmController.onAddOneAlarm(context, alarm);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> days = UIUtils.launchedDays(
      alarm.weekdays,
    );
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
    return ValueListenableBuilder(
      valueListenable: Hive.box(DatabaseHelper.settingsBox).listenable(),
      builder: (context, box, _) {
        final String theme =
            box.get('theme', defaultValue: AppTheme.defaultTheme);
        return Container(
          decoration: BoxDecoration(
            gradient: theme == AppTheme.lightThemeName
                ? PalleteLight.alarmCardBg
                : null,
            color: theme == 'dark' ? PalleteDark.cardColor : null,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onLongPress: () {
              if (!alarmViewState.isEditMode) {
                _onLongPress(context);
              }
            },
            onTap: () {
              if (alarmViewState.isEditMode) {
                _alarmController.onAddOneAlarm(context, alarm);
              } else {
                _alarmController.goToEditAlarm(context, alarm);
              }
            },
            borderRadius: BorderRadius.circular(12),
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
                                onChanged: (value) => _alarmController
                                    .onAddOneAlarm(context, alarm),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    alarm.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.labelStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppUtils.formatTime(
                                      alarm.time,
                                    ),
                                    style: AppFonts.timeStyle
                                        .copyWith(fontSize: 48),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: alarm.isEnabled,
                              onChanged: (isLaunched) =>
                                  _alarmController.enableAlarm(alarm.id),
                              inactiveTrackColor: Colors.grey.shade700,
                              inactiveThumbColor: Colors.grey,
                              activeColor: Pallete.actionColor,
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
                                style: AppFonts.labelStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppUtils.formatTime(
                                  alarm.time,
                                ),
                                style:
                                    AppFonts.timeStyle.copyWith(fontSize: 48),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Switch.adaptive(
                              value: alarm.isEnabled,
                              onChanged: (isLaunched) =>
                                  _alarmController.enableAlarm(alarm.id),
                              inactiveTrackColor: Colors.grey.shade700,
                              inactiveThumbColor: Colors.grey,
                              activeColor: Pallete.actionColor,
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
      },
    );
  }
}
