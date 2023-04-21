import 'package:flutter/material.dart';

class Pallete {
  static const Color actionColor = Color.fromRGBO(67, 180, 241, 1);
}

class PalleteLight {
  static const LinearGradient backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Color.fromRGBO(54, 0, 51, 1.0),
        Color.fromRGBO(11, 135, 147, 1.0),
      ]);

  static const LinearGradient alarmCardBg = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(16),
      colors: [
        Color.fromRGBO(58, 97, 134, 1.0),
        Color.fromRGBO(137, 37, 62, 1.0),
      ]);

  static const Color backgroundColor = Color.fromARGB(136, 64, 133, 179);
}

class PalleteDark {
  static final Color backgroundColor = Colors.grey.shade900;

  static const Color cardColor = Colors.black38;

  static const Color fullBlack = Colors.black;
}
