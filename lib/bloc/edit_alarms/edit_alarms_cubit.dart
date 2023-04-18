import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/alarm.dart';

part 'edit_alarms_state.dart';

class EditAlarmsCubit extends Cubit<EditAlarmsState> {
  EditAlarmsCubit() : super(EditAlarmsState());

  void toggleEditMode() {
    if (state.isEditMode) {
      emit(
        state.copyWith(isEditMode: false),
      );
    } else {
      emit(
        state.copyWith(isEditMode: true),
      );
    }
  }

  void addOneAlarm(AlarmModel alarm) {
    if (state.alarms.contains(alarm)) {
      emit(state.copyWith(alarms: [...state.alarms]..remove(alarm)));
    } else {
      emit(state.copyWith(alarms: [...state.alarms, alarm]));
    }
  }

  void setAllAlarms(List<AlarmModel> alarms) =>
      emit(state.copyWith(alarms: alarms));

  void clearAlarms() => emit(state.copyWith(alarms: []));
}
