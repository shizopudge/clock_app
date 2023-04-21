import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pallete.dart';

class AppFonts {
  static final TextStyle headerStyle = GoogleFonts.lato(
    fontSize: 25,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle titleStyle = GoogleFonts.lato(
    fontSize: 18,
  );

  static final TextStyle labelStyle = GoogleFonts.lato(
    fontSize: 14,
  );

  static final TextStyle timeStyle = GoogleFonts.lato(
    fontSize: 55,
    fontWeight: FontWeight.bold,
    color: Pallete.actionColor,
  );
}
