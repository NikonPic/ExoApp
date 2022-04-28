import 'dart:math';

import 'package:blueapp/02_application/exoskeleton.dart';
import 'package:flutter/material.dart';

final double yLim = 500;
final double xLim = 1500;

/// Idea is to create balls in a certain area (defined by user phalanges) and try to touch these balls by touching them with the exoskeleton
class ExoskeletonCatch {
  bool play = false;
  double posX = 0;
  double posY = 0;
  double avRad = 10;
  int score = 0;
  int lastPoints = 0;

  bool bonusActive = false;
  int bonusCount = 0;
  double bonusOpacity = 0;

  double xmin = 0;
  double xmax = 0;
  double ymin = 0;
  double ymax = 0;
  double rMin = 0;
  double rMax = 0;

  int createProMille = 150;

  final int bonusCountLim = 70;
  final Random rand = Random();

  FriendBubbles friend = FriendBubbles();

  void update(ExoskeletonAdv myExo) {
    if (play) {
      updateGame(myExo);
    }
  }

  void updateGame(ExoskeletonAdv myExo) {
    posX = myExo.pFS[0];
    posY = myExo.pFS[1];
    avRad = myExo.opaRd;

    final int decisionNum = rand.nextInt(1000);
    // create with 8 pro mille
    if (decisionNum < createProMille && friend.myCircles.length < 2) {
      final List<double> newPos = calculatePossibleRange(myExo);
      friend.createCircle(newPos[0], newPos[1]);
    }

    double lifeSpan = friend.update(posX, posY, avRad);

    if (lifeSpan > 0) {
      bonusActive = true;
      bonusOpacity = 1;
      bonusCount = 0;

      lastPoints = (lifeSpan * 100).ceil();
      score += lastPoints;
      if (avRad < 10) {
        avRad = 10;
      }
    }
    updateScore();
  }

  void updateScore() {
    if (bonusActive) {
      bonusCount++;
      bonusOpacity = 1 - (bonusCount / bonusCountLim);
      if (bonusCount > bonusCountLim) {
        bonusActive = false;
      }
    }
  }

  void setConstParams(ExoskeletonAdv myExo,
      {double alphaMin = 10, double alphaMax = 60, double relRange = 0.6}) {
    final double lGes = myExo.lPp + myExo.lPm + myExo.lPd;
    rMin = relRange * lGes;
    rMax = lGes;

    final List<double> p1 = getRangePoint(alphaMin, rMin);
    final List<double> p2 = getRangePoint(alphaMin, rMax);
    final List<double> p3 = getRangePoint(alphaMax, rMin);
    final List<double> p4 = getRangePoint(alphaMax, rMax);

    xmin = [p1[0], p2[0], p3[0], p4[0]].reduce(min);
    xmax = [p1[0], p2[0], p3[0], p4[0]].reduce(max);

    ymin = [p1[1], p2[1], p3[1], p4[1]].reduce(min);
    ymax = [p1[1], p2[1], p3[1], p4[1]].reduce(max);
  }

  List<double> calculatePossibleRange(ExoskeletonAdv myExo,
      {double distMin = 20}) {
    double xCreate = 0;
    double yCreate = 0;
    double rCreate;

    for (var i = 0; i < 20; i++) {
      xCreate = Random().nextInt((xmax - xmin).toInt()).toDouble() + xmin;
      yCreate =
          -(Random().nextInt((ymax - ymin).toInt()).toDouble() + ymin + 30);
      rCreate = sqrt(pow(xCreate, 2) + pow(yCreate, 2));

      // check if the ranges are within the relevant range
      if (rMin < rCreate && rCreate < rMax) {
        double distExo = sqrt(
            pow(xCreate - myExo.pFS[0], 2) + pow(yCreate - myExo.pFS[1], 2));
        if (distExo > distMin) {
          print(myExo.pFS);
          print(xCreate);
          print(yCreate);
          return [xCreate, yCreate];
        } else {
          distMin -= 1;
        }
      }
    }
    return [xCreate, yCreate];
  }

  /// return the RangePoint
  List<double> getRangePoint(double alpha, double range) {
    final double p1x = range * cos(alpha * (pi / 180));
    final double p1y = range * sin(alpha * (pi / 180));
    return [p1x, p1y];
  }
}

class FriendBubbles {
  final double createRad = 100;
  List<FriendBubble> myCircles = [];

  double update(double avatarX, double avatarY, double avatarRadius) {
    return updateCircles(avatarX, avatarY, avatarRadius);
  }

  void createCircle(double bubbleX, double bubbleY) {
    myCircles.add(FriendBubble(bubbleX, bubbleY));
  }

  double updateCircles(double avatarX, double avatarY, double avatarRadius) {
    final int curLen = myCircles.length;
    double hitCircleLife = 0;

    if (curLen > 0) {
      print(myCircles[0].posX);
      for (var i = 0; i < curLen; i++) {
        if (myCircles[i].update(avatarX, avatarY, avatarRadius)) {
          hitCircleLife = myCircles[i].opacityLife;
        }
      }
      // keep only if not touched yet
      myCircles.retainWhere((element) =>
          element.checkMatch(avatarX, avatarY, avatarRadius) == false);
      // kep only if lifespan has not ended
      myCircles.retainWhere((element) => element.opacityLife > 0);
    }
    return hitCircleLife;
  }
}

class FriendBubble {
  final double posX;
  final double posY;
  final double aging = 0.01;
  final Color color =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  double friendRad = 6;
  double opacityLife = 0.9;

  FriendBubble(this.posX, this.posY);

  bool checkMatch(double avatarX, double avatarY, double avatarRadius) {
    final Offset curAvatarPos = Offset(avatarX, avatarY);
    final Offset curFriendPos = Offset(posX, posY);

    // check if we found it
    if ((curAvatarPos - curFriendPos).distance < (avatarRadius + friendRad)) {
      return true;
    }
    return false;
  }

  bool update(double avatarX, double avatarY, double avatarRadius) {
    opacityLife -= aging;
    friendRad += 30 * aging;
    return checkMatch(avatarX, avatarY, avatarRadius);
  }
}
