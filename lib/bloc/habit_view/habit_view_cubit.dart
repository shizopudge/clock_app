import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums.dart';
import '../../models/habit/habit.dart';

part 'habit_view_state.dart';

class HabitViewCubit extends Cubit<HabitViewCubitState> {
  HabitViewCubit() : super(HabitViewCubitState());

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

  void addOneHabit(Habit habit) {
    if (state.currentlyChangingHabits.contains(habit)) {
      emit(state.copyWith(
          currentlyChangingHabits: [...state.currentlyChangingHabits]
            ..remove(habit)));
    } else {
      emit(state.copyWith(
          currentlyChangingHabits: [...state.currentlyChangingHabits, habit]));
    }
  }

  void setAllHabits(List<Habit> habits) =>
      emit(state.copyWith(currentlyChangingHabits: habits));

  void clearAlarms() => emit(state.copyWith(currentlyChangingHabits: []));
}
