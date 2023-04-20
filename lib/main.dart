import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'UI/base.dart';
import 'UI/pages/welcome/view/welcome_view.dart';
import 'core/providers.dart';
import 'repositories/alarms_repository.dart';
import 'services/app_launch_services.dart';
import 'services/notification_services.dart';
import 'services/workmanager.dart';
import 'storage/database.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  await NotificationServices.initializeNotifications();
  await WorkManagerHeleper.workmanagerInitialize();
  await AppLaunchServices.onAppLaunch();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...AppProviders.cubits,
      ],
      child: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseHelper.settingsBox).listenable(),
        builder: (context, box, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:
                box.get('theme', defaultValue: AppTheme.defaultTheme) == 'dark'
                    ? AppTheme.darkTheme
                    : AppTheme.lightTheme,
            home: box.get('isFirstLaunch', defaultValue: true)
                ? const WelcomeView()
                : Base(
                    alarmsRepository: AlarmsRepository(),
                  ),
          );
        },
      ),
    );
  }
}
