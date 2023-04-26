import 'package:flutter/material.dart';

class Pallete {
  static final Pallete _pallete = Pallete._internal();

  factory Pallete() {
    return _pallete;
  }

  Pallete._internal();

  static const Color actionColor = Color.fromRGBO(67, 180, 241, 1);
}

class PalleteLight {
  static final PalleteLight _palleteLight = PalleteLight._internal();

  factory PalleteLight() {
    return _palleteLight;
  }

  PalleteLight._internal();

  static const LinearGradient backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Color.fromRGBO(54, 0, 51, 1.0),
        Color.fromRGBO(11, 135, 147, 1.0),
      ]);

  static const primaryColor = Colors.white10;

  static const Color backgroundColor = Color.fromARGB(136, 64, 133, 179);
}

class PalleteDark {
  static final PalleteDark _palleteDark = PalleteDark._internal();

  factory PalleteDark() {
    return _palleteDark;
  }

  PalleteDark._internal();

  static final Color backgroundColor = Colors.grey.shade900;

  static const Color cardColor = Colors.black38;

  static const Color fullBlack = Colors.black;
}
