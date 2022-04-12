import 'dart:math';
import 'db_helper.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'main.dart';
/*
main() async {
  var settings = ConnectionSettings(
      host: '192.185.4.67',
      port: 3306,
      user: 'epischen_burgest',
      password: 'Mv!R2NFZ]Kh)',
      db: 'epischen_hiscoresMain'
  );
  var conn = await MySqlConnection.connect(settings);

  var userId = 1;
  var results = await conn.query('select playerName from MasterTab where id = ?', [userId]);

  print(results);
}

 */

_iterateThrough(user) async {
  var continueCount = true;
  var counterLimit = 28;
  var counter = 0;
  var skillList = [];
  var overAllInit = SkillValues(user.totalskill, user.totalxp, user.rank, 30);
  skillList.add(overAllInit);
  while (continueCount == true) {
    for (var i in user.skillvalues) {
      //print(i.runtimeType);
      if (counter < counterLimit){
        var k = Map<String, dynamic>.from(i);
        var iObject = SkillValues(k['level'], k['xp'], k['rank'], k['id']);
        if (iObject.id.toString() == counter.toString()) {
          print(iObject.id);
          skillList.add(iObject);
          counter += 1;
        }
      }else {
        continueCount = false;
      }
    }

  }
  return skillList;
}
class User {
  final int magic; // need 13
  final int questsstarted;
  var questscompleted;
  final int questsnotstarted;
  final int totalxp;
  final int ranged;
  final List activities;
  final List skillvalues;
  final String name;
  final String rank;
  final int melee;
  final int combatlevel;
  var loggedin;
  var totalskill;



  User(this.magic, this.questsstarted, this.questscompleted, this.questsnotstarted, this.totalxp, this.ranged, this.activities, this.skillvalues,
      this.name, this.rank, this.melee, this.combatlevel, this.loggedin, this.totalskill);

  User.fromJson(Map<String, dynamic> json)
      : magic = json['magic'],
        questsstarted = json['questsstarted'],
        questscompleted = json['questscompleted'],
        questsnotstarted = json['questsnotstarted'],
        totalxp = json['totalxp'],
        ranged = json['ranged'],
        activities = json['activities'],
        skillvalues = json['skillvalues'],
        name = json['name'],
        rank = json['rank'],
        melee = json['melee'],
        combatlevel = json['combatlevel'],
        loggedin = json['loggedin'],
        totalskill = json['totalskill'];

  Map<String, dynamic> toJson() => {
    'magic': magic,
    'questsstarted': questsstarted,
    'questscompleted': questscompleted,
    'questsnotstarted': questsnotstarted,
    'totalxp': totalxp,
    'ranged': ranged,
    'activities': activities,
    'skillvalues': skillvalues,
    'name': name,
    'rank': rank,
    'melee': melee,
    'combatlevel': combatlevel,
    'loggedin': loggedin,
    'totalskill': totalskill,

  };
}
class Activities {
  final String date;
  final String details;
  final String text;


  Activities(this.date, this.details, this.text);

  Activities.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        details = json['details'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
    'date': date,
    'details': details,
    'text': text,
  };
}
class SkillValues {
  var level;
  var xp;
  var rank;
  var id;

  SkillValues(this.level, this.xp, this.rank, this.id);

  SkillValues.fromJson(Map<String, dynamic> json)
      : level = json['level'],
        xp = json['xp'],
        rank = json['rank'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
    'level': level,
    'xp': xp,
    'rank': rank,
    'id': id,
  };
}

main() async {
// https://apps.runescape.com/runemetrics/profile/profile?user=madoshi&activities=20
  var runescapeAPIData = await http
      .read(Uri.parse(
      'https://apps.runescape.com/runemetrics/profile/profile?user=madoshi&activities=20'));
  //print(runescapeAPIData);
  Map<String, dynamic> userMap = jsonDecode(runescapeAPIData);
  //print(userMap['questsstarted']);
  var user = User.fromJson(userMap);
  //_iterateThrough(user);
  //var testVar = await returnSkillList();
  //print("Testing: $testVar");
  //print(user.rank);
  //print('Howdy, ${user['skillvalues']}!');
}

returnSkillList(playerName) async {
// https://apps.runescape.com/runemetrics/profile/profile?user=madoshi&activities=20
  var runescapeAPIData = await http
      .read(Uri.parse(
      'https://apps.runescape.com/runemetrics/profile/profile?user=$playerName&activities=20'));
  //print(runescapeAPIData);
  Map<String, dynamic> userMap = jsonDecode(runescapeAPIData);
  //print(userMap['questsstarted']);
  var user = User.fromJson(userMap);
  var skillObjectList = await _iterateThrough(user);
  for (var i in skillObjectList) {
    if (i.id.toString() == '30') {
      var tempResult = i.rank.toString();
      var tmepResult2 = "Idk, this shit wak";
      var result = tempResult.replaceAll(",", "");
      await DatabaseHelper.instance.add(
        SkillValuesSQL(
          skillId: '0',
          level: i.level.toString(),
          rank: result.toString(),
          xp: i.xp.toString(),
          playerName: playerName.toString(),
        )
      );
    } else {
      var tempId = i.id + 1;
      await DatabaseHelper.instance.add(
          SkillValuesSQL(
            skillId: tempId,
            level: i.level.toString(),
            rank: i.rank.toString(),
            xp: i.xp.toString(),
            playerName: playerName.toString(),
          )
      );
    }
  }
}

returnAlog(playerName) async{
  var runescapeAPIData = await http
      .read(Uri.parse(
      'https://apps.runescape.com/runemetrics/profile/profile?user=$playerName&activities=20'));
  //print(runescapeAPIData);
  Map<String, dynamic> userMap = jsonDecode(runescapeAPIData);
  var user = User.fromJson(userMap);

  for (var i in user.activities) {
    print(i);
  }
}


testingSQL() async {
/*
  var settings = ConnectionSettings(
      host: '192.185.4.67',
      port: 3306,
      user: 'epischen_burgest',
      password: 'Mv!R2NFZ]Kh)',
      db: 'epischen_hiscoresMain'
  );

   */
  var settings = ConnectionSettings(
      host: '192.185.4.67',
      port: 3306,
      user: 'epischen_admin2',
      password: 'Lansing002',
      db: 'epischen_grandExchangeItems');
  var conn = await MySqlConnection.connect(settings);

  var results = await conn.query("select * from items where name like '%matto%'");
  for (var i in results) {
    items.add(i);
    print(i);
  }
// print(results);
}