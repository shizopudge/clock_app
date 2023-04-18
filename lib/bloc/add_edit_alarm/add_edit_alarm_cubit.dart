import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_edit_alarm_state.dart';

class AddEditAlarmCubit extends Cubit<AddEditAlarmState> {
  AddEditAlarmCubit() : super(AddEditAlarmState());

  void setHour(int hour) => emit(state.copyWith(hour: hour));

  void setMinute(int minute) => emit(state.copyWith(minute: minute));

  void setName(String name) => emit(state.copyWith(name: name));

  void setId(String id) => emit(state.copyWith(id: id));

  void addDay(String day) => emit(
        state.copyWith(
          weekdays: [...state.weekdays, day],
        ),
      );

  void removeDay(String day) => emit(
        state.copyWith(
          weekdays: [...state.weekdays..remove(day)],
        ),
      );

  void setDays(List<String> weekdays) => emit(
        state.copyWith(weekdays: weekdays),
      );

  void reset() => emit(
        AddEditAlarmState(
          hour: DateTime.now().hour,
          minute: DateTime.now().minute,
        ),
      );
}
