import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  const Dots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          radius: 3,
          backgroundColor: Colors.white,
        ),
        SizedBox(
          height: 15,
        ),
        CircleAvatar(
          radius: 3,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}
