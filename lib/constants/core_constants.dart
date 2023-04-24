import '../UI/pages/add_edit_alarm/controller/add_edit_alarm_controller.dart';
import '../UI/pages/add_edit_habit/controller/add_edit_habit_controller.dart';
import '../UI/pages/alarm/alarm_controller/alarm_controller.dart';
import '../UI/pages/habit/controller/habit_controller.dart';
import '../UI/pages/settings/controller/settings_controller.dart';
import '../UI/pages/timer/controller/timer_controller.dart';
import '../repositories/alarms_repository.dart';
import '../repositories/habits_repository.dart';

class CoreConstants {
  static final alarmRepository = AlarmsRepository();

  static final habitRepository = HabitsRepository();

  static final settingsController = SettingsController();

  static final timerController = TimerController();

  static final alarmController =
      AlarmController(alarmsRepository: alarmRepository);

  static final addEditAlarmController = AddEditAlarmController(
    alarmsRepository: alarmRepository,
  );

  static final habitController =
      HabitController(habitsRepository: habitRepository);

  static final addEditHabitController =
      AddEditHabitController(habitsRepository: habitRepository);
}
