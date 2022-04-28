import 'package:blueapp/01_presentation/DeviceScreen/device_screen.dart';
import 'package:blueapp/01_presentation/Exoskeleton/ExoScreen.dart';
import 'package:blueapp/01_presentation/FindDevicesScreen/widgets/scan_result_tile.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindDevicesScreen extends StatelessWidget {
  final String name;

  static String routeName = "/find_devices_screen";

  const FindDevicesScreen({Key? key, required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Suche nach Bluetoothgeräten')),
        backgroundColor: kPrimaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: highLightText(d),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text('OPEN'),
                                    onPressed: () async {
                                      BluetoothCharacteristic myChar =
                                          await getChar(d);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ExoScreen(
                                                myChar: myChar,
                                                myDevice: d,
                                                name: name);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () async {
                            await r.device.connect();
                            BluetoothCharacteristic myChar =
                                await getChar(r.device);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ExoScreen(
                                      myChar: myChar,
                                      myDevice: r.device,
                                      name: name);
                                },
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamingActionButton(),
    );
  }

  Widget highLightText(BluetoothDevice d) {
    if (d.name.contains('DSD')) {
      return Text(
        'Exoskelett',
        style: TextStyle(color: Colors.green.shade800, fontSize: 20),
      );
    }
    return Text(d.name);
  }
}

class StreamingActionButton extends StatelessWidget {
  const StreamingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data!) {
          return FloatingActionButton(
            child: Icon(Icons.stop),
            onPressed: () => FlutterBlue.instance.stopScan(),
            backgroundColor: Colors.redAccent,
          );
        } else {
          return FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: Icon(
                Icons.search,
              ),
              onPressed: () => FlutterBlue.instance
                  .startScan(timeout: Duration(seconds: 4)));
        }
      },
    );
  }
}
