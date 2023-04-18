part of 'alarms_bloc.dart';

@immutable
abstract class AlarmsEvent {}

class AlarmsCreateAlarmEvent extends AlarmsEvent {
  final String? name;
  final DateTime time;
  final List<String> daysOfTheWeek;

  AlarmsCreateAlarmEvent({
    required this.name,
    required this.time,
    required this.daysOfTheWeek,
  });
}

class AlarmsUpdateAlarmEvent extends AlarmsEvent {
  final String id;
  final String? name;
  final DateTime time;
  final List<String> daysOfTheWeek;

  AlarmsUpdateAlarmEvent({
    required this.id,
    required this.name,
    required this.time,
    required this.daysOfTheWeek,
  });
}

class AlarmsGetAlarmsEvent extends AlarmsEvent {}

class AlarmsLaunchAlarmEvent extends AlarmsEvent {
  final String id;

  AlarmsLaunchAlarmEvent({
    required this.id,
  });
}

class AlarmsLaunchAlarmsEvent extends AlarmsEvent {
  final List<AlarmModel> alarms;

  AlarmsLaunchAlarmsEvent({
    required this.alarms,
  });
}

class AlarmsDeleteAlarmEvent extends AlarmsEvent {
  final String id;

  AlarmsDeleteAlarmEvent({
    required this.id,
  });
}

class AlarmsDeleteAlarmsEvent extends AlarmsEvent {
  final List<AlarmModel> alarms;

  AlarmsDeleteAlarmsEvent({
    required this.alarms,
  });
}

class AlarmsStartAlarmTimerEvent extends AlarmsEvent {}
