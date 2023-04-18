import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/alarm.dart';
import '../../repositories/alarms_repository.dart';

part 'alarm_timer_state.dart';

class AlarmTimerCubit extends Cubit<AlarmTimerState> {
  final AlarmsRepository _alarmsRepository;

  AlarmTimerCubit({
    required AlarmsRepository alarmsRepository,
  })  : _alarmsRepository = alarmsRepository,
        super(const AlarmTimerState());

  Timer? _timer;

  Future<void> startAlarmTimer() async {
    _timer?.cancel();
    final List<AlarmModel> alarms = await _alarmsRepository.getAlarms();
    if (alarms.isEmpty) {
      emit(
        const AlarmTimerState(),
      );
      return;
    }
    final List<AlarmModel> launchedAlarms =
        await _alarmsRepository.getLaunchedAlarms();
    if (alarms.isNotEmpty && launchedAlarms.isEmpty) {
      emit(
        const AlarmTimerState(text: 'All alarms are disabled'),
      );
      return;
    }
    final int? secondsBeforeNextAlarm =
        _alarmsRepository.secondsBeforeNextAlarm(launchedAlarms);
    if (secondsBeforeNextAlarm != null) {
      emit(
        AlarmTimerState(secondsBeforeNextAlarm: secondsBeforeNextAlarm),
      );
      _timer = Timer.periodic(const Duration(milliseconds: 1000), onAlarmTick);
    }
  }

  void onAlarmTick(Timer timer) {
    if (state.secondsBeforeNextAlarm != 0) {
      emit(state.copyWith(
          secondsBeforeNextAlarm: state.secondsBeforeNextAlarm - 1));
    } else {
      _timer!.cancel();
      startAlarmTimer();
    }
  }
}
