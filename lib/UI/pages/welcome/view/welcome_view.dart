import 'package:flutter/material.dart';

import '../../../../theme/fonts.dart';
import '../../../common/action_button.dart';
import '../controller/welcome_controller.dart';

class WelcomeView extends StatelessWidget {
  final WelcomeController _welcomeController;
  const WelcomeView({super.key, required WelcomeController welcomeController})
      : _welcomeController = welcomeController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: AppFonts.timeStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Thanks for installing my app. This app has alarm functionality, habit tracker and timer, hope you enjoy it.',
                textAlign: TextAlign.center,
                style: AppFonts.titleStyle,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'I wish you a pleasant use!',
                textAlign: TextAlign.center,
                style: AppFonts.titleStyle,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ActionButton(
              onTap: _welcomeController.onLetsStartTap,
              text: 'Lets start!',
            ),
          ],
        ),
      ),
    );
  }
}
