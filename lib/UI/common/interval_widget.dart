import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_edit_habit/add_edit_habit_cubit.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class IntervalWidget extends StatelessWidget {
  final int interval;
  final String unit;
  const IntervalWidget({
    super.key,
    required this.interval,
    required this.unit,
  });

  void _onTap(BuildContext context) =>
      context.read<AddEditHabitCubit>().setInterval(interval);

  @override
  Widget build(BuildContext context) {
    final int currentInterval =
        context.watch<AddEditHabitCubit>().state.interval;
    final int computedInterval;
    if (interval < 3600) {
      computedInterval = interval ~/ 60;
    } else if (interval >= 3600 && interval < 86400) {
      computedInterval = interval ~/ 3600;
    } else {
      computedInterval = interval ~/ 86400;
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: PalleteDark.actionColor,
        ),
        color: currentInterval == interval ? PalleteDark.actionColor : null,
      ),
      margin: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(21),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Text(
              '$computedInterval\n$unit',
              textAlign: TextAlign.center,
              style: AppFonts.headerStyle.copyWith(fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }
}
