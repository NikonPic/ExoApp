import 'dart:math';

import 'package:blueapp/02_application/paths.dart';
import 'package:blueapp/03_database/user.dart';
import 'package:blueapp/03_database/user_database.dart';
import 'package:blueapp/constants.dart';
import 'package:linalg/linalg.dart';
import 'package:quiver/iterables.dart';

/// get the Angle between two points
double getAngle(double p1X, double p1Y, double p2X, double p2Y) {
  final double deltaX = p2X - p1X;
  final double deltaY = p2Y - p1Y;

  if (deltaX > 0) {
    return atan(deltaY / deltaX);
  } else if (deltaX < 0) {
    return atan(deltaY / deltaX) - pi;
  } else if (deltaY > 0) {
    return pi / 2;
  } else {
    return -pi / 2;
  }
}

/// Calculate the Length between two Points
double getLen(aX, aY, bX, bY) {
  return sqrt(pow(aX - bX, 2) + pow(aY - bY, 2));
}

/// define the point of  Intersection between two circles
List<double> getPoint(
    double aX, double aY, double la, double bX, double bY, double lb) {
  final double distX = bX - aX;
  final double distY = bY - aY;
  final double cA =
      (pow(distX, 2) + pow(distY, 2) + pow(la, 2) - pow(lb, 2)) / (2 * la);

  final double angA = 2 *
      atan((distY + sqrt(pow(distX, 2) + pow(distY, 2) - pow(cA, 2))) /
          (distX + cA));

  List<double> pInter = [aX + cos(angA) * la, aY + sin(angA) * la];
  return pInter;
}

/// The Exoskeleton Sensors
class Exoskeleton {
  final double timeFilter = 0.5;

  int ms = 0;
  int angleB = 0;
  int angleA = 0;
  int angleK = 0;
  int forceB = 0;
  int forceA = 0;

  double degB = 0;
  double degA = 0;
  double degK = 0;
  double force = 0;

  List<int> timeArr = [];
  List<int> degBarrRaw = [];
  List<int> degAarrRaw = [];
  List<int> degKarrRaw = [];
  List<int> forceBarr = [];
  List<int> forceAarr = [];

  List<double> degBarr = [];
  List<double> degAarr = [];
  List<double> degKarr = [];
  List<double> forceArr = [];

  /// update at each timeStep
  void update(List<int> intMessage) {
    // assign message
    this.ms = intMessage[0];
    this.angleB =
        (timeFilter * this.angleB + (1 - timeFilter) * intMessage[1]).toInt();
    this.angleA =
        (timeFilter * this.angleA + (1 - timeFilter) * intMessage[2]).toInt();
    this.angleK =
        (timeFilter * this.angleK + (1 - timeFilter) * intMessage[3]).toInt();
    this.forceB = intMessage[4];
    this.forceA = intMessage[5];
    // calibrate
    this.calibrate();
    //append to arrays
    this.add2arrs();
  }

  void calibrate() {
    // perform the calibration on all sensors
    this.degB = -9.27963813 + this.angleB * 0.05338593 - 25;
    this.degA = -10.28751994 + this.angleA * 0.05290898 - 50;
    this.degK = -10.36236706 + this.angleK * 0.05186958;

    // perform the calculation for the force
    double fBack = 0.00477458 * this.forceA - 6.32508; //Kraftsensor A
    double fFront = 0.0049497 * this.forceB - 7.17406; //Kraftsensor B
    this.force = fFront - fBack;
  }

  void addRawArrs() {
    // raw data
    this.timeArr.add(ms);
    this.degBarrRaw.add(angleB);
    this.degAarrRaw.add(angleA);
    this.degKarrRaw.add(angleK);
    this.forceBarr.add(forceB);
    this.forceAarr.add(forceA);
  }

  void add2arrs() {
    addRawArrs();
    // advanced data
    this.degBarr.add(degB);
    this.degAarr.add(degA);
    this.degKarr.add(degK);
    this.forceArr.add(force);
  }

  /// save the arrays to a file
  Future save(String fileName) async {
    String saveString = '';
    for (List<int> pair in zip(
        [timeArr, degBarrRaw, degAarrRaw, degKarrRaw, forceBarr, forceAarr])) {
      //create local save str
      final String lineString =
          '${pair[0]};${pair[1]};${pair[2]};${pair[3]};${pair[4]};${pair[5]}';
      // append the string
      saveString = '$saveString\n$lineString';
    }
    await writeContent(fileName, saveString);
  }
}

