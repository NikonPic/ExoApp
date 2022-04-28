import 'package:blueapp/03_database/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static final String tableUsers = 'users.db';
  static final String tableName = 'users';

  UserDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(tableUsers);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    WidgetsFlutterBinding.ensureInitialized();

    return await openDatabase(join(await getDatabasesPath(), filePath),
        version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final UserFields fields = UserFields();
    final String createSQL = fields.createTableString(tableName);
    await db.execute(createSQL);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<User> create(User user) async {
    final db = await instance.database;
    final id = await db.insert(tableName, user.toJson());
    return user.copyWith(id: id);
  }

  Future<User> readUser(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      columns: UserFields.values.keys.toList(),
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<User> readOrCreateUserByNickName(String nickName) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      columns: UserFields.values.keys.toList(),
      where: '${UserFields.nickName} = ?',
      whereArgs: [nickName],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      final User newUser = User.createDummy(nickName);
      await create(newUser);
      return newUser;
    }
  }

  Future<List<User>> readAllUsers() async {
    final orderBy = '${UserFields.age} ASC';

    final db = await instance.database;
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> update(User user) async {
    final db = await instance.database;
    return await db.update(
      tableName,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(String nickName) async {
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: '${UserFields.nickName} = ?',
      whereArgs: [nickName],
    );
  }
}
