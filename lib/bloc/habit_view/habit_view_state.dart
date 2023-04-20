part of 'habit_view_cubit.dart';

class HabitViewCubitState {
  final SortType sort;
  final FilterType filter;
  final bool isEditMode;
  final List<Habit> currentlyChangingHabits;

  HabitViewCubitState({
    this.sort = SortType.ascending,
    this.filter = FilterType.none,
    this.isEditMode = false,
    this.currentlyChangingHabits = const [],
  });

  HabitViewCubitState copyWith({
    SortType? sort,
    FilterType? filter,
    bool? isEditMode,
    List<Habit>? currentlyChangingHabits,
  }) {
    return HabitViewCubitState(
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
      isEditMode: isEditMode ?? this.isEditMode,
      currentlyChangingHabits:
          currentlyChangingHabits ?? this.currentlyChangingHabits,
    );
  }
}