/// Contains the forward Kinematics and Dynamics
class ExoskeletonAdv extends Exoskeleton {
  double lPp = 37;
  double lPm = 24;
  double lPd = 24;

  // Exoskeleton Kinematics
  final double l1 = 45;
  final double l2 = 35;
  final double l3 = 31;
  final double l4 = 22;
  final double l5 = 15;
  final double l6 = 25;
  final double l7 = 38;
  final double l8 = 34;
  final double l9 = 8;
  final double l10 = 38;
  final double l11 = 23;
  final double l12 = 28;

  // Heights
  final double hAp = 0;

  double hPp = 13;
  double hPm = 12;
  double hPd = 14;

  // Start-Points
  List<double> pA = [8.2, 17.6];
  final List<double> pMCP = [0, 0];

  // Actuator params
  final double lact = 102 + 36.1;
  final double aktX = -152.12;
  final double aktY = -21.79;
  final double theta = (pi / 180) * 35;
  final double ls = 20;

  // masses for now zero:
  final double m1 = 0;
  final double m2 = 0;
  final double m3 = 0;

  // Actor details:
  double lG1 = 0;
  double psi_2 = 0;
  double psi_1 = 0;
  List<double> pB = [0, 0];
  double dB = 0;
  double alphaConst = 0;
  double lC1 = 0;
  double lC2 = 0;
  double lC3 = 0;

  // points
  final double p11X = 0.5;
  final double p12X = 10.5;
  double p11Y = 0;
  double p12Y = 0;

  final double p2X = 0;
  double p2Y = 0;

  final double p3X = 0;
  double p3Y = 0;

  // constParams
  double lG2 = 0;
  double lG3 = 0;
  double lG4 = 0;
  double lG5 = 0;
  double lG6 = 0;

  double psi6 = 0;
  double psi5 = 0;
  double psi4 = 0;
  double psi3 = 0;

  // predefine the point positions
  List<double> pC = [0, 0];
  List<double> pD = [0, 0];
  List<double> pE = [0, 0];
  List<double> pF = [0, 0];
  List<double> pG = [0, 0];
  List<double> pH = [0, 0];
  List<double> pI = [0, 0];
  List<double> pJ = [0, 0];
  List<double> pK = [0, 0];
  List<double> pL = [0, 0];

  List<double> pPIP = [0, 0];
  List<double> pDIP = [0, 0];
  List<double> pFS = [0, 0];

  double phiLG2 = 0;

  double phiA = 0;
  double phiB = 0;
  double phiK = 0;

  int counter = 0;
  double opaRd = 3;
  double opaSh = 0.5;

  // the joint angles
  double phiMCP = 0;
  double phiPIP = 0;
  double phiDIP = 0;

  // stab angles
  double phi1 = 0;
  double phi2 = 0;
  double phi3 = 0;
  double phi4 = 0;
  double phi5 = 0;
  double phi6 = 0;
  double phi7 = 0;
  double phi8 = 0;
  double phi9 = 0;
  double phi10 = 0;
  double phi11 = 0;
  double phi12 = 0;

  double mBNm = 0;

  double fExtY = 0;
  double fExtX = 0;

  double f1x = 0, f2x = 0, f3x = 0, f4x = 0, f5x = 0, f6x = 0;
  double f1y = 0, f2y = 0, f3y = 0, f4y = 0, f5y = 0, f6y = 0;

  double alpha = 0, beta = 0, gamma = 0;
  double mMcpNmm = 0, mPipNmm = 0, mDipNmm = 0;

  double sF1 = 0,
      sF2 = 0,
      sF3 = 0,
      sF4 = 0,
      sF5 = 0,
      sF6 = 0,
      sF7 = 0,
      sF8 = 0,
      sF9 = 0,
      sF10 = 0;

  List<double> mMcpNmArr = [];
  List<double> mPipNmArr = [];
  List<double> mDipNmArr = [];

  /// Initialise all dependent parameters
  ExoskeletonAdv() {
    lG1 = sqrt(pow(0 - pA[0], 2) + pow(0 - pA[1], 2));
    psi_2 = acos(-pA[0] / lG1);
    psi_1 = ((180 - 35) / 360) * 2 * pi;
    pB = [pA[0] + l5 * cos(psi_1), pA[1] + l5 * sin(psi_1)];
    dB = sqrt(pow(0 - aktX, 2) + pow(0 - aktY, 2));
    alphaConst = pi + getAngle(0, 0, aktX, aktY);

    // some lenghts
    lC1 = lPp / 2;
    lC2 = lPm / 2;
    lC3 = lPd / 2;

    // some points
    p11Y = hPp + hAp;
    p12Y = hPp + hAp;
    p2Y = hPm + hAp;
    p3Y = hPd + hAp;

    calculateConstParams();
  }

