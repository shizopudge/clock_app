import '../../../../theme/theme.dart';

abstract class ISettingsController {
  void toggleTheme();
}

class SettingsController extends ISettingsController {
  @override
  void toggleTheme() async {
    await AppTheme.toggleTheme();
  }
}
