import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums.dart';
import '../../models/alarm/alarm.dart';

part 'alarm_view_state.dart';

class AlarmViewCubit extends Cubit<AlarmViewCubitState> {
  AlarmViewCubit() : super(AlarmViewCubitState());

  void setFilterType(FilterType filter) => emit(state.copyWith(filter: filter));

  void setSortType() {
    if (state.sort == SortType.ascending) {
      emit(state.copyWith(sort: SortType.descending));
    } else {
      emit(state.copyWith(sort: SortType.ascending));
    }
  }

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

  void addOneAlarm(Alarm alarm) {
    if (state.currentlyChangingAlarms.contains(alarm)) {
      emit(state.copyWith(
          currentlyChangingAlarms: [...state.currentlyChangingAlarms]
            ..remove(alarm)));
    } else {
      emit(state.copyWith(
          currentlyChangingAlarms: [...state.currentlyChangingAlarms, alarm]));
    }
  }

  void setAllAlarms(List<Alarm> alarms) =>
      emit(state.copyWith(currentlyChangingAlarms: alarms));

  void clearAlarms() => emit(state.copyWith(currentlyChangingAlarms: []));
}
