part of 'edit_alarms_cubit.dart';

class EditAlarmsState {
  final bool isEditMode;
  final List<AlarmModel> alarms;
  EditAlarmsState({
    this.isEditMode = false,
    this.alarms = const [],
  });

  EditAlarmsState copyWith({
    bool? isEditMode,
    List<AlarmModel>? alarms,
  }) {
    return EditAlarmsState(
      isEditMode: isEditMode ?? this.isEditMode,
      alarms: alarms ?? this.alarms,
    );
  }
}
