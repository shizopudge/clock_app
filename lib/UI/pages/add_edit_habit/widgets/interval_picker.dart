import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/interval_widget.dart';

class IntervalPickerCubit extends Cubit<int> {
  IntervalPickerCubit() : super(0);

  void setItemIndex(int index) => emit(index);
}

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
      ),
    );
  }
}
