import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../../bloc/alarms_timer/alarm_timer_cubit.dart';
import '../../../../models/alarm/alarm.dart';
import '../../../../theme/fonts.dart';
import '../../../common/clock.dart';
import '../../../common/filter_popup.dart';
import '../../../common/menu_popup.dart';
import '../alarm_controller/alarm_controller.dart';
import 'next_alarm.dart';

class AlarmAppBarCubit extends Cubit<bool> {
  AlarmAppBarCubit() : super(false);

  void collapse() => emit(true);

  void expand() => emit(false);
}

class AlarmAppBar extends StatelessWidget {
  final double height;
  final List<Alarm> alarms;
  final List<Alarm> shownAlarms;
  final AlarmController _alarmController;
  const AlarmAppBar(
      {super.key,
      required this.height,
      required this.alarms,
      required this.shownAlarms,
      required AlarmController alarmController})
      : _alarmController = alarmController;

  @override
  Widget build(BuildContext context) {
    final bool isCollapsed = context.watch<AlarmAppBarCubit>().state;
    final AlarmTimerState alarmTimerState =
        context.watch<AlarmTimerCubit>().state;
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: alarmViewState.isEditMode
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: alarmViewState
                                      .currentlyChangingAlarms.length ==
                                  shownAlarms.length,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              onChanged: (value) => _alarmController.onChanged(
                                context,
                                editAlarmsLength: alarmViewState
                                    .currentlyChangingAlarms.length,
                                shownAlarms: shownAlarms,
                              ),
                            ),
                            Text(
                              'All',
                              style: AppFonts.labelStyle,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(
                                milliseconds: 1000,
                              ),
                              opacity: isCollapsed ? 1 : 0,
                              child: Text(
                                'Selected: ${alarmViewState.currentlyChangingAlarms.length}',
                                style: AppFonts.labelStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const FilterPopup(),
                            MenuPopup(
                              isListEmpty: alarms.isEmpty,
                            ),
                          ],
                        ),
                      ],
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
                            IconButton(
                              onPressed: () => _alarmController.goToAddAlarm(
                                context,
                                alarms: alarms,
                              ),
                              icon: const Icon(
                                Icons.add_alarm_rounded,
                                size: 32,
                              ),
                            ),
                            if (alarms.isNotEmpty) const FilterPopup(),
                            MenuPopup(
                              isListEmpty: alarms.isEmpty,
                            ),
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
                  child: alarmViewState.isEditMode
                      ? Text(
                          'Selected: ${alarmViewState.currentlyChangingAlarms.length}',
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
