import 'package:flutter/material.dart';

import '../../../common/interval_widget.dart';

class IntervalPicker extends StatelessWidget {
  final ScrollController controller;
  final List<Map<int, String>> intervals;
  const IntervalPicker({
    super.key,
    required this.controller,
    required this.intervals,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 200,
        child: ListView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemCount: intervals.length,
          itemBuilder: (context, index) {
            final Map<int, String> interval = intervals[index];
            return IntervalWidget(
              interval: interval.keys.first,
              unit: interval.values.first,
            );
          },
        ));
  }
}
