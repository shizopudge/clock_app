import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../../../theme/fonts.dart';

class AlarmPopup extends StatelessWidget {
  const AlarmPopup({super.key});

  static void _onEditTap(BuildContext context) =>
      context.read<AlarmViewCubit>().toggleEditMode();

  static void _onSortTap(BuildContext context) =>
      context.read<AlarmViewCubit>().setSortType();

  @override
  Widget build(BuildContext context) {
    final SortType sort = context.watch<AlarmViewCubit>().state.sort;
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      itemBuilder: (context) => [
        if (!alarmViewState.isEditMode)
          PopupMenuItem(
            onTap: () => _onEditTap(context),
            textStyle: AppFonts.labelStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.edit,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Edit',
                  style: AppFonts.labelStyle,
                ),
              ],
            ),
          ),
        PopupMenuItem(
          onTap: () => _onSortTap(context),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (sort == SortType.ascending)
                const Icon(
                  Icons.arrow_downward_rounded,
                )
              else
                const Icon(
                  Icons.arrow_upward_rounded,
                ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Sort',
                style: AppFonts.labelStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
