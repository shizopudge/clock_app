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
          color: PalleteLight.actionColor,
        ),
      ),
      content: Text(
        'Do you want to exit an App?',
        style: AppFonts.labelStyle,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: PalleteLight.actionColor,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'No',
                style: AppFonts.labelStyle.copyWith(
                  color: PalleteLight.actionColor,
                ),
              ),
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
