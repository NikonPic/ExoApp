import 'package:blueapp/01_presentation/Exoskeleton/widgets/exofullview.dart';
import 'package:blueapp/01_presentation/Exoskeleton/widgets/exogame.dart';
import 'package:blueapp/01_presentation/Exoskeleton/widgets/exoview.dart';
import 'package:blueapp/02_application/exo_catch.dart';
import 'package:blueapp/02_application/exoskeleton.dart';
import 'package:blueapp/02_application/exoskeletongame.dart';
import 'package:blueapp/02_application/paths.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';

class MeasurementDetailPage extends StatefulWidget {
  const MeasurementDetailPage(
      {Key? key, required this.readFileName, required this.name})
      : super(key: key);
  final String readFileName;
  final String name;

  @override
  _MeasurementDetailPageState createState() =>
      _MeasurementDetailPageState(readFileName, name);
}

class _MeasurementDetailPageState extends State<MeasurementDetailPage> {
  final String readFileName;
  final String name;

  List<String> content = [];
  bool isLoading = true;
  ExoskeletonAdv myExo = ExoskeletonAdv();
  ExoskeletonGame myExoGame = ExoskeletonGame();
  ExoskeletonCatch myExoCatch = ExoskeletonCatch();
  int lines = 2;
  int curLine = 1;
  double time = 0;
  int gameSwitch = 0;

  _MeasurementDetailPageState(this.readFileName, this.name);

  @override
  initState() {
    super.initState();
    readContentLines(readFileName).then(
      (value) {
        content = value;
        lines = content.length;
        myExo.setParamsFromUser(name).then(
              (value) => {
                setState(
                  () {
                    List<int> intMessage =
                        contentLine2Message(content[curLine]);
                    updateCurTime(curLine);
                    setState(() {
                      myExo.update(intMessage);
                    });
                    isLoading = false;
                  },
                )
              },
            );
        myExoCatch.setConstParams(myExo);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(readFileName.split('/').last),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Center(child: Text('Lines: $lines')),
                    Stack(
                      children: [
                        gameSwitchScreen(),
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                gameSwitchIcon2(),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Spacer(),
                    Slider(
                      divisions: lines - 1,
                      label: 'Time: $time',
                      min: 1,
                      max: lines.toDouble() - 1,
                      value: curLine.toDouble(),
                      activeColor: kPrimaryColor,
                      onChanged: (double newValue) {
                        curLine = newValue.toInt();
                        List<int> intMessage =
                            contentLine2Message(content[curLine]);
                        updateCurTime(curLine);
                        setState(() {
                          myExo.update(intMessage);
                          if (gameSwitch == 1) {
                            myExoGame.update(myExo);
                          }
                          if (gameSwitch == 2) {
                            myExoCatch.update(myExo);
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget gameSwitchScreen() {
    if (gameSwitch == 0) {
      return ExoView(myExo: myExo);
    }
    if (gameSwitch == 1) {
      return ExoGameView(myExoGame: myExoGame);
    }
    return ExoFullView(
      myExo: myExo,
      name: name,
      myExoGame: myExoCatch,
      measurementMode: false,
    );
  }

  ElevatedButton gameSwitchIcon() {
    Icon myIcon = Icon(
      Icons.science,
      size: 15,
    );
    Text myLabel = Text('Measure Mode');
    if (gameSwitch == 1) {
      myIcon = Icon(
        Icons.gamepad,
        size: 15,
      );
      myLabel = Text('Game Mode');
    }
    if (gameSwitch == 2) {
      myIcon = Icon(
        Icons.panorama_fish_eye,
        size: 15,
      );
      myLabel = Text('View Mode');
    }

    return ElevatedButton.icon(
      onPressed: () => setState(() {
        gameSwitch += 1;
        if (gameSwitch == 3) {
          gameSwitch = 0;
        }
      }),
      icon: myIcon,
      label: myLabel,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.grey.shade300.withOpacity(0),
        textStyle: TextStyle(fontWeight: FontWeight.w200),
        minimumSize: Size(100, 50),
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget gameSwitchIcon2() {
    Icon myIcon = Icon(
      Icons.science,
      size: 15,
    );
    Text myLabel = Text('Measure Mode');
    if (gameSwitch == 1) {
      myIcon = Icon(
        Icons.gamepad,
        size: 15,
      );
      myLabel = Text('Game Mode');
    }
    if (gameSwitch == 2) {
      myIcon = Icon(
        Icons.panorama_fish_eye,
        size: 15,
      );
      myLabel = Text('View Mode');
    }

    return InkWell(
      onTap: () => setState(() {
        gameSwitch += 1;
        if (gameSwitch == 3) {
          gameSwitch = 0;
        }
      }),
      child: Row(
        children: [
          myIcon,
          SizedBox(
            width: 5,
          ),
          myLabel,
        ],
      ),
    );
  }

  void updateCurTime(int curLine) {
    final int time0 = int.parse(content[1].split(';')[0]);
    time = (int.parse(content[curLine].split(';')[0]) - time0) / 1000;
  }
}

List<int> contentLine2Message(String contentLine) {
  return contentLine.split(';').map((e) => int.parse(e)).toList();
}
