part of 'add_edit_habit_cubit.dart';

class AddEditHabitState {
  final String? id;
  final String name;
  final String? description;
  final int interval;
  AddEditHabitState({
    this.id,
    this.name = '',
    this.description,
    this.interval = 900,
  });

  AddEditHabitState copyWith({
    String? id,
    String? name,
    String? description,
    int? interval,
  }) {
    return AddEditHabitState(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      interval: interval ?? this.interval,
    );
  }
}
