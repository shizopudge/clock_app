import 'package:flutter/material.dart';

class TimeWheel extends StatelessWidget {
  final int currentTime;
  final List<Widget> children;
  final FixedExtentScrollController scrollController;
  final Function(int) onChanged;
  final bool isFromTimer;
  const TimeWheel({
    super.key,
    required this.currentTime,
    required this.children,
    required this.scrollController,
    required this.onChanged,
    required this.isFromTimer,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFromTimer ? 80 : 150,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: onChanged,
        controller: scrollController,
        itemExtent: 100,
        perspective: 0.003,
        diameterRatio: 10,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildLoopingListDelegate(
          children: children,
        ),
      ),
    );
  }
}
