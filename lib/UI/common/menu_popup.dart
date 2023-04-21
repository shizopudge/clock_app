import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/alarm_view/alarm_view_cubit.dart';
import '../../bloc/habit_view/habit_view_cubit.dart';
import '../../core/enums.dart';
import '../../core/router.dart';
import '../../theme/fonts.dart';

class MenuPopup extends StatelessWidget {
  final bool isListEmpty;
  final bool isAlarm;
  const MenuPopup({
    super.key,
    required this.isListEmpty,
    required this.isAlarm,
  });

  void _onEditTap(BuildContext context) {
    if (isAlarm) {
      context.read<AlarmViewCubit>().toggleEditMode();
    } else {
      context.read<HabitViewCubit>().toggleEditMode();
    }
  }

  void _onSortTap(BuildContext context) {
    if (isAlarm) {
      context.read<AlarmViewCubit>().setSortType();
    } else {
      context.read<HabitViewCubit>().setSortType();
    }
  }

  static void _onSettingsTap(BuildContext context) =>
      AppRouter.navigateWithSlideTransition(context, AppRouter.settingsPage);

  @override
  Widget build(BuildContext context) {
    final SortType sort = context.watch<AlarmViewCubit>().state.sort;
    final AlarmViewCubitState alarmViewState =
        context.watch<AlarmViewCubit>().state;
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'settings') {
          _onSettingsTap(context);
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      padding: const EdgeInsets.all(0),
      icon: const Icon(
        Icons.more_vert_rounded,
        size: 32,
      ),
      elevation: 4,
      itemBuilder: (context) => [
        if (!alarmViewState.isEditMode && !isListEmpty)
          PopupMenuItem(
            onTap: () => _onEditTap(context),
            textStyle: AppFonts.labelStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
        if (!isListEmpty)
          PopupMenuItem(
            onTap: () => _onSortTap(context),
            textStyle: AppFonts.labelStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
        PopupMenuItem(
          value: 'settings',
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.settings,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Settings',
                style: AppFonts.labelStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
