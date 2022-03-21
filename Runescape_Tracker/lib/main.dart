import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'favoriteRS3Search.dart';

late Box box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  Hive.init(directory.path);
  //await Hive.openBox("searchPlayer");
  var deleteAll = await Hive.openBox("searchPlayer");
  deleteAll.clear();

  Hive.registerAdapter(PlayerAdapter());

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

  @override
  void initState() {
    PlayerBox = Hive.box("searchPlayer");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Runescape 3 Hiscores"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Center(
                  child: ValueListenableBuilder(
                    valueListenable: PlayerBox.listenable(),
                    builder: (context, Box searchPlayer, _) {
                      return ListView.separated(
                        itemBuilder: (ctx, i) {
                          final key = searchPlayer.keys.toList()[i];
                          var value = searchPlayer.get(key);
                          value = value.split(",");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: Center(
                                          child: Container(
                                            child: Text(
                                                skillNames[key].toString()),
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Container(
                                            child: Text(value[1]),
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Container(
                                            child: Text(value[2]),
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Container(
                                            child: Text(value[0]),
                                          ),
                                        )),
                                  ]),
                            ),
                          );
                        },
                        separatorBuilder: (_, i) => const Divider(),
                        itemCount: searchPlayer.keys.length,
                      );
                    },
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text("Create"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        label: const Text("Key"),
                                      ),
                                      controller: _idController,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        label: Text("Value"),
                                      ),
                                      controller: _nameController,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          final key = _idController.text;
                                          final value = _nameController.text;

                                          PlayerBox.put(key, value);

                                          _nameController.clear();
                                          _idController.clear();

                                          Navigator.pop(context);
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
                                          int counter = 0;
                                          try {
                                            var cleanPlayerVar = playerVar
                                                .replaceAll(" ", "%20");
                                            var runescapeAPIData = await http
                                                .read(Uri.parse(
                                                'https://secure.runescape.com/m=hiscore/index_lite.ws?player=$cleanPlayerVar'));
                                            print(runescapeAPIData.runtimeType);
                                            var splitRunescapeAPIData = runescapeAPIData
                                                .split("\n");
                                            var tempVar;
                                            var key;
                                            var value;
                                            for (tempVar in splitRunescapeAPIData) {
                                              if (counter < 29) {
                                                key = counter;
                                                value = tempVar;
                                                //print("key is: $key");
                                                //print("value is: $value");
                                                counter += 1;
                                                PlayerBox.put(key, value);
                                              }
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
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
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
