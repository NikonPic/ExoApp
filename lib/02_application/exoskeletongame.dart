import 'dart:math';

import 'package:blueapp/02_application/exoskeleton.dart';
import 'package:flutter/material.dart';

final double yLim = 500;
final double xlim = 1500;

class ExoskeletonGame {
  final double lowerLim = 0;
  final double upperLim = yLim;
  final double gravity = 1;
  final int bonusCountLim = 70;
  final double growFactor = 0.03;

  bool hasEnded = false;

  int difficulty = 0;
  int friendProb = 0;
  int enemyProb = 0;
  int enemyVel = 0;

  double avRad = 10;

  int score = 0;

  double posX = 200; // m
  double velX = 0; // m/s
  double accX = 0; // m/s^2

  double posY = yLim / 2; // m
  double velY = 0; // m/s
  double accY = 0; // m/s^2

  double opaSh = 0;
  double opaRd = 5;

  Enemies enemy = Enemies();
  Friends friend = Friends();

  bool bonusActive = false;
  int bonusCount = 0;
  double bonusOpacity = 0;

  ExoskeletonGame() {
    setDifficulty();
  }

  void setDifficulty() {
    friendProb = 15 - (8 * difficulty / 100).ceil();
    enemyProb = 0 + (55 * difficulty / 100).ceil();
    enemyVel = 2 + (40 * difficulty / 100).ceil();

    friend.createProMille = friendProb;
    enemy.createProMille = enemyProb;
    enemy.velocityStd = enemyVel;
  }

  bool update(Exoskeleton myExo) {
    if (!hasEnded) {
      updatePos(myExo);
      updateScore();
      if (friend.update(posX, posY, avRad)) {
        bonusActive = true;
        bonusOpacity = 1;
        bonusCount = 0;

        avRad -= 10;
        score += 100;
        if (avRad < 10) {
          avRad = 10;
        }
      }
      hasEnded = enemy.update(posX, posY, avRad);
    }
    return hasEnded;
  }

  void updatePos(Exoskeleton myExo) {
    posX = 0.7 * posX + .1 * myExo.degB + .1 * myExo.degA + .1 * myExo.degK;
    accY = myExo.force - gravity;
    velY += 0.5 * accY - 0.1 * velY;
    posY += velY;
    checkLim();
  }

  void checkLim() {
    if (posY + avRad >= upperLim) {
      posY = upperLim - avRad;
      velY = -0.6 * velY;
    }
    if (posY - avRad <= lowerLim) {
      posY = lowerLim + avRad;
      velY = -0.6 * velY;
    }
  }

  void updateScore() {
    score += 1;
    avRad += growFactor;
    opaSh = 0.2 + 0.1 * sin(0.1 * score);
    opaRd = 6 + 3 * cos(0.2 * score);

    if (bonusActive) {
      bonusCount++;
      bonusOpacity = 1 - (bonusCount / bonusCountLim);
      if (bonusCount > bonusCountLim) {
        bonusActive = false;
      }
    }
  }
}

class Friends {
  final Random rand = Random();
  List<FriendRound> myCircles = [];
  int createProMille = 8;

  bool update(double avatarX, double avatarY, double avatarRadius) {
    createCircle();
    return updateCircles(avatarX, avatarY, avatarRadius);
  }

  void createCircle() {
    final int decisionNum = rand.nextInt(1000);
    // create with 8 pro mille
    if (decisionNum < createProMille) {
      myCircles.add(FriendRound());
    }
  }

  bool updateCircles(double avatarX, double avatarY, double avatarRadius) {
    final int curLen = myCircles.length;
    bool decision = false;

    if (curLen > 0) {
      print(myCircles[0].posX);
      for (var i = 0; i < curLen; i++) {
        if (myCircles[i].update(avatarX, avatarY, avatarRadius)) {
          decision = true;
        }
      }
      myCircles.retainWhere((element) => element.posX >= -150);
      myCircles.retainWhere((element) =>
          element.checkMatch(avatarX, avatarY, avatarRadius) == false);
    }
    return decision;
  }
}

class FriendRound {
  final double posY = 1 + Random().nextInt(yLim.toInt()).toDouble();
  final double friendRad = 10 + Random().nextInt(4).toDouble();
  final int velocity = 2 + Random().nextInt(5);
  final Color color = Colors.redAccent;

