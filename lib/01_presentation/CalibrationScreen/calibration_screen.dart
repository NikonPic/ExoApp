import 'package:blueapp/01_presentation/CalibrationScreen/widgets/info_text.dart';
import 'package:blueapp/01_presentation/FindDevicesScreen/find_devices_screen.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CalibrationScreen extends StatelessWidget {
  final BluetoothDevice myDevice;
  final BluetoothCharacteristic myChar;
  final String name;

  const CalibrationScreen(
      {Key? key,
      required this.myDevice,
      required this.myChar,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    myChar.setNotifyValue(true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          children: [
            InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () async {
                await myDevice.disconnect();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindDevicesScreen(name: name),
                    ),
                    (route) => false);
              },
            ),
            Spacer(),
            Text('Perform Calibration'),
            Spacer(),
            InkWell(
              child: Icon(Icons.info),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: CalibInfoText(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CalibInfoText(),
            ],
          ),
        ),
      ),
    );
  }
}