  Future setParamsFromUser(String name) async {
    User _myUser = await UserDatabase.instance.readOrCreateUserByNickName(name);
    this.lPp = _myUser.lPp;
    this.lPm = _myUser.lPm;
    this.lPd = _myUser.lPd;

    this.hPp = _myUser.hPp;
    this.hPm = _myUser.hPm;
    this.hPd = _myUser.hPd;

    this.pA = [_myUser.offAx, _myUser.offAy];
    calculateConstParams(dGen: _myUser.dGen);
  }

  ///update the radius of the FS
  void updateRadius() {
    counter += 1;
    opaSh = 0.2 + 0.1 * sin(0.1 * counter);
    opaRd = 8 + 4 * cos(0.2 * counter);
    opaRd = opaRd / exoScale;
  }

  /// predefine some more constants
  void calculateConstParams({double dGen = 14}) {
    // some lengths
    lG2 = sqrt(pow(hAp + hPp, 2) + pow(lPp - dGen - l9, 2));
    lG3 = sqrt(pow(hAp + hPp, 2) + pow(dGen, 2));
    lG4 = sqrt(pow(hAp + hPm, 2) + pow(0.5 * lPm, 2));
    lG5 = lG4;
    lG6 = sqrt(pow(hAp + hPd, 2) + pow(0.5 * lPd, 2));
    // some angles
    psi6 = acos((lPd / 2) / lG6);
    psi5 = acos((lPm / 2) / lG4);
    psi4 = acos(dGen / lG3);
    psi3 = acos((lPp - dGen - l9) / lG2);
  }

  /// Calculate the forward Kinematics
  void getKinConfig() {
    deg2radAngles();
    getJoint51();
    getJoint42();
    getJoint53();
    getJoint54();
    getJoint45();
  }

  void deg2radAngles() {
    phiA = degA * (pi / 180);
    phiB = degB * (pi / 180);
    phiK = degK * (pi / 180);
  }

  /// First Analysis, 5 Points
  void getJoint51() {
    final double cX = pB[0] + l1 * cos(phiB);
    final double cY = pB[1] + l1 * sin(phiB);
    pC = [cX, cY];

    final double eX = pA[0] + l4 * cos(phiA);
    final double eY = pA[1] + l4 * sin(phiA);
    pE = [eX, eY];

    pD = getPoint(cX, cY, l2, eX, eY, l3);
  }

  /// Second Analysis , 4 Points
  void getJoint42() {
    pF = getPoint(pE[0], pE[1], l6, pMCP[0], pMCP[1], lG2);
  }

  /// Thirs Analysis, 5 Points
  void getJoint53() {
    phiLG2 = getAngle(pMCP[0], pMCP[1], pF[0], pF[1]);

    final double gX = pF[0] + l9 * cos(phiLG2 - psi3);
    final double gY = pF[1] + l9 * sin(phiLG2 - psi3);
    pG = [gX, gY];

    pH = getPoint(pD[0], pD[1], l7, gX, gY, l8);
  }

  /// Fourth Analysis, 5 Points
  void getJoint54() {
    final double pipX = pG[0] + lG3 * cos(phiLG2 - psi3 - psi4);
    final double pipY = pG[1] + lG3 * sin(phiLG2 - psi3 - psi4);
    pPIP = [pipX, pipY];

    final double gamma = pi - phiK + psi5;
    final double lKs =
        sqrt(pow(lG4, 2) + pow(l11, 2) - 2 * lG4 * l11 * cos(gamma));
    pJ = getPoint(pH[0], pH[1], l10, pPIP[0], pPIP[1], lKs);

    // switch cases depending on gamma:
    if (gamma < 180) {
      pK = getPoint(pJ[0], pJ[1], l11, pPIP[0], pPIP[1], lG4);
    } else {
      pK = getPoint(pPIP[0], pPIP[1], lG4, pJ[0], pJ[1], l11);
    }
  }

