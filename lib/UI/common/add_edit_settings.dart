import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/ui_utils.dart';
import '../../storage/database.dart';
import '../../theme/pallete.dart';
import '../../theme/theme.dart';
import 'description_text_field.dart';
import 'name_text_field.dart';
import 'action_button.dart';

class AddEditSettings extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController? descriptionController;
  final VoidCallback onSave;
  final String nameHintText;
  final bool isAlarm;
  const AddEditSettings({
    super.key,
    required this.nameController,
    required this.onSave,
    required this.isAlarm,
    required this.nameHintText,
    this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    final String theme = Hive.box(DatabaseHelper.settingsBox)
        .get('theme', defaultValue: AppTheme.defaultTheme);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        color: theme == AppTheme.darkThemeName ? PalleteDark.fullBlack : null,
        gradient:
            theme == AppTheme.lightThemeName ? PalleteLight.alarmCardBg : null,
      ),
      child: Column(
        children: [
          if (isAlarm)
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: UIUtils.daysOfTheWeek(isAlarm: isAlarm),
              ),
            ),
          NameTextField(
            controller: nameController,
            isAlarm: isAlarm,
            hint: nameHintText,
          ),
          if (!isAlarm && descriptionController != null)
            DescriptionTextField(
              controller: descriptionController!,
              hint: 'Habit description',
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                ActionButton(
                  onTap: onSave,
                  text: 'Save',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
