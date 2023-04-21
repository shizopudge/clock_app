import 'package:flutter/material.dart';

import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const ActionButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        backgroundColor: Pallete.actionColor,
        padding: const EdgeInsets.all(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: AppFonts.titleStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
