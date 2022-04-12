import 'package:flutter/material.dart';
import 'package:runescape_tracker/main.dart';
import 'package:runescape_tracker/testing.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'favoriteRS3Search.dart';
import 'package:intl/intl.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  runApp(const searchPlayer());
}

class searchPlayer extends StatefulWidget {
  const searchPlayer({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<searchPlayer> {
  var skillNames = {
    30: "Overall",
    0: "Attack",
    1: "Defence",
    2: "Strength",
    3: "Constitution",
    4: "Ranged",
    5: "Prayer",
    6: "Magic",
    7: "Cooking",
    8: "Woodcutting",
    9: "Fletching",
    10: "Fishing",
    11: "Firemaking",
    12: "Crafting",
    13: "Smithing",
    14: "Mining",
    15: "Herblore",
    16: "Agility",
    17: "Thieving",
    18: "Slayer",
    19: "Farming",
    20: "Runecrafting",
    21: "Hunter",
    22: "Construction",
    23: "Summoning",
    24: "Dungeoneering",
    25: "Divination",
    26: "Invention",
    27: "Archaeology",
  };
  var skillNamesv2 = {
    0: "Overall",
    1: "Attack",
    2: "Defence",
    3: "Strength",
    4: "Constitution",
    5: "Ranged",
    6: "Prayer",
    7: "Magic",
    8: "Cooking",
    9: "Woodcutting",
    10: "Fletching",
    11: "Fishing",
    12: "Firemaking",
    13: "Crafting",
    14: "Smithing",
    15: "Mining",
    16: "Herblore",
    17: "Agility",
    18: "Thieving",
    19: "Slayer",
    20: "Farming",
    21: "Runecrafting",
    22: "Hunter",
    23: "Construction",
    24: "Summoning",
    25: "Dungeoneering",
    26: "Divination",
    27: "Invention",
    28: "Archaeology",
  };
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _playerVarController = TextEditingController();
  final _searchBarController = TextEditingController();
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  var playerDataList = [];
  var searchedName = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                      ),
                      controller: _searchBarController,
                      onSubmitted: (value) async {
                        final playerVar = _searchBarController.text;
                        searchedPlayerName = playerVar;

                        await DatabaseHelper.instance.dropInsert();
                        await returnSkillList(playerVar);
                        value = _searchBarController.text;
                        returnAlog(value);
                        setState(() {

                          setState(() {
                            searchedName = playerVar;
                          });
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await DatabaseHelper.instance.dropInsert();
                      setState(() {
                        _searchBarController.clear();
                      });
                    },
                    icon: Icon(Icons.clear))
              ],
            ),
            Expanded(
                flex: 8,
                child: Center(
                  child: FutureBuilder<List<SkillValuesSQL>>(
                      future: DatabaseHelper.instance.getList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SkillValuesSQL>> snapshot) {
                        if (!snapshot.hasData) {
                          print(snapshot);
                          return Center(child: Text('Loading...'));
                        }
                        return snapshot.data!.isEmpty
                            ? Center(child: Text('No items in List'))
                            : ListView(
                                children: snapshot.data!.map((SkillValuesSQL) {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                                child: Center(
                                              child: Container(
                                                child: Text(skillNamesv2[
                                                        int.parse(SkillValuesSQL
                                                            .skillId)]
                                                    .toString()),
                                              ),
                                            )),
                                            Expanded(
                                                child: Center(
                                              child: Container(
                                                child:
                                                    Text(SkillValuesSQL.level),
                                              ),
                                            )),
                                            Expanded(
                                                child: Center(
                                              child: Container(
                                                child: Text(myFormat.format(
                                                    int.parse(
                                                        SkillValuesSQL.xp))),
                                              ),
                                            )),
                                            Expanded(
                                                child: Center(
                                              child: Container(
                                                child: Text(myFormat.format(
                                                    int.parse(
                                                        SkillValuesSQL.rank))),
                                              ),
                                            )),
                                          ]),
                                    ),
                                  ));
                                }).toList(),
                              );
                      }),
                )),
          ],
        ),
      ),
    );
  }
}
