part of 'timer_cubit.dart';

class TimerState {
  final int duration;
  final TimerStatus status;
  const TimerState({
    this.duration = 0,
    this.status = TimerStatus.stopped,
  });

  TimerState copyWith({
    int? duration,
    TimerStatus? status,
  }) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }
}
