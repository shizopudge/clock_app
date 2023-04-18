import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../storage/database.dart';
import 'fonts.dart';
import 'pallete.dart';

abstract class IAppTheme {
  Future<String> getTheme();
  Future<String> toggleTheme();
}

class AppTheme extends IAppTheme {
  static const String defaultTheme = 'dark';

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.greyColor,
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: Pallete.blueColor,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Pallete.fullBlackColor,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Pallete.fullBlackColor,
      contentTextStyle: AppFonts.labelStyle,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Pallete.fullBlackColor,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: AppFonts.labelStyle.copyWith(
        letterSpacing: 1.2,
      ),
      unselectedItemColor: Pallete.whiteColor,
      selectedItemColor: Pallete.blueColor,
      elevation: 0,
      unselectedIconTheme: const IconThemeData(
        color: Colors.white,
        opacity: .85,
      ),
      selectedIconTheme: IconThemeData(
        color: Pallete.blueColor,
        opacity: 1,
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData.light();

  @override
  Future<String> getTheme() async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (isBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      final String theme =
          await settingsBox.get('theme', defaultValue: defaultTheme);
      return theme;
    } else {
      return defaultTheme;
    }
  }

  @override
  Future<String> toggleTheme() async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (isBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      final String theme =
          await settingsBox.get('theme', defaultValue: defaultTheme);
      if (theme == 'dark') {
        await settingsBox.put('theme', 'light');
      } else {
        await settingsBox.put('theme', 'dark');
      }
      return theme;
    } else {
      return defaultTheme;
    }
  }
}
