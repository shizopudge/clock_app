import '../UI/pages/alarm/alarm_controller/alarm_controller.dart';
import '../UI/pages/habits/controller/habit_controller.dart';
import '../UI/pages/settings/controller/settings_controller.dart';
import '../repositories/alarms_repository.dart';
import '../repositories/habits_repository.dart';

class CoreConstants {
  static final alarmRepository = AlarmsRepository();

  static final habitRepository = HabitsRepository();

  static final settingsController = SettingsController();

  static final alarmController =
      AlarmController(alarmsRepository: alarmRepository);

  static final habitController =
      HabitController(habitsRepository: habitRepository);
}
