import 'package:flutter/material.dart';

import '../../../common/dots.dart';
import '../../../common/time_wheel.dart';
import '../../../common/time_widget.dart';

class AlarmPicker extends StatelessWidget {
  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;
  final int currentHour;
  final int currentMinute;
  final void Function(int) onHourChanged;
  final void Function(int) onMinuteChanged;
  const AlarmPicker({
    super.key,
    required this.hourController,
    required this.minuteController,
    required this.currentHour,
    required this.currentMinute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

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
                isFromTimer: false,
                onChanged: onHourChanged,
                currentTime: currentHour,
                scrollController: hourController,
                children: List<Widget>.generate(
                  24,
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
                isFromTimer: false,
                onChanged: onMinuteChanged,
                currentTime: currentMinute,
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
            ],
          ),
        ],
      ),
    );
  }
}
