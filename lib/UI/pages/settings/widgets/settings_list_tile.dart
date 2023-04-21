import 'package:flutter/material.dart';

import '../../../../theme/fonts.dart';

class SettingsListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String currentSetting;
  final IconData icon;
  const SettingsListTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.currentSetting,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        leading: Icon(
          icon,
          size: 32,
        ),
        title: Text(
          title,
          style: AppFonts.titleStyle,
        ),
        subtitle: Text(
          currentSetting,
          style: AppFonts.titleStyle,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 21,
        ),
      ),
    );
  }
}
