import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/alarms/alarms_bloc.dart';
import '../../../../bloc/alarms_timer/alarm_timer_cubit.dart';
import '../../../../core/utils.dart';
import '../../../../models/alarm.dart';
import '../../../../repositories/alarms_repository.dart';
import '../../../../services/alarm_services.dart';
import '../../../../theme/fonts.dart';
import '../../../common/alarm_card.dart';
import '../widgets/alarm_appbar.dart';

class AlarmViewCubit extends Cubit<ScrollController> {
  AlarmViewCubit() : super(ScrollController());

  void defineController(ScrollController scrollController) =>
      emit(scrollController);
}

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  static final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<AlarmViewCubit>().defineController(_scrollController);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 55) {
      context.read<AlarmAppBarCubit>().collapse();
    } else {
      context.read<AlarmAppBarCubit>().expand();
    }
  }

  void _startTimer() => context.read<AlarmTimerCubit>().startAlarmTimer();

  void _scheduleNotifications() async {
    final List<AlarmModel> launchedAlarms =
        await AlarmsRepository().getLaunchedAlarms();
    await AlarmServices.scheduleAlarms(launchedAlarms);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AlarmsBloc, AlarmsState>(
      listenWhen: (previous, current) {
        return previous.alarms != current.alarms;
      },
      listener: (context, state) {
        _startTimer();
        _scheduleNotifications();
        if (state.status == AlarmsStatus.failure) {
          AppUtils.showSnackBar(
            context,
            state.error ?? 'Something went wrong...',
            duration: 864000000,
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case AlarmsStatus.initial:
            return const SizedBox();
          case AlarmsStatus.loading:
            return const SizedBox();
          case AlarmsStatus.success:
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                AlarmAppBar(
                  height: height,
                  alarms: state.alarms,
                ),
              ],
              controller: _scrollController,
              body: state.alarms.isEmpty
                  ? Center(
                      child: Text(
                        'No alarms',
                        style: AppFonts.headerStyle,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        itemCount: state.alarms.length,
                        itemBuilder: (context, index) {
                          final AlarmModel alarm = state.alarms[index];
                          if (index == state.alarms.length - 1) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: AlarmCard(
                                alarm: alarm,
                              ),
                            );
                          }
                          return AlarmCard(
                            alarm: alarm,
                          );
                        },
                      ),
                    ),
            );
          case AlarmsStatus.failure:
            return const SizedBox();
        }
      },
    );
  }
}
