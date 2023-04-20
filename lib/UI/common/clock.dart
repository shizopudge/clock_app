import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dart:async';

import '../../storage/database.dart';
import '../../theme/fonts.dart';
import 'time_widget.dart';

class ClockCubit extends Cubit<DateTime> {
  ClockCubit() : super(DateTime.now());

  void startClock() =>
      Timer.periodic(const Duration(milliseconds: 1000), _tick);

  void _tick(Timer timer) => emit(DateTime.now());
}

class Clock extends StatelessWidget {
  const Clock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime time = context.watch<ClockCubit>().state;
    final String? timezone = Hive.box(DatabaseHelper.settingsBox)
        .get('timezone', defaultValue: null);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeWidget(
              time: time.hour,
            ),
            Text(
              ':',
              style: AppFonts.timeStyle.copyWith(color: Colors.white),
            ),
            TimeWidget(
              time: time.minute,
            ),
            Text(
              ':',
              style: AppFonts.timeStyle.copyWith(color: Colors.white),
            ),
            TimeWidget(
              time: time.second,
            ),
          ],
        ),
        if (timezone != null)
          Text(
            'Timezone: $timezone',
            style: AppFonts.labelStyle,
          ),
      ],
    );
  }
}
