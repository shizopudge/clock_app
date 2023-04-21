import '../../../../theme/theme.dart';

abstract class ISettingsController {
  void switchTheme(String theme);
}

class SettingsController extends ISettingsController {
  @override
  void switchTheme(String theme) async {
    await AppTheme.switchTheme(theme);
  }
}
