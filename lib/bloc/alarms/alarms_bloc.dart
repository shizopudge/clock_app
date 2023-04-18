import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/alarm.dart';
import '../../repositories/alarms_repository.dart';

part 'alarms_event.dart';
part 'alarms_state.dart';

class AlarmsBloc extends Bloc<AlarmsEvent, AlarmsState> {
  final AlarmsRepository _alarmsRepository;
  AlarmsBloc({
    required AlarmsRepository alarmsRepository,
  })  : _alarmsRepository = alarmsRepository,
        super(const AlarmsState()) {
    on<AlarmsCreateAlarmEvent>(_createAlarm);
    on<AlarmsUpdateAlarmEvent>(_updateAlarm);
    on<AlarmsGetAlarmsEvent>(_getAlarms);
    on<AlarmsLaunchAlarmEvent>(_launchAlarm);
    on<AlarmsLaunchAlarmsEvent>(_launchAlarms);
    on<AlarmsDeleteAlarmEvent>(_deleteAlarm);
    on<AlarmsDeleteAlarmsEvent>(_deleteAlarms);
  }

  Future _createAlarm(
      AlarmsCreateAlarmEvent event, Emitter<AlarmsState> emit) async {
    try {
      emit(
        state.copyWith(
          status: AlarmsStatus.loading,
        ),
      );
      await _alarmsRepository.createAlarm(
        time: event.time,
        weekdays: event.daysOfTheWeek,
        name: event.name,
      );
      final List<AlarmModel> alarms = await _alarmsRepository.getAlarms();
      emit(
        state.copyWith(
          status: AlarmsStatus.success,
          alarms: alarms,
        ),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future _updateAlarm(
      AlarmsUpdateAlarmEvent event, Emitter<AlarmsState> emit) async {
    try {
      emit(
        state.copyWith(
          status: AlarmsStatus.loading,
        ),
      );
      await _alarmsRepository.updateAlarm(
        id: event.id,
        time: event.time,
        weekdays: event.daysOfTheWeek,
        name: event.name,
      );
      final List<AlarmModel> alarms = await _alarmsRepository.getAlarms();
      emit(
        state.copyWith(
          status: AlarmsStatus.success,
          alarms: alarms,
        ),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future _getAlarms(
      AlarmsGetAlarmsEvent event, Emitter<AlarmsState> emit) async {
    try {
      emit(
        state.copyWith(
          status: AlarmsStatus.loading,
        ),
      );
      final List<AlarmModel> alarms = await _alarmsRepository.getAlarms();
      emit(
        state.copyWith(status: AlarmsStatus.success, alarms: alarms),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future _launchAlarm(
      AlarmsLaunchAlarmEvent event, Emitter<AlarmsState> emit) async {
    try {
      List<AlarmModel> alarms = state.alarms.toList();
      final AlarmModel launchedAlarm =
          alarms.firstWhere((alarm) => alarm.id == event.id);
      if (launchedAlarm.islaunched) {
        final int index = alarms.indexWhere((alarm) => alarm.id == event.id);
        alarms[index] = launchedAlarm.copyWith(islaunched: false);
        await _alarmsRepository.launchAlarm(event.id);
      } else {
        final int index = alarms.indexWhere((alarm) => alarm.id == event.id);
        alarms[index] = launchedAlarm.copyWith(islaunched: true);
        await _alarmsRepository.launchAlarm(event.id);
      }
      emit(
        state.copyWith(status: AlarmsStatus.success, alarms: alarms),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future _launchAlarms(
      AlarmsLaunchAlarmsEvent event, Emitter<AlarmsState> emit) async {
    try {
      List<AlarmModel> alarms = state.alarms.toList();
      for (AlarmModel alarm in event.alarms) {
        final AlarmModel launchedAlarm =
            alarms.firstWhere((e) => e.id == alarm.id);
        if (launchedAlarm.islaunched) {
          final int index = alarms.indexWhere((e) => e.id == alarm.id);
          alarms[index] = launchedAlarm.copyWith(islaunched: false);
          await _alarmsRepository.launchAlarm(alarm.id);
        } else {
          final int index = alarms.indexWhere((e) => e.id == alarm.id);
          alarms[index] = launchedAlarm.copyWith(islaunched: true);
          await _alarmsRepository.launchAlarm(alarm.id);
        }
      }
      emit(
        state.copyWith(status: AlarmsStatus.success, alarms: alarms),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future _deleteAlarm(
      AlarmsDeleteAlarmEvent event, Emitter<AlarmsState> emit) async {
    try {
      List<AlarmModel> alarms = state.alarms.toList();
      alarms.removeWhere(
        (alarm) => alarm.id == event.id,
      );
      await _alarmsRepository.deleteAlarm(event.id);
      emit(
        state.copyWith(status: AlarmsStatus.success, alarms: alarms),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future _deleteAlarms(
      AlarmsDeleteAlarmsEvent event, Emitter<AlarmsState> emit) async {
    try {
      List<AlarmModel> alarms = state.alarms.toList();
      for (AlarmModel alarm in event.alarms) {
        alarms.removeWhere(
          (e) => e.id == alarm.id,
        );
        await _alarmsRepository.deleteAlarm(alarm.id);
      }
      emit(
        state.copyWith(status: AlarmsStatus.success, alarms: alarms),
      );
    } on HiveError catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AlarmsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
