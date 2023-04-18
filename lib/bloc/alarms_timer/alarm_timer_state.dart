part of 'alarm_timer_cubit.dart';

class AlarmTimerState {
  final int secondsBeforeNextAlarm;
  final String text;
  const AlarmTimerState({
    this.secondsBeforeNextAlarm = 0,
    this.text = '',
  });

  AlarmTimerState copyWith({
    int? secondsBeforeNextAlarm,
    String? text,
  }) {
    return AlarmTimerState(
      secondsBeforeNextAlarm:
          secondsBeforeNextAlarm ?? this.secondsBeforeNextAlarm,
      text: text ?? this.text,
    );
  }
}
