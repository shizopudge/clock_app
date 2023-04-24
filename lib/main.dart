import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'UI/base/controller/base_controller.dart';
import 'UI/base/view/base.dart';
import 'UI/pages/welcome/controller/welcome_controller.dart';
import 'UI/pages/welcome/view/welcome_view.dart';
import 'core/providers.dart';
import 'models/habit/habit.dart';
import 'repositories/alarms_repository.dart';
import 'repositories/habits_repository.dart';
import 'services/alarm_services.dart';
import 'services/app_launch_services.dart';
import 'services/notification_services.dart';
import 'storage/database.dart';
import 'theme/theme.dart';

@pragma('vm:entry-point')
void backgroundTask(String taskId) async {
  try {
    debugPrint("[BackgroundFetch] Event received $taskId");
    debugPrint('Schedule is running! ${DateTime.now()}');
    await DatabaseHelper.initDatabase();
    final bool isSettingsBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (isSettingsBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      final bool isFirstLaunch =
          settingsBox.get('isFirstLaunch', defaultValue: true);
      if (!isFirstLaunch) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'service_notifications_channel',
            title: 'Background services working',
            body: 'Scheduling...',
            category: NotificationCategory.Service,
            showWhen: true,
            locked: true,
          ),
        );
        await NotificationServices.initializeNotifications();
        final List<Habit> enabledHabits = HabitsRepository().getEnabledHabits();
        await AlarmServices().scheduleAlarms().whenComplete(
              () =>
                  debugPrint('Alarms scheduling is success! ${DateTime.now()}'),
            );
        await AlarmServices()
            .scheduleHabits(
              enabledHabits,
            )
            .whenComplete(
              () =>
                  debugPrint('Habits scheduling is success! ${DateTime.now()}'),
            );
        debugPrint('Schedule is stoping! ${DateTime.now()}');
        await AwesomeNotifications().cancel(1);
        debugPrint("[BackgroundFetch] Background task finished: $taskId");
        BackgroundFetch.finish(taskId);
      }
    }
  } on Exception catch (e) {
    debugPrint('ERROR! ${e.toString()}}');
    BackgroundFetch.finish(taskId);
  }
}

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    debugPrint("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  backgroundTask(taskId);
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppLaunchServices().onAppLaunch();
  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initBackgroundServices();
  }

  Future<void> initBackgroundServices() async {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: true,
          startOnBoot: true,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      backgroundTask(taskId);
    }, (String taskId) async {
      debugPrint("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...AppProviders.defaultProviders,
        ...AppProviders.alarmProviders,
        ...AppProviders.habitProviders,
      ],
      child: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseHelper.settingsBox).listenable(),
        builder: (context, settingsBox, _) {
          final String theme =
              settingsBox.get('theme', defaultValue: AppTheme.defaultTheme);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getCurrentTheme(settingsBox),
            home: settingsBox.get('isFirstLaunch', defaultValue: true)
                ? WelcomeView(
                    welcomeController: WelcomeController(),
                  )
                : Base(
                    baseController: BaseController(
                      alarmsRepository: AlarmsRepository(),
                      habitsRepository: HabitsRepository(),
                    ),
                    theme: theme,
                  ),
          );
        },
      ),
    );
  }
}
