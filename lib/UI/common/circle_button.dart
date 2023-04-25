import 'package:flutter/material.dart';

import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double padding;
  final Color? color;
  const CircleButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color ?? Pallete.actionColor,
        padding: EdgeInsets.all(padding),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: AppFonts.headerStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
