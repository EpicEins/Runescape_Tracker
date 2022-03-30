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
    String path = join(documentsDirectory.path, 'main02.db');
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE userData (id INTEGER PRIMARY KEY, xp TEXT, level TEXT, rank TEXT, skillId TEXT)''');
      print("Something initialized");
    }, onUpgrade: (Database db, int oldV, int newV) async{
      await db.execute('''CREATE TABLE otherExpense (id INTEGER PRIMARY KEY, carName TEXT, date TEXT, location TEXT, odometer TEXT, 
       expenseName TEXT, dollarAmount TEXT, category TEXT, description TEXT)''');
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
    await db.execute('''CREATE TABLE userData (id INTEGER PRIMARY KEY, xp TEXT, level TEXT, rank TEXT, skillId TEXT)''');
  }

}

class SkillValuesSQL {
  final int? id;
  var level;
  var xp;
  var rank;
  var skillId;
  SkillValuesSQL({this.id, this.level, this.xp, this.rank, this.skillId});

  factory SkillValuesSQL.fromMap(Map<String, dynamic> json) => SkillValuesSQL(
      id: json['id'],
      level: json['level'],
      xp: json['xp'],
      rank: json['rank'],
      skillId: json['skillId'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'level': level,
      'xp': xp,
      'rank': rank,
      'skillId': skillId,
    };
  }

}

class otherExpenses {
  final int? id;
  final String odometer;
  final String carName;
  final String date;
  final String location;
  final String dollarAmount;
  final String category;
  final String description;
  final String expenseName;

  otherExpenses({this.id, required this.odometer, required this.carName,
    required this.date, required this.description, required this.location, required this.expenseName
    , required this.dollarAmount, required this.category,});

  factory otherExpenses.fromMap(Map<String, dynamic> json) => otherExpenses(
    id: json['id'],
    odometer: json['odometer'],
    dollarAmount: json['dollarAmount'],
    date: json['date'],
    carName: json['carName'],
    location: json['location'],
    expenseName: json['expenseName'],
    category: json['category'],
    description: json['description'],

  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'carName' : carName,
      'dollarAmount' : dollarAmount,
      'date' : date,
      'location' : location,
      'odometer' : odometer,
      'description' : description,
      'expenseName' : expenseName,
      'category' : category,
    };
  }

}

class carList {
  final int? id;
  final String odometer;
  final String name;
  final String make;
  final String model;
  final String year;

  carList({this.id, required this.odometer, required this.name,
    required this.make, required this.model, required this.year});

  factory carList.fromMap(Map<String, dynamic> json) => carList(
    id: json['id'],
    odometer: json['odometer'],
    name: json['name'],
    make: json['make'],
    model: json['model'],
    year: json['year'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'odometer' : odometer,
      'name' : name,
      'make' : make,
      'model' : model,
      'year' : year,
    };
  }

}