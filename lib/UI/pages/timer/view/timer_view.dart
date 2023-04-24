import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../../bloc/timer/timer_cubit.dart';
import '../../../../bloc/timer_picker/timer_picker_cubit.dart';
import '../../../../core/enums.dart';
import '../../../../core/utils.dart';
import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';
import '../../../common/action_button.dart';
import '../controller/timer_controller.dart';
import '../widgets/timer_picker.dart';

class TimerView extends StatefulWidget {
  final TimerController _timerController;
  const TimerView({super.key, required TimerController timerController})
      : _timerController = timerController;

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final ValueNotifier<double> valueNotifier = ValueNotifier<double>(0.0);
  late final AudioPlayer _player;
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late final FixedExtentScrollController _secondController;

  @override
  void initState() {
    super.initState();
    _hourController = FixedExtentScrollController();
    _minuteController = FixedExtentScrollController();
    _secondController = FixedExtentScrollController();
    _player = AudioPlayer()
      ..setAsset('assets/audio/alarm.mp3')
      ..setLoopMode(LoopMode.one);
    valueNotifier.addListener(() {
      final int duration = context.read<TimerCubit>().state.duration;
      if (valueNotifier.value == duration.toDouble()) {
        widget._timerController.endTimer(context, _player);
        widget._timerController.reset(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerPickerState = context.watch<TimerPickerCubit>().state;
    final timerState = context.watch<TimerCubit>().state;
    final int currentHour = timerPickerState.hour;
    final int currentMinute = timerPickerState.minute;
    final int currentSecond = timerPickerState.second;
    final int totalSeconds = AppUtils.convertTimerToSeconds(
      hour: currentHour,
      minute: currentMinute,
      second: currentSecond,
    );
    final double sreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timerState.status == TimerStatus.stopped)
              Expanded(
                child: TimerPicker(
                  hourController: _hourController,
                  minuteController: _minuteController,
                  secondController: _secondController,
                  onHourChanged: (hour) =>
                      widget._timerController.onHourChanged(context, hour),
                  onMinuteChanged: (minute) =>
                      widget._timerController.onMinuteChanged(context, minute),
                  onSecondChanged: (second) =>
                      widget._timerController.onSecondChanged(context, second),
                  currentHour: currentHour,
                  currentMinute: currentMinute,
                  currentSecond: currentSecond,
                ),
              )
            else
              Column(
                children: [
                  if (timerState.status == TimerStatus.running)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      child: AppUtils.convertSecondsBeforeTimerAlarm(
                        secondsBeforeTimerAlarm: timerState.duration,
                        fontSize: 30,
                        isPassed: false,
                      ),
                    )
                  else if (timerState.status == TimerStatus.paused)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      child: Text(
                        'Paused',
                        textAlign: TextAlign.center,
                        style: AppFonts.labelStyle.copyWith(
                          color: Pallete.actionColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    )
                  else if (timerState.status == TimerStatus.alarm)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      child: Text(
                        'Timer completed',
                        textAlign: TextAlign.center,
                        style: AppFonts.labelStyle.copyWith(
                          color: Pallete.actionColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: SimpleCircularProgressBar(
                      progressColors: const [
                        Pallete.actionColor,
                      ],
                      progressStrokeWidth: 25,
                      backStrokeWidth: 25,
                      animationDuration: 3,
                      mergeMode: true,
                      size: sreenHeight / 2.5,
                      backColor: Colors.blueGrey,
                      maxValue: timerState.duration.toDouble(),
                      valueNotifier: valueNotifier,
                      onGetText: (_) {
                        return AppUtils.convertSecondsBeforeTimerAlarm(
                          secondsBeforeTimerAlarm: valueNotifier.value.toInt(),
                          fontSize: 24,
                          isPassed: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (timerState.status == TimerStatus.stopped)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ActionButton(
                  onTap: () => widget._timerController
                      .startTimer(context, totalSeconds, valueNotifier),
                  text: 'Start',
                ),
              ),
            if (timerState.status == TimerStatus.paused)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ActionButton(
                      onTap: () => widget._timerController
                          .resumeTimer(context, valueNotifier),
                      text: 'Resume',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ActionButton(
                      onTap: () {
                        widget._timerController
                            .stopAlarm(context, valueNotifier, _player);
                        widget._timerController.reset(context);
                      },
                      text: 'Cancel',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            if (timerState.status == TimerStatus.running)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ActionButton(
                      onTap: () => widget._timerController
                          .pauseTimer(context, valueNotifier),
                      text: 'Pause',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ActionButton(
                      onTap: () {
                        widget._timerController
                            .stopAlarm(context, valueNotifier, _player);
                        widget._timerController.reset(context);
                      },
                      text: 'Cancel',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            if (timerState.status == TimerStatus.alarm)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ActionButton(
                  onTap: () {
                    widget._timerController
                        .stopAlarm(context, valueNotifier, _player);
                    widget._timerController.reset(context);
                  },
                  text: 'Stop',
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