  /// Final Analysis, 4 Points
  void getJoint45() {
    final double phiT = getAngle(pPIP[0], pPIP[1], pK[0], pK[1]) - psi5;
    final double pDIPX = pPIP[0] + lPm * cos(phiT);
    final double pDIPY = pPIP[1] + lPm * sin(phiT);
    pDIP = [pDIPX, pDIPY];

    pL = getPoint(pJ[0], pJ[1], l12, pDIPX, pDIPY, lG6);

    final double phiT2 = getAngle(pDIPX, pDIPY, pL[0], pL[1]) - psi6;
    final double pFSX = pDIP[0] + lPd * cos(phiT2);
    final double pFSY = pDIP[1] + lPd * sin(phiT2);

    pFS = [pFSX, pFSY];
  }

  @override
  void update(List<int> intMessage) {
    super.update(intMessage);
    updateRadius();
    getKinConfig();
    getJointAngles();
    getStabAngles();
    getActuationForce();
    getStabForces();
    getJointTorques();
    getAllStabForces();
  }

  /// calculate the angles in the finger joints based on the kinematic configuration
  void getJointAngles() {
    // MCP
    final double phiProxW = getAngle(0, 0, pPIP[0], pPIP[1]);
    phiMCP = phiProxW * (180 / pi);
    alpha = phiMCP * (pi / 180);

    // PIP
    final double phiMedW = getAngle(pPIP[0], pPIP[1], pDIP[0], pDIP[1]);
    phiPIP = phiMedW * (180 / pi) - phiMCP;
    beta = phiPIP * (pi / 180);

    // DIP
    final double phiDistW = getAngle(pDIP[0], pDIP[1], pFS[0], pFS[1]);
    phiDIP = phiDistW * (180 / pi) - phiPIP - phiMCP;
    gamma = phiDIP * (pi / 180);
  }

  @override
  void add2arrs() {
    addRawArrs();

    // new advanced data
    this.degBarr.add(phiMCP);
    this.degAarr.add(phiPIP);
    this.degKarr.add(phiDIP);
    this.forceArr.add(force);
  }

  void getStabAngles() {
    phi1 = getAngle(pB[0], pB[1], pC[0], pC[1]);
    phi2 = getAngle(pC[0], pC[1], pD[0], pD[1]);
    phi3 = getAngle(pE[0], pE[1], pD[0], pD[1]);
    phi4 = getAngle(pA[0], pA[1], pE[0], pE[1]);
    phi6 = getAngle(pE[0], pE[1], pF[0], pF[1]);
    phi7 = getAngle(pD[0], pD[1], pH[0], pH[1]);
    phi8 = getAngle(pG[0], pG[1], pH[0], pH[1]);
    phi10 = getAngle(pH[0], pH[1], pJ[0], pJ[1]);
    phi11 = getAngle(pK[0], pK[1], pJ[0], pJ[1]);
    phi12 = getAngle(pJ[0], pJ[1], pL[0], pL[1]);
  }

  /// calculate the force from the actuator
  void getActuationForce() {
    final double alphaQuer = pi - this.theta - this.phi1;

    final double sx = -ls * cos(alphaQuer);
    final double sy = ls * sin(alphaQuer);

    final double phiF = getAngle(aktX, aktY, sx, sy);
    final double fAktX = force * cos(phiF);
    final double fAktY = force * sin(phiF);

    final double deltaX = -sx;
    final double deltaY = sy;

    final double mB = (fAktX * deltaY + fAktY * deltaX);
    mBNm = mB / 1000;

    final double fExt = mB / l1;

    fExtY = -fExt * cos(phi1);
    fExtX = fExt * sin(phi1);
  }

