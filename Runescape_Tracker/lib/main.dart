import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'favoriteRS3Search.dart';
import 'package:intl/intl.dart';
import 'testing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class searchedStats {
  searchedStats({required this.id, required this.skills});

  @HiveField(0)
  int id;

  @HiveField(1)
  String skills;

  @override
  String toString() {
    return id.toString();
  }
}

class _HomeState extends State<Home> {
  late Box PlayerBox;
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
      appBar: AppBar(
        title: Text("Runescape 3 Hiscores"),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyAppFav())).then((value) {
                  setState(() {// closes app drawer after returning from vehicle screen
                  });
                });
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("Searched Player: $searchedName")],
              ),
            )),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text("Create"),
                  onPressed: () async {
                    await DatabaseHelper.instance.dropInsert();
                    setState(() {});
                  },
                ),
                ElevatedButton(
                  child: const Text("Search"),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 175,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        label: const Text("Player Name"),
                                      ),
                                      controller: _playerVarController,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          final playerVar =
                                              _playerVarController.text;

                                          _playerVarController.clear();

                                          Navigator.pop(context);
                                          await DatabaseHelper.instance
                                              .dropInsert();
                                          await returnSkillList(playerVar);
                                          setState(() {
                                            searchedName = playerVar;
                                          });
                                        },
                                        child: const Text("Submit"))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                ElevatedButton(
                    child: const Text("Print"),
                    onPressed: () async {
                      await DatabaseHelper.instance.dropInsert();
                      await returnSkillList('madoshi');
                      setState(() {});
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
