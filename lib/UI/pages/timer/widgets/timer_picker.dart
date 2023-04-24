import 'package:flutter/material.dart';

import '../../../common/dots.dart';
import '../../../common/time_wheel.dart';
import '../../../common/time_widget.dart';

class TimerPicker extends StatelessWidget {
  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;
  final FixedExtentScrollController secondController;
  final int currentHour;
  final int currentMinute;
  final int currentSecond;
  final void Function(int) onHourChanged;
  final void Function(int) onMinuteChanged;
  final void Function(int) onSecondChanged;
  const TimerPicker(
      {super.key,
      required this.hourController,
      required this.minuteController,
      required this.secondController,
      required this.onHourChanged,
      required this.onMinuteChanged,
      required this.onSecondChanged,
      required this.currentHour,
      required this.currentMinute,
      required this.currentSecond});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 75,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: Colors.white12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeWheel(
                isFromTimer: true,
                onChanged: onHourChanged,
                currentTime: 1,
                scrollController: hourController,
                children: List<Widget>.generate(
                  100,
                  (index) => currentHour == index
                      ? TimeWidget(
                          time: index,
                        )
                      : Opacity(
                          opacity: .3,
                          child: TimeWidget(
                            time: index,
                          ),
                        ),
                ),
              ),
              const Dots(),
              TimeWheel(
                isFromTimer: true,
                onChanged: onMinuteChanged,
                currentTime: 0,
                scrollController: minuteController,
                children: List<Widget>.generate(
                  60,
                  (index) => currentMinute == index
                      ? TimeWidget(
                          time: index,
                        )
                      : Opacity(
                          opacity: .3,
                          child: TimeWidget(
                            time: index,
                          ),
                        ),
                ),
              ),
              const Dots(),
              TimeWheel(
                isFromTimer: true,
                onChanged: onSecondChanged,
                currentTime: 0,
                scrollController: secondController,
                children: List<Widget>.generate(60, (index) {
                  if (currentSecond == index) {
                    return TimeWidget(
                      time: index,
                    );
                  } else {
                    return Opacity(
                      opacity: .3,
                      child: TimeWidget(
                        time: index,
                      ),
                    );
                  }
                })
                  ..removeRange(0, 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
