part of 'alarms_bloc.dart';

enum AlarmsStatus { initial, loading, success, failure }

class AlarmsState extends Equatable {
  final AlarmsStatus status;
  final List<AlarmModel> alarms;
  final String? error;

  const AlarmsState({
    this.status = AlarmsStatus.initial,
    this.alarms = const [],
    this.error,
  });

  @override
  List<Object?> get props => [status, alarms, error];

  AlarmsState copyWith({
    AlarmsStatus? status,
    List<AlarmModel>? alarms,
    String? error,
  }) {
    return AlarmsState(
      status: status ?? this.status,
      alarms: alarms ?? this.alarms,
      error: error ?? this.error,
    );
  }
}
