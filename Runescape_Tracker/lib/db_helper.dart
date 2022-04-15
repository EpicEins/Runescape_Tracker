import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'main.dart' as mainDart;


class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
/*
  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "exampleVersion2.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "exampleVersion2.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    var bomDataTable = await openDatabase(path, readOnly: true);

    return bomDataTable;

  }

 */


    Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'exampleVersion2.db');
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE userData (id INTEGER PRIMARY KEY, xp TEXT, level TEXT, rank TEXT, skillId TEXT, playerName TEXT)''');
      print("Something initialized");
    }, onUpgrade: (Database db, int oldV, int newV) async{
//      await db.execute('''DROP TABLE carList''');
//      await db.execute('''CREATE TABLE carList (id INTEGER PRIMARY KEY, name TEXT, make TEXT, model, TEXT, year TEXT, odometer TEXT)''');
      //print("carList table created");
    }

    );

  }



  Future<List<geItems>> getList() async {
    Database db = await instance.database;
    var organizedContent = await db.query('items', orderBy: 'name');
    List<geItems> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => geItems.fromMap(c)).toList()
        : [];
    return groceryList;
  }
  Future<List<geItems>> searchItems(searchedItem) async {
    Database db = await instance.database;

    var organizedContent = await db.query(
        "items",
        where:  "name LIKE ?",
        whereArgs: ['%$searchedItem%']
    );
    List<geItems> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => geItems.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<int> add(SkillValuesSQL skillValues) async {
    Database db = await instance.database;
    return await db.insert('userData', skillValues.toMap());
  }
  Future<int?> dropInsert() async {
    Database db = await instance.database;
    await db.execute('''DROP TABLE userData''');
    await db.execute('''CREATE TABLE userData (id INTEGER PRIMARY KEY, xp TEXT, level TEXT, rank TEXT, skillId TEXT, playerName TEXT)''');
  }

}

class SkillValuesSQL {
  final int? id;
  var level;
  var xp;
  var rank;
  var skillId;
  var playerName;
  SkillValuesSQL({this.id, this.level, this.xp, this.rank, this.skillId, this.playerName});

  factory SkillValuesSQL.fromMap(Map<String, dynamic> json) => SkillValuesSQL(
      id: json['id'],
      level: json['level'],
      xp: json['xp'],
      rank: json['rank'],
      skillId: json['skillId'],
      playerName: json['playerName'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'level': level,
      'xp': xp,
      'rank': rank,
      'skillId': skillId,
      'playerName': playerName,
    };
  }

}
class geItems {
  var icon;
  var icon_large;
  var id;
  var type;
  var typeIcon;
  var name;
  var description;
  var members;
  geItems({this.id, this.icon, this.icon_large, this.type, this.typeIcon, this.name,
  this.description, this.members});

  factory geItems.fromMap(Map<String, dynamic> json) => geItems(
    id: json['id'],
    icon: json['icon'],
    icon_large: json['icon_large'],
    typeIcon: json['typeIcon'],
    type: json['type'],
    name: json['name'],
    description: json['description'],
    members: json['members'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'icon': icon,
      'icon_large': icon_large,
      'typeIcon': typeIcon,
      'type': type,
      'name': name,
      'description': description,
      'members': members,
    };
  }

}

