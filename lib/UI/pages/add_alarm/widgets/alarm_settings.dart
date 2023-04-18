import 'package:flutter/material.dart';

import '../../../../constants/ui_constants.dart';
import '../../../../theme/pallete.dart';
import '../../../common/name_text_field.dart';
import '../../../common/save_button.dart';

class AlarmSettings extends StatelessWidget {
  final TextEditingController nameController;
  final bool isAddAlarm;
  final VoidCallback onSave;
  const AlarmSettings({
    super.key,
    required this.nameController,
    required this.isAddAlarm,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
        color: Pallete.blackColor,
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
                SaveButton(
                  onTap: onSave,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
