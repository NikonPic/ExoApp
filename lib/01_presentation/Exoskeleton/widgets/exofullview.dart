import 'package:blueapp/02_application/exo_catch.dart';
import 'package:blueapp/02_application/exoskeleton.dart';
import 'package:blueapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExoFullView extends StatefulWidget {
  const ExoFullView(
      {Key? key,
      required this.myExo,
      required this.name,
      required this.myExoGame,
      required this.measurementMode})
      : super(key: key);

  final ExoskeletonAdv myExo;
  final String name;
  final ExoskeletonCatch myExoGame;
  final bool measurementMode;

  @override
  _ExoFullViewState createState() =>
      _ExoFullViewState(myExo, name, myExoGame, measurementMode);
}

class _ExoFullViewState extends State<ExoFullView> {
  final ExoskeletonCatch myExoGame;
  final ExoskeletonAdv myExo;
  final String name;
  final bool measurementMode;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
  }

  _ExoFullViewState(
      this.myExo, this.name, this.myExoGame, this.measurementMode);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10)),
        height: 500,
        child: Stack(
          children: [
            CustomPaint(
              foregroundPainter: ExoPainter(myExo, size),
            ),
            myExoGame.play
                ? Stack(
                    children: [
                      CustomPaint(
                        foregroundPainter: CatchPainter(myExoGame, size),
                      ),
                      GameInfos(myExoGame: myExoGame),
                    ],
                  )
                : Column(),
            MyParamsSetter(
              myExo: myExo,
              myExoCatch: myExoGame,
              measurementMode: measurementMode,
            )
          ],
        ),
      ),
    );
  }
}

class GameInfos extends StatelessWidget {
  const GameInfos({
    Key? key,
    required this.myExoGame,
  }) : super(key: key);

