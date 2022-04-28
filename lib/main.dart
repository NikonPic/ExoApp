import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '01_presentation/BluetoothOffScreen/bluetooth_off_screen.dart';
import '01_presentation/FindDevicesScreen/find_devices_screen.dart';
import '01_presentation/login/login.dart';

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          appBarTheme: AppBarTheme(color: kPrimaryColor)),
      color: kPrimaryColor,
      home: LoginWithName(),
    );
  }
}

class BluetoothManagement extends StatelessWidget {
  const BluetoothManagement({
    Key? key,
    required this.name,
  }) : super(key: key);

  static String routeName = '/bluetooth';
  final String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          return FindDevicesScreen(
            name: name,
          );
        }
        return BluetoothOffScreen(state: state);
      },
    );
  }
}
