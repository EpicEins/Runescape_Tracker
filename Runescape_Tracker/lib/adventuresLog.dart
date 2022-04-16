import 'package:flutter/material.dart';
import 'package:runescape_tracker/globalVars.dart';
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

  runApp(const playerAlog());
}

class playerAlog extends StatefulWidget {
  const playerAlog({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<playerAlog> {
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
                        testingCSV.clear();
                        var newPlayerVar = playerVar.replaceAll(" ", "%20");
                        await returnAlog(newPlayerVar);
                        value = _searchBarController.text;
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
                      alogList.clear();
                      setState(() {
                        _searchBarController.clear();
                      });
                    },
                    icon: Icon(Icons.clear))
              ],
            ),

            Visibility(
              visible: false,
              child: Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        testingCSV.clear();
                        await csvHiscores('madoshi');
                        setState(() {

                        });
                      },
                      child: Text("Testing"),
                    ),
                  )),
            ),
            Expanded(
              flex: 8,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all((8.0)),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(alogList[index]['date']),
                            Text(
                              alogList[index]['details'],
                              textAlign: TextAlign.center,
                            ),
                            Text(alogList[index]['text']),

                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: alogList.length,
              ),
            )

          ],
        ),
      ),
    );
  }
}
