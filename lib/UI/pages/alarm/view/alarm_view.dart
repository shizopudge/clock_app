import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rate_limiter/rate_limiter.dart';

import '../../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../../bloc/alarms_timer/alarm_timer_cubit.dart';

import '../../../../constants/ui_constants.dart';
import '../../../../models/alarm.dart';
import '../../../../repositories/alarms_repository.dart';
import '../../../../services/alarm_services.dart';
import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
import '../../../common/alarm_card.dart';
import '../widgets/alarm_appbar.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  static final ScrollController _scrollController = ScrollController();
  late final Box<AlarmModel> alarmsBox;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _init() {
    alarmsBox = Hive.box<AlarmModel>(DatabaseHelper.alarmsBox);
    _startTimer();
    alarmsBox.listenable().addListener(_onAlarmsChange);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 55) {
      context.read<AlarmAppBarCubit>().collapse();
    } else {
      context.read<AlarmAppBarCubit>().expand();
    }
  }

  void _startTimer() => context.read<AlarmTimerCubit>().startAlarmTimer();

  final Debounce _scheduleNotifications = debounce(
    () async {
      final List<AlarmModel> launchedAlarms =
          await AlarmsRepository().getLaunchedAlarms();
      await AlarmServices().scheduleAlarms(launchedAlarms);
    },
    const Duration(
      milliseconds: 1000,
    ),
  );

  void _onAlarmsChange() {
    _startTimer();
    _scheduleNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final SortType sort = context.watch<AlarmViewCubit>().state.sort;
    final FilterType filter = context.watch<AlarmViewCubit>().state.filter;
    return ValueListenableBuilder(
      valueListenable: alarmsBox.listenable(),
      builder: (context, box, widget) {
        List<AlarmModel> alarms = [];
        if (sort == SortType.ascending) {
          alarms = box.values.toList()
            ..sort(
              (a, b) => a.time.compareTo(b.time),
            );
        } else {
          alarms = box.values.toList()
            ..sort(
              (a, b) => b.time.compareTo(a.time),
            );
        }
        if (filter == FilterType.onlyLaunched) {
          alarms = alarms.where((alarm) => alarm.islaunched).toList();
        }
        if (filter == FilterType.onlyOffed) {
          alarms = alarms.where((alarm) => !alarm.islaunched).toList();
        }
        return NestedScrollView(
          key: UIConstants.nestedScrollViewKey,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            AlarmAppBar(
              height: height,
              alarms: box.values.toList(),
              shownAlarms: alarms,
            ),
          ],
          controller: _scrollController,
          body: alarms.isEmpty
              ? Center(
                  child: Text(
                    filter == FilterType.onlyLaunched
                        ? 'No enabled alarms'
                        : filter == FilterType.onlyOffed
                            ? 'No disabled alarms'
                            : 'No alarms',
                    style: AppFonts.headerStyle,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Scrollbar(
                    controller: UIConstants
                        .nestedScrollViewKey.currentState?.innerController,
                    thickness: 2.5,
                    thumbVisibility: false,
                    interactive: true,
                    radius: const Radius.circular(12),
                    child: ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final AlarmModel alarm = alarms[index];
                        if (index == alarms.length - 1) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: AlarmCard(
                              alarm: alarm,
                              alarmsRepository: AlarmsRepository(),
                            ),
                          );
                        }
                        return AlarmCard(
                          alarm: alarm,
                          alarmsRepository: AlarmsRepository(),
                        );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }
}
