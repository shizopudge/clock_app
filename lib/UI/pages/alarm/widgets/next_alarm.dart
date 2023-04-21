import 'package:flutter/material.dart';

import '../../../../core/utils.dart';
import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';

class NextAlarm extends StatelessWidget {
  final int secondsBeforeNextAlarm;
  final String text;
  const NextAlarm({
    super.key,
    this.secondsBeforeNextAlarm = 0,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return RichText(
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: 'Alarm clock in ',
          style: AppFonts.titleStyle,
          children: [
            TextSpan(
              text:
                  AppUtils.formatSecondsBeforeNextAlarm(secondsBeforeNextAlarm),
              style: AppFonts.titleStyle.copyWith(
                color: Pallete.actionColor,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        style: AppFonts.titleStyle,
      );
    }
  }
}
