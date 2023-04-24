import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_picker_state.dart';

class TimerPickerCubit extends Cubit<TimerPickerState> {
  TimerPickerCubit() : super(TimerPickerState());

  void setHour(int hour) => emit(
        state.copyWith(
          hour: hour,
        ),
      );

  void setMinute(int minute) => emit(
        state.copyWith(
          minute: minute,
        ),
      );

  void setSecond(int second) => emit(
        state.copyWith(
          second: second,
        ),
      );

  void reset() => emit(TimerPickerState());
}
