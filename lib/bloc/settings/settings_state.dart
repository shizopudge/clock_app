part of 'settings_cubit.dart';

class SettingsState {
  final String theme;
  final String? timezone;

  SettingsState({
    this.theme = AppTheme.defaultTheme,
    this.timezone,
  });

  SettingsState copyWith({
    String? theme,
    String? timezone,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      timezone: timezone ?? this.timezone,
    );
  }
}
