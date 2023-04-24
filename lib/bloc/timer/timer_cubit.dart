import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerState());

  Future<void> startTimer(int seconds) async {
    emit(
      TimerState(
        duration: seconds,
        status: TimerStatus.running,
      ),
    );
  }

  Future<void> resumeTimer() async {
    emit(
      state.copyWith(status: TimerStatus.running),
    );
  }

  Future<void> pauseTimer() async {
    emit(
      state.copyWith(
        status: TimerStatus.paused,
      ),
    );
  }

  Future<void> endTimer() async {
    emit(state.copyWith(
      status: TimerStatus.alarm,
    ));
  }

  Future<void> stopAlarm() async {
    emit(state.copyWith(
      status: TimerStatus.stopped,
    ));
  }
}
