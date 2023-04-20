import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../../../theme/pallete.dart';

class Weekdays extends StatefulWidget {
  final String dayLetter;
  final String day;
  final TextStyle style;
  const Weekdays({
    super.key,
    required this.day,
    required this.style,
    required this.dayLetter,
  });

  @override
  State<Weekdays> createState() => _WeekdaysState();
}

class _WeekdaysState extends State<Weekdays> {
  late double _circleScale;

  @override
  void initState() {
    super.initState();
    if (_isDayAdded()) {
      _circleScale = 1;
    } else {
      _circleScale = 0;
    }
  }

  bool _isDayAdded() =>
      context.read<AddEditAlarmCubit>().state.weekdays.contains(widget.day);

  void _onTap() {
    if (_isDayAdded()) {
      _circleScale = 0;
      context.read<AddEditAlarmCubit>().removeDay(widget.day);
    } else {
      _circleScale = 1;
      context.read<AddEditAlarmCubit>().addDay(widget.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfTheWeek =
        context.watch<AddEditAlarmCubit>().state.weekdays;
    return InkWell(
      onTap: _onTap,
      radius: 50,
      splashColor: PalleteLight.actionColor,
      borderRadius: BorderRadius.circular(21),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedScale(
            curve: Curves.easeIn,
            scale: _circleScale,
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: daysOfTheWeek.contains(widget.day)
                    ? Border.all(
                        color: PalleteLight.actionColor,
                        width: 1.5,
                      )
                    : null,
              ),
            ),
          ),
          Text(
            widget.dayLetter,
            style: widget.style,
          ),
        ],
      ),
    );
  }
}
