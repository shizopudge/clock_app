import 'package:flutter/material.dart';

import '../../../../theme/fonts.dart';
import '../../../../theme/pallete.dart';
import '../../../common/save_button.dart';
import '../controller/welcome_controller.dart';

class WelcomeView extends StatelessWidget {
  final WelcomeController _welcomeController;
  const WelcomeView({super.key, required WelcomeController welcomeController})
      : _welcomeController = welcomeController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: PalleteLight.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/alarm3D.png',
              ),
              Text(
                'Welcome',
                style:
                    AppFonts.headerStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Thanks for installing my app. This app has alarm functionality, habit tracker and timer, hope you enjoy it. I wish you a pleasant use!',
                  textAlign: TextAlign.justify,
                  style:
                      AppFonts.titleStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ActionButton(
                onTap: _welcomeController.onLetsStartTap,
                text: 'Lets start!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