  /// calculate the force from the stab
  void getStabForces() {
    f1x = -(cos(phi1) * (fExtY * cos(phi2) - fExtX * sin(phi2))) /
        sin(phi1 - phi2);
    f1y = -(sin(phi1) * (fExtY * cos(phi2) - fExtX * sin(phi2))) /
        sin(phi1 - phi2);

    f2x = (sin(phi2 - phi7) *
            sin(phi3 - phi6) *
            cos(phi4) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) * sin(phi3 - phi7) * sin(phi4 - phi6));
    f2y = (sin(phi2 - phi7) *
            sin(phi3 - phi6) *
            sin(phi4) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) * sin(phi3 - phi7) * sin(phi4 - phi6));

    f3x = -(sin(phi3 - phi4) *
            sin(phi2 - phi7) *
            cos(phi6) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) * sin(phi3 - phi7) * sin(phi4 - phi6));
    f3y = -(sin(phi3 - phi4) *
            sin(phi2 - phi7) *
            sin(phi6) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) * sin(phi3 - phi7) * sin(phi4 - phi6));

    f4x = -(sin(phi2 - phi3) *
            sin(phi7 - phi10) *
            cos(phi8) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) * sin(phi3 - phi7) * sin(phi8 - phi10));
    f4y = -(sin(phi2 - phi3) *
            sin(phi7 - phi10) *
            sin(phi8) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) * sin(phi3 - phi7) * sin(phi8 - phi10));

    f5x = (sin(phi2 - phi3) *
            sin(phi7 - phi8) *
            sin(phi10 - phi12) *
            cos(phi11) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) *
            sin(phi3 - phi7) *
            sin(phi8 - phi10) *
            sin(phi11 - phi12));
    f5y = (sin(phi2 - phi3) *
            sin(phi7 - phi8) *
            sin(phi10 - phi12) *
            sin(phi11) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) *
            sin(phi3 - phi7) *
            sin(phi8 - phi10) *
            sin(phi11 - phi12));

    f6x = -(sin(phi2 - phi3) *
            sin(phi7 - phi8) *
            sin(phi10 - phi11) *
            cos(phi12) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) *
            sin(phi3 - phi7) *
            sin(phi8 - phi10) *
            sin(phi11 - phi12));
    f6y = -(sin(phi2 - phi3) *
            sin(phi7 - phi8) *
            sin(phi10 - phi11) *
            sin(phi12) *
            (fExtY * cos(phi1) - fExtX * sin(phi1))) /
        (sin(phi1 - phi2) *
            sin(phi3 - phi7) *
            sin(phi8 - phi10) *
            sin(phi11 - phi12));
  }

  List<double> getDir(List<double> pA, List<double> pB) {
    final double x = pB[0] - pA[0];
    final double y = pB[1] - pA[1];
    final double l = sqrt(x * x + y * y);
    return [x / l, y / l];
  }

  List<List<double>> getStabDirections() {
    final List<double> s1Dir = getDir(pB, pC);
    final List<double> s2Dir = getDir(pC, pD);
    final List<double> s3Dir = getDir(pE, pD);
    final List<double> s4Dir = getDir(pE, pA);
    final List<double> s5Dir = getDir(pE, pF);
    final List<double> s6Dir = getDir(pD, pH);
    final List<double> s7Dir = getDir(pH, pG);
    final List<double> s8Dir = getDir(pH, pJ);
    final List<double> s9Dir = getDir(pJ, pK);
    final List<double> s10Dir = getDir(pJ, pL);

    return [
      s1Dir,
      s2Dir,
      s3Dir,
      s4Dir,
      s5Dir,
      s6Dir,
      s7Dir,
      s8Dir,
      s9Dir,
      s10Dir
    ];
  }

  getAllStabForces() {
    final List<List<double>> sDirs = getStabDirections();
    final Matrix mStab = Matrix([
      [sDirs[0][0], -sDirs[1][0], 0, 0, 0, 0, 0, 0, 0, 0],
      [sDirs[0][1], -sDirs[1][1], 0, 0, 0, 0, 0, 0, 0, 0],
      [0, sDirs[1][0], sDirs[2][0], 0, 0, -sDirs[5][0], 0, 0, 0, 0],
      [
        0,
        sDirs[1][1],
        sDirs[2][1],
        0,
        0,
        -sDirs[5][1],
        0,
        0,
        0,
        0,
      ],
      [
        0,
        0,
        -sDirs[2][0],
        -sDirs[3][0],
        -sDirs[4][0],
        0,
        0,
        0,
        0,
        0,
      ],
      [
        0,
        0,
        -sDirs[2][1],
        -sDirs[3][1],
        -sDirs[4][1],
        0,
        0,
        0,
        0,
        0,
      ],
      [
        0,
        0,
        0,
        0,
        0,
        sDirs[5][0],
        -sDirs[6][0],
        -sDirs[7][0],
        0,
        0,
      ],
      [
        0,
        0,
        0,
        0,
        0,
        sDirs[5][1],
        -sDirs[6][1],
        -sDirs[7][1],
        0,
        0,
      ],
      [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        sDirs[7][0],
        -sDirs[8][0],
        -sDirs[9][0],
      ],
      [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        sDirs[7][1],
        -sDirs[8][1],
        -sDirs[9][1],
      ],
    ]);
    final Vector bStab =
        Vector.column([-fExtX, -fExtY, 0, 0, 0, 0, 0, 0, 0, 0]);
    final Matrix stabForces = mStab.inverse() * bStab;

    // assign the forces
    sF1 = stabForces[0][0];
    sF2 = stabForces[1][0];
    sF3 = stabForces[2][0];
    sF4 = stabForces[3][0];
    sF5 = stabForces[4][0];
    sF6 = stabForces[5][0];
    sF7 = stabForces[6][0];
    sF8 = stabForces[7][0];
    sF9 = stabForces[8][0];
    sF10 = stabForces[9][0];
  }

  void getJointTorques() {
    final double f11X = f3x;
    final double f11Y = f3y;
    final double f12X = f4x;
    final double f12Y = f4y;
    final double f2X = f5x;
    final double f2Y = f5y;
    final double f3X = f6x;
    final double f3Y = f6y;

    final double a1 = alpha;
    final double a2 = alpha + beta;
    final double a3 = alpha + beta + gamma;

    mMcpNmm = f3Y * lC3 * cos(a3) -
        f3X * lC3 * sin(a3) -
        (981 * lC3 * m3 * cos(a3)) / 100 -
        f2X * p2Y * cos(a2) +
        f2Y * p2X * cos(a2) -
        f2X * p2X * sin(a2) -
        f2Y * p2Y * sin(a2) +
        f2Y * lC2 * cos(a2) +
        2 * f3Y * lC2 * cos(a2) -
        f2X * lC2 * sin(a2) -
        2 * f3X * lC2 * sin(a2) -
        f11X * p11Y * cos(a1) +
        f11Y * p11X * cos(a1) -
        f12X * p12Y * cos(a1) +
        f12Y * p12X * cos(a1) -
        (981 * lC2 * m2 * cos(a2)) / 100 -
        (981 * lC2 * m3 * cos(a2)) / 50 -
        f11X * p11X * sin(a1) -
        f11Y * p11Y * sin(a1) -
        f12X * p12X * sin(a1) -
        f12Y * p12Y * sin(a1) +
        2 * f2Y * lC1 * cos(a1) +
        2 * f3Y * lC1 * cos(a1) +
        f11Y * lC1 * cos(a1) +
        f12Y * lC1 * cos(a1) -
        f3X * p3Y * cos(a3) +
        f3Y * p3X * cos(a3) -
        2 * f2X * lC1 * sin(a1) -
        2 * f3X * lC1 * sin(a1) -
        f11X * lC1 * sin(a1) -
        f12X * lC1 * sin(a1) -
        f3X * p3X * sin(a3) -
        f3Y * p3Y * sin(a3) -
        (981 * lC1 * m1 * cos(a1)) / 100 -
        (981 * lC1 * m2 * cos(a1)) / 50 -
        (981 * lC1 * m3 * cos(a1)) / 50;
    mPipNmm = f3Y * lC3 * cos(a3) -
        f3X * lC3 * sin(a3) -
        (981 * lC3 * m3 * cos(a3)) / 100 -
        f2X * p2Y * cos(a2) +
        f2Y * p2X * cos(a2) -
        f2X * p2X * sin(a2) -
        f2Y * p2Y * sin(a2) +
        f2Y * lC2 * cos(a2) +
        2 * f3Y * lC2 * cos(a2) -
        f2X * lC2 * sin(a2) -
        2 * f3X * lC2 * sin(a2) -
        (981 * lC2 * m2 * cos(a2)) / 100 -
        (981 * lC2 * m3 * cos(a2)) / 50 -
        f3X * p3Y * cos(a3) +
        f3Y * p3X * cos(a3) -
        f3X * p3X * sin(a3) -
        f3Y * p3Y * sin(a3);
    mDipNmm = f3Y * lC3 * cos(a3) -
        f3X * lC3 * sin(a3) -
        (981 * lC3 * m3 * cos(a3)) / 100 -
        f3X * p3Y * cos(a3) +
        f3Y * p3X * cos(a3) -
        f3X * p3X * sin(a3) -
        f3Y * p3Y * sin(a3);

    // add results
    this.mMcpNmArr.add(mMcpNmm / 1000);
    this.mPipNmArr.add(mPipNmm / 1000);
    this.mDipNmArr.add(mDipNmm / 1000);
  }
}
