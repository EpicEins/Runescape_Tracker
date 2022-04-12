import 'package:flutter/material.dart';
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

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main10.db');
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



  Future<List<SkillValuesSQL>> getList() async {
    Database db = await instance.database;
    var organizedContent = await db.query('userData', orderBy: 'id');
    List<SkillValuesSQL> groceryList = organizedContent.isNotEmpty
        ? organizedContent.map((c) => SkillValuesSQL.fromMap(c)).toList()
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


