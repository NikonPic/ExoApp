import 'package:blueapp/01_presentation/Exoskeleton/widgets/exozentral.dart';
import 'package:blueapp/01_presentation/home/home.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// HM10-Controller: 001122

class ExoScreen extends StatelessWidget {
  final BluetoothCharacteristic myChar;
  final BluetoothDevice myDevice;
  final String name;

  static String routeName = "/exo_screen";

  const ExoScreen(
      {Key? key,
      required this.myChar,
      required this.myDevice,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    myChar.setNotifyValue(true);
    return Scaffold(
      appBar: buildDeviceAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ExoZentralScreen(
              myChar: myChar,
              name: name,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.refresh),
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ExoScreen(
                myChar: myChar,
                myDevice: myDevice,
                name: name,
              ),
            ),
            (route) => false),
      ),
    );
  }

  AppBar buildDeviceAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Row(children: [
        InkWell(
          child: Icon(Icons.home),
          onTap: () async {
            await myDevice.disconnect();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    name: name,
                  ),
                ),
                (route) => false);
          },
        ),
        Spacer(),
        SizedBox(
          width: 20,
        ),
        Text('Exoskelett'),
        Spacer(),
      ]),
      actions: <Widget>[
        StreamBuilder<BluetoothDeviceState>(
          stream: myDevice.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (c, snapshot) {
            VoidCallback? onPressed;
            String text;
            Icon myIcon;
            switch (snapshot.data) {
              case BluetoothDeviceState.connected:
                onPressed = () => myDevice.disconnect();
                text = 'Verbunden';
                myIcon = Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                );
                break;
              case BluetoothDeviceState.disconnected:
                onPressed =
                    () => myDevice.connect().timeout(Duration(seconds: 4));
                text = 'Nicht verbunden';
                myIcon = Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.red,
                );
                break;
              default:
                onPressed = null;
                text = snapshot.data.toString().substring(21).toUpperCase();
                myIcon = Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.red,
                );
                break;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: onPressed,
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .button
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  myIcon,
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
