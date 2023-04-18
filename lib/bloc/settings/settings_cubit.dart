import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils.dart';
import '../../theme/theme.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void getTheme() async {
    final String theme = await AppTheme().getTheme();
    emit(state.copyWith(theme: theme));
  }

  void toggleTheme() async {
    final String theme = await AppTheme().toggleTheme();
    emit(state.copyWith(theme: theme));
  }

  void getCurrentTimeZone() async {
    final String timezone = await AppUtils.getCurrentTimeZone();
    emit(state.copyWith(timezone: timezone));
  }
}
