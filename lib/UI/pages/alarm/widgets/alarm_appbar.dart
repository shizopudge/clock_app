import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/alarms_timer/alarm_timer_cubit.dart';
import '../../../../bloc/edit_alarms/edit_alarms_cubit.dart';
import '../../../../core/router.dart';
import '../../../../core/utils.dart';
import '../../../../models/alarm.dart';
import '../../../../theme/fonts.dart';
import '../../../common/add_button.dart';
import '../../../common/clock.dart';
import 'alarm_popup.dart';
import 'next_alarm.dart';

class AlarmAppBarCubit extends Cubit<bool> {
  AlarmAppBarCubit() : super(false);

  void collapse() => emit(true);

  void expand() => emit(false);
}

class AlarmAppBar extends StatelessWidget {
  final double height;
  final List<AlarmModel> alarms;
  const AlarmAppBar({
    super.key,
    required this.height,
    required this.alarms,
  });

  void _onChanged(int editAlarmsLength, BuildContext context) {
    if (editAlarmsLength == alarms.length) {
      context.read<EditAlarmsCubit>().clearAlarms();
    } else {
      context.read<EditAlarmsCubit>().setAllAlarms(alarms);
    }
  }

  void _goToAddAlarm(BuildContext context) {
    if (alarms.length == 200) {
      AppUtils.showSnackBar(context, 'You cannot create more than 200 alarms.');
    } else {
      AppRouter.goToAddAlarmRoute(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCollapsed = context.watch<AlarmAppBarCubit>().state;
    final AlarmTimerState alarmTimerState =
        context.watch<AlarmTimerCubit>().state;
    final EditAlarmsState editAlarmsState =
        context.watch<EditAlarmsCubit>().state;
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverSafeArea(
        top: false,
        bottom: false,
        sliver: SliverAppBar(
          elevation: 0,
          floating: true,
          pinned: true,
          backgroundColor: Colors.transparent,
          expandedHeight: height / 3,
          bottom: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              50,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: editAlarmsState.isEditMode
                  ? isCollapsed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: editAlarmsState.alarms.length ==
                                      alarms.length,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  onChanged: (value) => _onChanged(
                                    editAlarmsState.alarms.length,
                                    context,
                                  ),
                                ),
                                Text(
                                  'All',
                                  style: AppFonts.labelStyle,
                                ),
                              ],
                            ),
                            Text(
                              'Selected: ${editAlarmsState.alarms.length}',
                              style: AppFonts.labelStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                value: editAlarmsState.alarms.length ==
                                    alarms.length,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                ),
                                onChanged: (value) => _onChanged(
                                  editAlarmsState.alarms.length,
                                  context,
                                ),
                              ),
                              Text(
                                'All',
                                style: AppFonts.labelStyle,
                              ),
                            ],
                          ),
                        )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(
                            milliseconds: 600,
                          ),
                          opacity: isCollapsed ? 1 : 0,
                          child: Text(
                            'Alarms',
                            style: AppFonts.titleStyle,
                          ),
                        ),
                        Row(
                          children: [
                            AddButton(
                              onTap: () => _goToAddAlarm(context),
                            ),
                            alarms.isNotEmpty
                                ? const AlarmPopup()
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Center(
              child: AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 600,
                ),
                opacity: isCollapsed ? 0 : 1,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: editAlarmsState.isEditMode
                      ? Text(
                          'Selected: ${editAlarmsState.alarms.length}',
                          style: AppFonts.headerStyle,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Clock(),
                            const SizedBox(
                              height: 15,
                            ),
                            if (alarmTimerState.secondsBeforeNextAlarm != 0)
                              NextAlarm(
                                secondsBeforeNextAlarm:
                                    alarmTimerState.secondsBeforeNextAlarm,
                              )
                            else if (alarmTimerState.text.isNotEmpty)
                              NextAlarm(
                                text: alarmTimerState.text,
                              )
                          ],
                        ),
                ),
              ),
            ),
            expandedTitleScale: 1,
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}