  double posX = xlim;

  bool update(double avatarX, double avatarY, double avatarRadius) {
    posX -= velocity;
    return checkMatch(avatarX, avatarY, avatarRadius);
  }

  bool checkMatch(double avatarX, double avatarY, double avatarRadius) {
    final Offset curAvatarPos = Offset(avatarX, avatarY);
    final Offset curFriendPos = Offset(posX, posY);

    // check if we found it
    if ((curAvatarPos - curFriendPos).distance < (avatarRadius + friendRad)) {
      return true;
    }
    return false;
  }
}

class Enemies {
  final Random rand = Random();
  int createProMille = 10;
  int velocityStd = 10;
  List<EnemyBlock> myBlocks = [];

  bool update(double avatarX, double avatarY, double avatarRadius) {
    createBlock();
    return updateBlocks(avatarX, avatarY, avatarRadius);
  }

  void createBlock() {
    final int decisionNum = rand.nextInt(1000);
    // create with decisionNum pro mille
    if (decisionNum < createProMille) {
      myBlocks.add(EnemyBlock(velocityStd));
    }
  }

  bool updateBlocks(double avatarX, double avatarY, double avatarRadius) {
    final int curLen = myBlocks.length;
    bool decision = false;

    if (curLen > 0) {
      print(myBlocks[0].posX);
      for (var i = 0; i < curLen; i++) {
        if (myBlocks[i].update(avatarX, avatarY, avatarRadius)) {
          decision = true;
        }
      }
      myBlocks.retainWhere((element) => element.posX >= -150);
    }
    return decision;
  }
}

class EnemyBlock {
  final double posY = Random().nextInt(yLim.toInt()).toDouble();
  int height = 20 + Random().nextInt(100);
  final int width = 20 + Random().nextInt(100);
  int velocity = 1 + Random().nextInt(3);
  final Color color =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  double posX = xlim;
  Offset topLeft = Offset(0, 0);
  Offset topRight = Offset(0, 0);
  Offset bottomLeft = Offset(0, 0);
  Offset bottomRight = Offset(0, 0);

  EnemyBlock(int velocityStd) {
    velocity = 1 + Random().nextInt(velocityStd);
    if (posY + height > yLim) {
      height = yLim.toInt() - posY.ceil().toInt();
    }
  }

  bool update(double avatarX, double avatarY, double avatarRadius) {
    posX -= velocity;
    topLeft = Offset(posX, posY);
    topRight = Offset(posX + width, posY);
    bottomLeft = Offset(posX, posY + height);
    bottomRight = Offset(posX + width, posY + height);
    return checkCrash(avatarX, avatarY, avatarRadius);
  }

  // check if we have crashed
  bool checkCrash(double avatarX, double avatarY, double avatarRadius) {
    final Offset posAvatar = Offset(avatarX, avatarY);

    if (checkPoint(posAvatar, avatarRadius, topLeft)) {
      return true;
    }

    if (checkPoint(posAvatar, avatarRadius, topRight)) {
      return true;
    }

    if (checkPoint(posAvatar, avatarRadius, bottomLeft)) {
      return true;
    }

    if (checkPoint(posAvatar, avatarRadius, bottomRight)) {
      return true;
    }

    if (checkBox(Offset(avatarX - avatarRadius, avatarY))) {
      return true;
    }

    if (checkBox(Offset(avatarX, avatarY + avatarRadius))) {
      return true;
    }

    if (checkBox(Offset(avatarX, avatarY - avatarRadius))) {
      return true;
    }

    return false;
  }

  bool checkPoint(Offset posAvatar, double avatarRadius, Offset myPoint) {
    // check if point within avatar
    if ((posAvatar - myPoint).distance < avatarRadius) {
      return true;
    }
    return false;
  }

  bool checkBox(Offset entry) {
    final double top = topLeft.dy;
    final double left = topLeft.dx;
    final double right = bottomRight.dx;
    final double bottom = bottomRight.dy;

    if (left < entry.dx && entry.dx < right) {
      if (top < entry.dy && entry.dy < bottom) {
        return true;
      }
    }
    return false;
  }
}
