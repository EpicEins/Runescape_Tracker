import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
@HiveType(typeId: 1)
class Player {
  Player({required this.name, required this.skills});

  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> skills;

  @override
  String toString() {
    return name;
  }
}



class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final typeId = 0;



  @override
  void write(BinaryWriter writer, Player obj) {
    // TODO: implement write
  }

  @override
  Player read(BinaryReader reader) {
    // TODO: implement read
    return Player(name: '', skills: []);
  }


}
