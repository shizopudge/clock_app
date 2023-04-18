import 'package:flutter/material.dart';

import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      title: Text(
        'Are you sure?',
        style: AppFonts.headerStyle.copyWith(
          color: Pallete.blueColor,
        ),
      ),
      content: Text(
        'Do you want to exit an App?',
        style: AppFonts.labelStyle,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: Text(
            'No',
            style: AppFonts.labelStyle.copyWith(
              color: Pallete.blueColor,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(true),
          icon: Text(
            'Yes',
            style: AppFonts.labelStyle,
          ),
        ),
      ],
    );
  }
}
