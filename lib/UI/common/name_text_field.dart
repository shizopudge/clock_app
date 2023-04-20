import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_edit_alarm/add_edit_alarm_cubit.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class NameTextField extends StatelessWidget {
  final String hint;
  const NameTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;

  void _onChanged(String value, BuildContext context) =>
      context.read<AddEditAlarmCubit>().setName(value.trim());

  @override
  Widget build(BuildContext context) {
    final int textLength =
        context.watch<AddEditAlarmCubit>().state.name?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
      child: TextFormField(
        onChanged: (value) => _onChanged(value, context),
        maxLength: 40,
        style: AppFonts.titleStyle,
        cursorWidth: 1,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppFonts.titleStyle,
          errorStyle: AppFonts.labelStyle.copyWith(color: Colors.red),
          contentPadding: const EdgeInsets.all(
            4,
          ),
          errorText:
              textLength == 40 ? 'Maximum number of characters: 40' : null,
          counterText: '',
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: PalleteLight.actionColor,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: PalleteLight.actionColor,
            ),
          ),
        ),
      ),
    );
  }
}
