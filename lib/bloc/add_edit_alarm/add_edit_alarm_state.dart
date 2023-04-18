part of 'add_edit_alarm_cubit.dart';

class AddEditAlarmState {
  final String? id;
  final String? name;
  final int hour;
  final int minute;
  final List<String> weekdays;
  AddEditAlarmState({
    this.id,
    this.name,
    this.hour = 6,
    this.minute = 0,
    this.weekdays = const [],
  });

  AddEditAlarmState copyWith({
    String? id,
    String? name,
    int? hour,
    int? minute,
    List<String>? weekdays,
  }) {
    return AddEditAlarmState(
      id: id ?? this.id,
      name: name ?? this.name,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
    );
  }
}
