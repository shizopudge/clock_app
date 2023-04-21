import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_edit_habit/add_edit_habit_cubit.dart';
import '../../theme/fonts.dart';
import '../../theme/pallete.dart';

class DescriptionTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const DescriptionTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  void _onChanged(String value, BuildContext context) {
    context.read<AddEditHabitCubit>().setDescription(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final int textLength =
        context.watch<AddEditHabitCubit>().state.description?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
      child: TextFormField(
        onChanged: (value) => _onChanged(value, context),
        maxLength: 200,
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
              textLength == 200 ? 'Maximum number of characters: 200' : null,
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
