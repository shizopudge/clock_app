import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../constants/ui_constants.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> days = UIConstants.launchedDays(
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
            onTap: () {
              if (alarmViewState.isEditMode) {
                _alarmController.onAddOneAlarm(context, alarm);
              } else {
                _alarmController.goToEditAlarm(context, alarm);
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
                                    style: AppFonts.labelStyle
                                        .copyWith(fontSize: 12),
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
                              value: alarm.isEnabled,
                              onChanged: (isLaunched) {},
                              inactiveTrackColor: Colors.grey.shade700,
                              inactiveThumbColor: Colors.grey,
                              activeColor: PalleteLight.actionColor,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Switch.adaptive(
                              value: alarm.isEnabled,
                              onChanged: (isLaunched) =>
                                  !alarmViewState.isEditMode
                                      ? _alarmController.enableAlarm(alarm.id)
                                      : null,
                              inactiveTrackColor: Colors.grey.shade700,
                              inactiveThumbColor: Colors.grey,
                              activeColor: PalleteLight.actionColor,
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
