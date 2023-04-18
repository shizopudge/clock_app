import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/edit_alarms/edit_alarms_cubit.dart';
import '../../../../theme/fonts.dart';

class AlarmPopup extends StatelessWidget {
  const AlarmPopup({super.key});

  static void _onEditTap(BuildContext context) =>
      context.read<EditAlarmsCubit>().toggleEditMode();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => _onEditTap(context),
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.edit,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Edit',
              ),
            ],
          ),
        ),
        PopupMenuItem(
          textStyle: AppFonts.labelStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.sort,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Sort',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
