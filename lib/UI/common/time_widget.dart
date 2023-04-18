import 'package:flutter/material.dart';

import '../../theme/fonts.dart';

class TimeWidget extends StatelessWidget {
  final int time;
  final Color? color;
  const TimeWidget({
    super.key,
    required this.time,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          time < 10 ? '0$time' : time.toString(),
          style: color != null
              ? AppFonts.timeStyle.copyWith(color: color)
              : AppFonts.timeStyle,
        ),
      ),
    );
  }
}
