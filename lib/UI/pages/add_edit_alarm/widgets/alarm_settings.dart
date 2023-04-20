import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../constants/ui_constants.dart';
import '../../../../storage/database.dart';
import '../../../../theme/pallete.dart';
import '../../../../theme/theme.dart';
import '../../../common/name_text_field.dart';
import '../../../common/save_button.dart';

class AlarmSettings extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onSave;
  const AlarmSettings({
    super.key,
    required this.nameController,
    required this.onSave,
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
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: UIConstants.daysOfTheWeek(),
            ),
          ),
          NameTextField(
            controller: nameController,
            hint: 'Alarm name',
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
