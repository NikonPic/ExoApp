import 'package:flutter/material.dart';

class CalibInfoText extends StatelessWidget {
  const CalibInfoText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalibText(
          text:
              'In order to calibrate the Sensorsystem properly please follow the following steps:',
        ),
        SizedBox(
          height: 10,
        ),
        CalibText(
          text: '1. Start recording',
        ),
        CalibText(
          text: '2. After 5 seconds change the position of the sensorsystem',
        ),
        CalibText(
          text: '3. Repeat step 2 until 20 counts have been reached.',
        ),
        CalibText(
          text: '4. Stop recording and start calibration calculation',
        )
      ],
    );
  }
}

class CalibText extends StatelessWidget {
  const CalibText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
    );
  }
}
