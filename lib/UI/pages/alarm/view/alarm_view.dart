import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../bloc/alarm_view/alarm_view_cubit.dart';

import '../../../../core/ui_utils.dart';
import '../../../../core/enums.dart';
import '../../../../models/alarm/alarm.dart';
import '../../../../storage/database.dart';
import '../../../../theme/fonts.dart';
import '../../../common/alarm_card.dart';
import '../alarm_controller/alarm_controller.dart';
import '../widgets/alarm_appbar.dart';

class AlarmView extends StatefulWidget {
  final AlarmController _alarmController;
  const AlarmView({super.key, required AlarmController alarmController})
      : _alarmController = alarmController;

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  static final ScrollController _scrollController = ScrollController();
  final Box<Alarm> alarmsBox = Hive.box<Alarm>(DatabaseHelper.alarmsBox);

  @override
  void initState() {
    super.initState();
    widget._alarmController.init(context, alarmsBox, _scrollController);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final SortType sort = context.watch<AlarmViewCubit>().state.sort;
    final FilterType filter = context.watch<AlarmViewCubit>().state.filter;
    return ValueListenableBuilder(
      valueListenable: alarmsBox.listenable(),
      builder: (context, box, _) {
        List<Alarm> alarms = widget._alarmController.sortAndFilterAlarms(
            alarmsBox: alarmsBox, sort: sort, filter: filter);
        return NestedScrollView(
          key: UIUtils.alarmsNestedScrollViewKey,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            AlarmAppBar(
              height: height,
              alarms: box.values.toList(),
              shownAlarms: alarms,
              alarmController: widget._alarmController,
            ),
          ],
          controller: _scrollController,
          body: alarms.isEmpty
              ? Center(
                  child: Text(
                    filter == FilterType.onlyEnabled
                        ? 'No enabled alarms'
                        : filter == FilterType.onlyDisabled
                            ? 'No disabled alarms'
                            : 'No alarms',
                    style: AppFonts.headerStyle,
                  ),
                )
              : Scrollbar(
                  controller: UIUtils
                      .alarmsNestedScrollViewKey.currentState?.innerController,
                  thickness: 2.5,
                  thumbVisibility: false,
                  interactive: true,
                  radius: const Radius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final Alarm alarm = alarms[index];
                        if (index == alarms.length - 1) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: AlarmCard(
                              alarm: alarm,
                              alarmController: widget._alarmController,
                            ),
                          );
                        }
                        return AlarmCard(
                          alarm: alarm,
                          alarmController: widget._alarmController,
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