  final ExoskeletonCatch myExoGame;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Spacer(),
            Text(
              'Dein Score: ${myExoGame.score}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            ),
            Spacer(),
          ],
        ),
        Row(
          children: [
            Spacer(),
            Text('Collect: '),
            Icon(
              Icons.circle,
              color: Colors.redAccent,
              size: 15,
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Spacer(),
            myExoGame.bonusActive
                ? Text(
                    '+ ${myExoGame.lastPoints} Punkte',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:
                            Colors.black.withOpacity(myExoGame.bonusOpacity)),
                  )
                : Text(''),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class MyParamsSetter extends StatelessWidget {
  const MyParamsSetter({
    Key? key,
    required this.myExo,
    required this.myExoCatch,
    required this.measurementMode,
  }) : super(key: key);

  final ExoskeletonAdv myExo;
  final ExoskeletonCatch myExoCatch;
  final bool measurementMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        SizedBox(
          width: 150,
          child: Column(
            children: [
              measurementMode
                  ? Column(
                      children: [
                        SizedBox(height: 20),
                        Text('MCP: ${myExo.phiMCP.ceil()} °'),
                        Text('PIP: ${myExo.phiPIP.ceil()} °'),
                        Text('DIP: ${myExo.phiDIP.ceil()} °'),
                      ],
                    )
                  : Column(),
              Spacer(),
              !measurementMode
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                      onPressed: () {
                        myExoCatch.play = !myExoCatch.play;
                      },
                      icon: myExoCatch.play
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                      label:
                          myExoCatch.play ? Text('Stop Playing') : Text('Play'),
                    )
                  : Text(''),
              TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Length PP (mm)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (String value) {
                  myExo.lPp = int.parse(value).toDouble();
                  myExo.calculateConstParams();
                },
                initialValue: myExo.lPp.toInt().toString(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Length PM (mm)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (String value) {
                  myExo.lPm = int.parse(value).toDouble();
                  myExo.calculateConstParams();
                },
                initialValue: myExo.lPm.toInt().toString(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Length PD (mm)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (String value) {
                  myExo.lPd = int.parse(value).toDouble();
                  myExo.calculateConstParams();
                },
                initialValue: myExo.lPd.toInt().toString(),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CatchPainter extends CustomPainter {
  Offset off = Offset(-250, -200);
  final Size screenSize;

  final ExoskeletonCatch myExoGame;
  CatchPainter(this.myExoGame, this.screenSize);

  void drawFriends(Canvas canvas) {
    final int numFriends = myExoGame.friend.myCircles.length;
    if (numFriends > 0) {
      for (int curFriend = 0; curFriend < numFriends; curFriend++) {
        final FriendBubble curCircle = myExoGame.friend.myCircles[curFriend];
        final paintFr = Paint()
          ..color = curCircle.color.withOpacity(curCircle.opacityLife);

        final Offset locP =
            -Offset(curCircle.posX * exoScale, curCircle.posY * exoScale) - off;
        canvas.drawCircle(locP, curCircle.friendRad * exoScale, paintFr);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    off = Offset(-screenSize.width * 0.6, -250);
    drawFriends(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ExoPainter extends CustomPainter {
  final Size screenSize;
  final ExoskeletonAdv myExo;
  ExoPainter(this.myExo, this.screenSize);
  final double offx = 2;
  final double offy = 3;
  Offset off = Offset(-250, -200);
  final Offset shOff = Offset(2, 1);

  void drawFinger(Canvas canvas) {
    const double rad = 2;
    final Color rodC = Colors.blueGrey.shade200;
    const Color jointC = kPrimaryColor;
    final double offFinger = 5;

    drawLine(myExo.pMCP, myExo.pPIP, canvas, color: rodC, sw: rad + offFinger);
    drawLine(myExo.pPIP, myExo.pDIP, canvas, color: rodC, sw: rad + offFinger);
    drawLine(myExo.pDIP, myExo.pFS, canvas, color: rodC, sw: rad + offFinger);

    drawPoint(myExo.pMCP, canvas, color: jointC, rad: rad);
    drawPoint(myExo.pPIP, canvas, color: jointC, rad: rad);
    drawPoint(myExo.pDIP, canvas, color: jointC, rad: rad);
    drawPoint(myExo.pFS, canvas,
        color: jointC, rad: rad, shRad: myExo.opaRd, opaSh: myExo.opaSh);
  }

  void drawPoint(List<double> myPoint, Canvas canvas,
      {color = Colors.blueGrey, rad = 1.5, shRad = 2.0, opaSh = 0.1}) {
    final paintJ = Paint()..color = color;
    final paintSh = Paint()..color = color.withOpacity(opaSh);
    final Offset locP =
        -Offset(myPoint[0] * exoScale, myPoint[1] * exoScale) - off;

    canvas.drawCircle(locP, shRad * exoScale, paintSh);
    canvas.drawCircle(locP, rad * exoScale, paintJ);
  }

  void drawLine(List<double> p1, List<double> p2, Canvas canvas,
      {double sw = 2, color = Colors.black38}) {
    final paintL = Paint()
      ..color = color
      ..strokeWidth = sw;

    final paintSh = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = sw + 1;

    final Offset p1loc = -Offset(p1[0] * exoScale, p1[1] * exoScale) - off;
    final Offset p2loc = -Offset(p2[0] * exoScale, p2[1] * exoScale) - off;

    canvas.drawLine(p1loc, p2loc, paintL);
    canvas.drawLine(p1loc + shOff, p2loc + shOff, paintSh);
  }

  Color getStabColor(double exoForce, {double lim = 8}) {
    double opa;
    Color blendColor;
    if (exoForce.abs() > lim) {
      opa = 1.0;
    } else {
      opa = exoForce.abs() / lim;
    }
    if (exoForce < 0) {
      blendColor = Colors.red.shade900.withOpacity(opa);
    } else {
      blendColor = Colors.green.shade900.withOpacity(opa);
    }
    return Color.alphaBlend(blendColor.withOpacity(opa), Colors.black38);
  }

  double getStabWith(double exoForce, {double stabSw = 2.8, double lim = 12}) {
    double opa;
    if (exoForce.abs() > lim) {
      opa = 1;
    } else {
      opa = exoForce.abs() / lim;
    }
    return stabSw + (lim - stabSw) * opa;
  }

  void drawExo(Canvas canvas) {
    drawLine(
      myExo.pA,
      myExo.pB,
      canvas,
    );
    // S1-6
    drawLine(myExo.pB, myExo.pC, canvas,
        color: getStabColor(myExo.sF1), sw: getStabWith(myExo.sF1));
    drawLine(myExo.pC, myExo.pD, canvas,
        color: getStabColor(myExo.sF2), sw: getStabWith(myExo.sF2));
    drawLine(myExo.pD, myExo.pE, canvas,
        color: getStabColor(myExo.sF3), sw: getStabWith(myExo.sF3));
    drawLine(myExo.pA, myExo.pE, canvas,
        color: getStabColor(myExo.sF4), sw: getStabWith(myExo.sF4));
    drawLine(myExo.pE, myExo.pF, canvas,
        color: getStabColor(myExo.sF5), sw: getStabWith(myExo.sF5));
    drawLine(myExo.pH, myExo.pD, canvas,
        color: getStabColor(myExo.sF6), sw: getStabWith(myExo.sF6));

    drawLine(myExo.pF, myExo.pG, canvas);

    // S7-10
    drawLine(myExo.pG, myExo.pH, canvas,
        color: getStabColor(myExo.sF7), sw: getStabWith(myExo.sF7));
    drawLine(myExo.pH, myExo.pJ, canvas,
        color: getStabColor(myExo.sF8), sw: getStabWith(myExo.sF8));
    drawLine(myExo.pK, myExo.pJ, canvas,
        color: getStabColor(myExo.sF9), sw: getStabWith(myExo.sF9));
    drawLine(myExo.pL, myExo.pJ, canvas,
        color: getStabColor(myExo.sF10), sw: getStabWith(myExo.sF10));

    drawLine(myExo.pL, myExo.pFS, canvas);
    drawLine(myExo.pL, myExo.pDIP, canvas);

    drawLine(myExo.pK, myExo.pDIP, canvas);
    drawLine(myExo.pK, myExo.pPIP, canvas);

    drawLine(myExo.pG, myExo.pPIP, canvas);
    drawLine(myExo.pF, myExo.pMCP, canvas);
    drawLine(myExo.pA, myExo.pMCP, canvas);

    drawPoint(myExo.pA, canvas);
    drawPoint(myExo.pB, canvas);
    drawPoint(myExo.pC, canvas);
    drawPoint(myExo.pD, canvas);
    drawPoint(myExo.pE, canvas);

    drawPoint(myExo.pF, canvas);

    drawPoint(myExo.pG, canvas);
    drawPoint(myExo.pH, canvas);
    drawPoint(myExo.pJ, canvas);
    drawPoint(myExo.pK, canvas);
    drawPoint(myExo.pL, canvas);
  }

  @override
  void paint(Canvas canvas, Size size) {
    off = Offset(-screenSize.width * 0.6, -250);
    drawExo(canvas);
    drawFinger(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
