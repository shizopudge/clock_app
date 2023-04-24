import 'dart:async';

import 'package:alarm_app/bloc/timer/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../bloc/timer_picker/timer_picker_cubit.dart';

abstract class ITimerController {
  void onHourChanged(BuildContext context, int hour);

  void onMinuteChanged(BuildContext context, int minute);

  void onSecondChanged(BuildContext context, int second);

  void startTimer(
      BuildContext context, int seconds, ValueNotifier<double> valueNotifier);

  void resumeTimer(BuildContext context, ValueNotifier<double> valueNotifier);

  void endTimer(BuildContext context, AudioPlayer player);

  void stopAlarm(BuildContext context, ValueNotifier<double> valueNotifier,
      AudioPlayer player);

  void pauseTimer(BuildContext context, ValueNotifier<double> valueNotifier);

  void reset(BuildContext context);
}

class TimerController extends ITimerController {
  Timer? _timer;

  @override
  void onHourChanged(BuildContext context, int hour) {
    context.read<TimerPickerCubit>().setHour(hour);
  }

  @override
  void onMinuteChanged(BuildContext context, int minute) {
    context.read<TimerPickerCubit>().setMinute(minute);
  }

  @override
  void onSecondChanged(BuildContext context, int second) {
    context.read<TimerPickerCubit>().setSecond(second + 5);
  }

  @override
  void startTimer(
      BuildContext context, int seconds, ValueNotifier<double> valueNotifier) {
    context.read<TimerCubit>().startTimer(seconds);
    _timer?.cancel();
    _timer = Timer.periodic(
        const Duration(milliseconds: 1000), (timer) => valueNotifier.value++);
  }

  @override
  void resumeTimer(BuildContext context, ValueNotifier<double> valueNotifier) {
    context.read<TimerCubit>().resumeTimer();
    _timer?.cancel();
    _timer = Timer.periodic(
        const Duration(milliseconds: 1000), (timer) => valueNotifier.value++);
  }

  @override
  void endTimer(BuildContext context, AudioPlayer player) {
    context.read<TimerCubit>().endTimer();
    _timer?.cancel();
    player.play();
  }

  @override
  void stopAlarm(BuildContext context, ValueNotifier<double> valueNotifier,
      AudioPlayer player) {
    _timer?.cancel();
    valueNotifier.value = 0.0;
    player.stop();
    context.read<TimerCubit>().stopAlarm();
  }

  @override
  void pauseTimer(BuildContext context, ValueNotifier<double> valueNotifier) {
    context.read<TimerCubit>().pauseTimer();
    _timer?.cancel();
  }

  @override
  void reset(BuildContext context) {
    context.read<TimerPickerCubit>().reset();
  }
}
