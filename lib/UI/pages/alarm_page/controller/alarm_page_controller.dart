import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../storage/database.dart';
import '../view/alarm_page_view.dart';

abstract class IAlarmPageController {
  Color lerpColorList(
    final List<Color> colors,
    final double t,
  );

  Future<void> action(BuildContext context, AudioPlayer player, Timer? timer);
}

class AlarmPageController extends IAlarmPageController {
  @override
  Color lerpColorList(
    final List<Color> colors,
    final double t,
  ) {
    assert(!t.isNaN, "Must be a number");
    assert(t >= 0 && t <= 1, "Value out of range");
    assert(colors.isNotEmpty, "Color list must not be empty");

    if (colors.length == 1) return colors.first;
    if (t == 1) return colors.last;

    double scaled = t * (colors.length - 1);

    Color firstColor = colors[scaled.floor()];
    Color secondColor = colors[(scaled + 1.0).floor()];

    return Color.lerp(
      firstColor,
      secondColor,
      scaled - scaled.floor(),
    )!;
  }

  @override
  Future<void> action(
      BuildContext context, AudioPlayer player, Timer? timer) async {
    timer?.cancel();
    context.read<AlarmPageViewCubit>().setOpacity(1.0);
    player.stop();
    final isBoxOpened = Hive.isBoxOpen(DatabaseHelper.settingsBox);
    if (!isBoxOpened) {
      await Hive.openBox(DatabaseHelper.settingsBox);
      final settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('isFromAlarm', false);
    } else {
      final settingsBox = Hive.box(DatabaseHelper.settingsBox);
      await settingsBox.put('isFromAlarm', false);
    }
    await Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    });
  }
}
