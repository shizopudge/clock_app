import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/habit/habit.dart';
import '../services/alarm_services.dart';
import '../storage/database.dart';

abstract class IHabitsRepository {
  Future<void> createHabit({
    required String name,
    required String? description,
    required int interval,
  });

  Future<void> updateHabit({
    required String id,
    required String name,
    required String? description,
    required int interval,
  });

  List<Habit> getHabits();

  List<Habit> getEnabledHabits();

  Future<void> deleteHabit(String id);

  Future<void> deleteHabits(List<String> ids);

  Future<void> enableHabit(String id);

  Future<void> enableHabits(List<String> ids);
}

class HabitsRepository extends IHabitsRepository {
  static final HabitsRepository _habitsRepository =
      HabitsRepository._internal();

  factory HabitsRepository() {
    return _habitsRepository;
  }

  HabitsRepository._internal();

  @override
  Future<void> createHabit({
    required String name,
    required String? description,
    required int interval,
  }) async {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        final String id = const Uuid().v1();
        final Habit habit = Habit(
          id: id,
          name: name,
          description: description,
          interval: interval,
          isEnabled: true,
        );
        await habitsBox.put(id, habit).whenComplete(
              () async => await AlarmServices().scheduleHabit(habit),
            );
      } else {
        debugPrint('Habits box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> updateHabit({
    required String id,
    required String name,
    required String? description,
    required int interval,
  }) async {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        final Habit habit = Habit(
          id: id,
          name: name,
          description: description,
          interval: interval,
          isEnabled: true,
        );
        await habitsBox.put(id, habit).whenComplete(
              () async => await AlarmServices().scheduleHabit(habit),
            );
      } else {
        debugPrint('Habits box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        await habitsBox.delete(id).whenComplete(
              () async => await AlarmServices().cancelHabitSchedule(id),
            );
      } else {
        debugPrint('Habits box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> deleteHabits(List<String> ids) async {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        await habitsBox.deleteAll(ids).whenComplete(
              () async => await AlarmServices().cancelHabitSchedules(ids),
            );
      } else {
        debugPrint('Habits box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> enableHabit(String id) async {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        final Habit? habit = habitsBox.get(id);
        if (habit != null) {
          if (habit.isEnabled) {
            final Habit updatedHabit = habit.copyWith(isEnabled: false);
            await habitsBox.put(id, updatedHabit).whenComplete(
                  () async => await AlarmServices().cancelHabitSchedule(id),
                );
          } else {
            final Habit updatedHabit = habit.copyWith(isEnabled: true);
            await habitsBox.put(id, updatedHabit).whenComplete(
                  () async => await AlarmServices().scheduleHabit(updatedHabit),
                );
          }
        }
      } else {
        debugPrint('Habits box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  Future<void> enableHabits(List<String> ids) async {
    try {
      final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isBoxOpened) {
        List<Habit> updatedHabits = [];
        Map<dynamic, Habit> updatedHabitsMap = {};
        final Box<Habit> habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        final habits = habitsBox.values.toList();
        for (Habit habit in habits) {
          if (ids.contains(habit.id)) {
            if (habit.isEnabled) {
              updatedHabits.add(habit.copyWith(isEnabled: false));
            } else {
              updatedHabits.add(habit.copyWith(isEnabled: true));
            }
          }
        }
        for (Habit habit in updatedHabits) {
          updatedHabitsMap[habit.id] = habit;
        }
        await habitsBox.putAll(updatedHabitsMap).whenComplete(
              () async => await AlarmServices().scheduleHabits(
                updatedHabits,
              ),
            );
      } else {
        debugPrint('Alarms box is closed!');
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
    }
  }

  @override
  List<Habit> getEnabledHabits() {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        List<Habit> enabledHabits = [];
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        final List<Habit> habits = habitsBox.values.toList();
        for (Habit habit in habits) {
          if (habit.isEnabled) {
            enabledHabits.add(habit);
          }
        }
        return enabledHabits;
      } else {
        debugPrint('Habits box is closed!');
        return [];
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
      return [];
    }
  }

  @override
  List<Habit> getHabits() {
    try {
      final bool isHabitBoxOpened = Hive.isBoxOpen(DatabaseHelper.habitsBox);
      if (isHabitBoxOpened) {
        final habitsBox = Hive.box<Habit>(DatabaseHelper.habitsBox);
        final List<Habit> habits = habitsBox.values.toList();
        return habits;
      } else {
        debugPrint('Habits box is closed!');
        return [];
      }
    } on Exception catch (e) {
      debugPrint('Exception: ${e.toString}!');
      return [];
    }
  }
}
