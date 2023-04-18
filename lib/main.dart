import 'package:alarm_app/services/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UI/base.dart';
import 'bloc/settings/settings_cubit.dart';
import 'core/providers.dart';
import 'services/notification_services.dart';
import 'storage/database.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  await NotificationServices.initializeNotifications();
  // await workmanagerInitialize();
  await WorkManagerHeleper.workmanagerInitialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...AppProviders.blocs,
        ...AppProviders.cubits,
      ],
      child: BlocSelector<SettingsCubit, SettingsState, String>(
        selector: (state) => state.theme,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state == 'dark' ? AppTheme.darkTheme : AppTheme.lightTheme,
            home: const Base(),
          );
        },
      ),
    );
  }
}
