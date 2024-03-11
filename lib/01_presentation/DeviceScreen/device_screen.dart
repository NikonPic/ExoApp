import 'package:blueapp/01_presentation/Exoskeleton/ExoScreen.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device, required this.name})
      : super(key: key);
  static String routeName = "/device_screen";
  final BluetoothDevice device;

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDeviceAppBar(context),
      body: StreamBuilder<BluetoothDeviceState>(
        stream: device.state,
        initialData: BluetoothDeviceState.connecting,
        builder: (BuildContext context,
            AsyncSnapshot<BluetoothDeviceState> snapshot) {
          Widget myWidget;
          switch (snapshot.data) {
            case BluetoothDeviceState.connected:
              myWidget = FutureBuilder(
                future: getChar(device),
                builder: (BuildContext context,
                    AsyncSnapshot<BluetoothCharacteristic> charSnapshot) {
                  if (charSnapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          /*
                          MyStyleButton(
                            myFunc: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalibrationScreen(
                                            myChar: charSnapshot.data!,
                                            myDevice: device,
                                            name: name,
                                          )),
                                  (route) => false);
                            },
                            text: 'Perform Calibration',
                          ),
                          SizedBox(height: 20),
                          MyStyleButton(
                            myFunc: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyOsciScreen(
                                            myChar: charSnapshot.data!,
                                            myDevice: device,
                                            name: name,
                                          )),
                                  (route) => false);
                            },
                            text: 'View Sensor Details',
                          ),
                          SizedBox(height: 20),
                          */
                          MyStyleButton(
                            myFunc: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExoScreen(
                                      myChar: charSnapshot.data!,
                                      myDevice: device,
                                      name: name,
                                    ),
                                  ),
                                  (route) => false);
                            },
                            text: 'Exoskeleton',
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
              break;
            default:
              myWidget = Center(
                child: Text('Not Connected'),
              );
              break;
          }
          return myWidget;
        },
      ),
    );
  }

  AppBar buildDeviceAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Text(device.name),
      actions: <Widget>[
        StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (c, snapshot) {
            VoidCallback? onPressed;
            String text;
            Icon myIcon;
            switch (snapshot.data) {
              case BluetoothDeviceState.connected:
                onPressed = () => device.disconnect();
                text = 'DISCONNECT';
                myIcon = Icon(
                  Icons.bluetooth_connected,
                  color: Colors.green,
                );
                break;
              case BluetoothDeviceState.disconnected:
                onPressed =
                    () => device.connect().timeout(Duration(seconds: 4));
                text = 'CONNECT';
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
                          .labelLarge
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

Future<BluetoothCharacteristic> getChar(BluetoothDevice mydevice) async {
  final List<BluetoothService> myServices = await mydevice.discoverServices();
  final BluetoothService myService = myServices.last;
  final BluetoothCharacteristic myChar = myService.characteristics.first;
  return myChar;
}

class MyStyleButton extends StatelessWidget {
  const MyStyleButton({
    Key? key,
    required this.myFunc,
    required this.text,
  }) : super(key: key);
  final Function myFunc;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.grey.shade300,
        minimumSize: Size(100, 50),
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: () {
        myFunc();
      },
      child: Text(text),
    );
  }
}
