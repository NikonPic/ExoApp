class User {
  // general
  final int? id;
  final int age;
  final String nickName;
  final String firstName;
  final String lastName;
  final String gender;
  final int weight;

  // finger specific
  final double lPp;
  final double lPm;
  final double lPd;

  // detailed parameters
  final double hPp;
  final double hPm;
  final double hPd;
  final double dGen;
  final double offAx;
  final double offAy;

  User({
    this.id,
    required this.age,
    required this.nickName,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.weight,
    required this.lPp,
    required this.lPm,
    required this.lPd,
    required this.hPp,
    required this.hPm,
    required this.hPd,
    required this.dGen,
    required this.offAx,
    required this.offAy,
  });

  static User createDummy(String nickName) => User(
        age: 99,
        nickName: nickName,
        firstName: nickName,
        lastName: nickName,
        gender: 'w',
        weight: 100,
        lPp: 41,
        lPm: 24,
        lPd: 24,
        hPp: 13,
        hPm: 12,
        hPd: 14,
        dGen: 14,
        offAx: 8.2,
        offAy: 17.6,
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.age: age,
        UserFields.nickName: nickName,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName,
        UserFields.gender: gender,
        UserFields.weight: weight,
        UserFields.lPp: lPp,
        UserFields.lPm: lPm,
        UserFields.lPd: lPd,
        UserFields.hPp: hPp,
        UserFields.hPm: hPm,
        UserFields.hPd: hPd,
        UserFields.dGen: dGen,
        UserFields.offAx: offAx,
        UserFields.offAy: offAy,
      };

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        age: json[UserFields.age] as int,
        nickName: json[UserFields.nickName] as String,
        firstName: json[UserFields.firstName] as String,
        lastName: json[UserFields.lastName] as String,
        gender: json[UserFields.gender] as String,
        weight: json[UserFields.weight] as int,
        lPp: json[UserFields.lPp] as double,
        lPm: json[UserFields.lPm] as double,
        lPd: json[UserFields.lPd] as double,
        hPp: json[UserFields.hPp] as double,
        hPm: json[UserFields.hPm] as double,
        hPd: json[UserFields.hPd] as double,
        dGen: json[UserFields.dGen] as double,
        offAx: json[UserFields.offAx] as double,
        offAy: json[UserFields.offAy] as double,
      );

  User copyWith({
    int? id,
    int? age,
    String? nickName,
    String? firstName,
    String? lastName,
    String? gender,
    int? weight,
    double? lPp,
    double? lPm,
    double? lPd,
    double? hPp,
    double? hPm,
    double? hPd,
    double? dGen,
    double? offAx,
    double? offAy,
  }) {
    return User(
      id: id ?? this.id,
      age: age ?? this.age,
      nickName: nickName ?? this.nickName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      lPp: lPp ?? this.lPp,
      lPm: lPm ?? this.lPm,
      lPd: lPd ?? this.lPd,
      hPp: hPp ?? this.hPp,
      hPm: hPm ?? this.hPm,
      hPd: hPd ?? this.hPd,
      dGen: dGen ?? this.dGen,
      offAx: offAx ?? this.offAx,
      offAy: offAy ?? this.offAy,
    );
  }
}

class UserFields {
  // Field Names
  static final String id = '_id';
  static final String age = '_age';
  static final String nickName = '_nickName';
  static final String firstName = '_firstName';
  static final String lastName = '_lastName';
  static final String gender = '_gender';
  static final String weight = '_weight';

  static final String lPp = '_lPp';
  static final String lPm = '_lPm';
  static final String lPd = '_lPd';

  static final String hPp = '_hPp';
  static final String hPm = '_hPm';
  static final String hPd = '_hPd';
  static final String dGen = '_dGen';
  static final String offAx = '_offAx';
  static final String offAy = '_offAy';

  // Types
  static final String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

  static final Map<String, Object> values = {
    id: int,
    age: int,
    nickName: String,
    firstName: String,
    lastName: String,
    gender: String,
    weight: int,
    lPp: double,
    lPm: double,
    lPd: double,
    hPp: double,
    hPm: double,
    hPd: double,
    dGen: double,
    offAx: double,
    offAy: double,
  };

  String valueList2SQL() {
    final List<String> keyList = values.keys.toList();
    return keyList
        .getRange(1, keyList.length)
        .map((ele) => '$ele ${switchSQLType(values[ele])}')
        .join(''',
      ''');
  }

  String switchSQLType(var variable) {
    switch (variable) {
      case int:
        return 'INTEGER NOT NULL';
      case String:
        return 'TEXT NOT NULL';
      case bool:
        return 'BOOLEAN NOT NULL';
      case double:
        return 'REAL NOT NULL';
      default:
        return 'BLOB';
    }
  }

  String createTableString(String dbName) {
    return '''CREATE TABLE $dbName (
      $id $idType,
      ${valueList2SQL()}
      )
      ''';
  }
}
