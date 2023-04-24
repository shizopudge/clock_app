part of 'timer_picker_cubit.dart';

class TimerPickerState {
  final int hour;
  final int minute;
  final int second;

  TimerPickerState({
    this.hour = 0,
    this.minute = 0,
    this.second = 5,
  });

  TimerPickerState copyWith({
    int? hour,
    int? minute,
    int? second,
  }) {
    return TimerPickerState(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }
}
