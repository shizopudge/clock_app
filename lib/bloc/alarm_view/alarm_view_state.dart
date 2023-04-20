part of 'alarm_view_cubit.dart';

enum SortType {
  descending,
  ascending,
}

enum FilterType {
  none,
  onlyLaunched,
  onlyOffed,
}

class AlarmViewCubitState {
  final SortType sort;
  final FilterType filter;
  final bool isEditMode;
  final List<AlarmModel> currentlyChangingAlarms;

  AlarmViewCubitState({
    this.sort = SortType.ascending,
    this.filter = FilterType.none,
    this.isEditMode = false,
    this.currentlyChangingAlarms = const [],
  });

  AlarmViewCubitState copyWith({
    SortType? sort,
    FilterType? filter,
    bool? isEditMode,
    List<AlarmModel>? currentlyChangingAlarms,
  }) {
    return AlarmViewCubitState(
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
      isEditMode: isEditMode ?? this.isEditMode,
      currentlyChangingAlarms:
          currentlyChangingAlarms ?? this.currentlyChangingAlarms,
    );
  }
}
