import 'dart:convert';

import 'package:sqflite/sqflite.dart';

enum DbDataTypes {
  Integer,
  Text,
  Real,
}

typedef FromJsonFunction(Map<String, dynamic> map);

abstract class BaseModel {
  static Database? _database;

  String tablaName = "";

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializedDataBase();
    }

    String name = this.toString().replaceAll("Instance of '", '');
    name = name.replaceAll("'", '').trim();
    this.tablaName = name;
    // try {
    //   await this.count();
    // } catch (e) {
    //   await this._createDb(_database, 1);
    // }
    return _database!;
  }

  String primaryKey();

  Map<String, DbDataTypes> fields();

  Future<Database> initializedDataBase() async {
    var databasesPath = await getDatabasesPath();
    String name = this.toString().replaceAll("Instance of '", '');
    name = name.replaceAll("'", '').trim();
    this.tablaName = name;

    String path = databasesPath + '/' + name;
    var db = await openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  Future<void> _createDb(Database db, int newVersion) async {
    String name = this.toString().replaceAll("Instance of '", '');
    name = name.replaceAll("'", '').trim();
    String query = "CREATE TABLE ${this.tablaName}";
    List fields = [this.primaryKey() + ' INTEGER PRIMARY KEY AUTOINCREMENT'];
    this.fields().forEach((key, value) {
      fields.add(
          "$key ${value.toString().replaceAll("DbDataTypes.", "").toUpperCase()}");
    });
    query = query + ' (' + fields.join(', ') + ' )';
    print(query);
    try {
      await db.execute(
        query,
      );
    } catch (e) {}
  }

  Future<void> createDb() async {
    Database database = await this.database;
    this._createDb(database, 1);
  }

  Future<int> insert(Map<String, dynamic> map) async {
    Database db = await this.database;
    Map<String, dynamic> dataToAdd = {};
    map.forEach((key, value) {
      if (value is Map ||
          value.runtimeType.toString().contains('_InternalLinkedHashMap')) {
        dataToAdd[key] = jsonEncode(value);
      } else {
        dataToAdd[key] = value;
      }
    });
    print(dataToAdd);
    return db.insert(this.tablaName, dataToAdd);
  }

  Future<int> update(int id, Map<String, dynamic> map) async {
    Database db = await this.database;
    print(map);
    return db.update(this.tablaName, map, where: "${this.primaryKey()} = $id");
  }

  Future<int> updateAll(List<int> list, Map<String, dynamic> map) async {
    Database db = await this.database;
    return db.update(this.tablaName, map,
        where: "${this.primaryKey()} IN (${list.join(',')})");
  }

  Future<List<int>> insertAll(List list) async {
    List<int> ids = [];
    list.forEach((element) async {
      ids.add(await this.insert(element));
    });
    return ids;
  }

  Future<void> truncate() async {
    Database db = await this.database;
    try {
      await db.rawDelete("delete from ${this.tablaName}");
    } catch (e) {
      await this._createDb(db, 1);
      this.truncate();
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      this.tablaName,
    );
    return result.toList();
  }

  Future<List<Map>> getAllFiltered(String key, String date) async {
    Database db = await this.database;

    List<Map<String, dynamic>> result = await db.query(
      this.tablaName,
      where: "${key} like '${date}'",
    );
    return result.toList();
  }

  Future<List<Map<String, dynamic>>> getAllWhere(String where) async {
    Database db = await this.database;

    List<Map<String, dynamic>> result = await db.query(
      this.tablaName,
      where: where,
    );
    return result.toList();
  }

  Future get(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      this.tablaName,
      limit: 1,
      where: "${this.primaryKey()} = $id",
    );
    return result.length > 0 ? result.first : null;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;

    return await db.rawDelete(
      'DELETE FROM ${this.tablaName} WHERE ${this.primaryKey()} = $id',
    );
  }

  Future<bool> exists(int id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      this.tablaName,
      limit: 1,
      columns: [
        this.primaryKey(),
      ],
      where: "${this.primaryKey()} = $id",
    );
    return result.length > 0;
  }

  Future<int> count() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
      'SELECT COUNT (*) from ${this.tablaName}',
    );
    return Sqflite.firstIntValue(x)!;
  }
}
