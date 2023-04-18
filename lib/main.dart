import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UI/base.dart';
import 'bloc/settings/settings_cubit.dart';
import 'core/providers.dart';
import 'repositories/alarms_repository.dart';
import 'services/notification_services.dart';
import 'services/workmanager.dart';
import 'storage/database.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  await NotificationServices.initializeNotifications();
  await WorkManagerHeleper.workmanagerInitialize();
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
      child: BlocSelector<SettingsCubit, SettingsState, String>(
        selector: (state) => state.theme,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state == 'dark' ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: Base(
              alarmsRepository: AlarmsRepository(),
            ),
          );
        },
      ),
    );
  }
}
