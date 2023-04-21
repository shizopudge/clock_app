import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../storage/database.dart';
import 'fonts.dart';
import 'pallete.dart';

class AppTheme {
  static final AppTheme _appTheme = AppTheme._internal();

  factory AppTheme() {
    return _appTheme;
  }

  AppTheme._internal();

  static const String defaultTheme = 'dark';

  static const String darkThemeName = 'dark';
  static const String lightThemeName = 'light';

  static final ThemeData lightTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: PalleteLight.actionColor,
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thumbColor: MaterialStatePropertyAll(PalleteLight.actionColor),
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: PalleteLight.backgroundColor,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: PalleteLight.backgroundColor,
    ),
    iconTheme: const IconThemeData(
      color: PalleteLight.actionColor,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: PalleteLight.actionColor,
      contentTextStyle: AppFonts.labelStyle,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(-12),
          bottomRight: Radius.circular(-12),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: AppFonts.labelStyle.copyWith(
        letterSpacing: 1.2,
      ),
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: PalleteDark.backgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: PalleteLight.actionColor,
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thumbColor: MaterialStatePropertyAll(PalleteLight.actionColor),
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: PalleteDark.cardColor,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: PalleteDark.backgroundColor,
    ),
    cardColor: PalleteDark.cardColor,
    iconTheme: const IconThemeData(
      color: PalleteLight.actionColor,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: PalleteDark.fullBlack,
      contentTextStyle: AppFonts.labelStyle,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(-12),
          bottomRight: Radius.circular(-12),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: PalleteDark.fullBlack,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: AppFonts.labelStyle.copyWith(
        letterSpacing: 1.2,
      ),
      elevation: 0,
    ),
  );

  static Future<void> switchTheme(String theme) async {
    final bool isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (isBoxOpened) {
      final Box settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('theme', theme);
    }
  }

  static ThemeData getCurrentTheme(Box settingsBox) {
    final String currentTheme =
        settingsBox.get('theme', defaultValue: defaultTheme);
    if (currentTheme == darkThemeName) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }
}
