import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_edit_habit_state.dart';

class AddEditHabitCubit extends Cubit<AddEditHabitState> {
  AddEditHabitCubit() : super(AddEditHabitState());

  void setInterval(int interval) => emit(state.copyWith(interval: interval));

  void setName(String name) => emit(state.copyWith(name: name));

  void setDescription(String description) =>
      emit(state.copyWith(description: description));

  void setId(String id) => emit(state.copyWith(id: id));

  void reset() => emit(
        AddEditHabitState(),
      );
}
