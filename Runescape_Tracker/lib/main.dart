import 'package:flutter/material.dart';
import 'package:runescape_tracker/searchPlayer.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'favoriteRS3Search.dart';
import 'package:intl/intl.dart';
import 'testing.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:favorite_button/favorite_button.dart';
import 'globalVars.dart';
import 'package:search_page/search_page.dart';
class Person {
  final String name, description;
  final String id;

  Person(this.name, this.description, this.id);
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  var futureItems = await DatabaseHelper.instance.getList();
  await futureItems;

  itemNames.clear();
  for (var i in await futureItems) {

    itemNames.add(Person(i.name, i.description,i.id)
    );
  }
  print(itemNames);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
var items = [];
var searchedPlayerName;
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  var playerDataList = [];
  var searchedName = '';

  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("testing"),
        actions: [
          StarButton(
            iconSize: 45,
            valueChanged: (isStarred) {
              print('Is Favorite $isStarred)');
            },
          )
        ],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        controller: _pageController,
        children: [
          MyAppFav(),
          searchPlayer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        tooltip: 'Search Items',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Person>(
            items: itemNames,
            searchLabel: 'Search Items',
            suggestion: Center(
              child: Text('Filter people by name, surname or age'),
            ),
            failure: Center(
              child: Text('No person found :('),
            ),
            filter: (person) => [
              person.name,
              person.description,
              person.id.toString(),
            ],
            builder: (person) => ListTile(
              onTap: () async {
                await searchGE(person.id);
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      color: Colors.amber,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(testDataGlobal['item']['name']),
                            Text(testDataGlobal['item']['description']),
                            Text(testDataGlobal['item']['current']['price']),
                            ElevatedButton(
                              child: const Text('Close BottomSheet'),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              title: Text(person.name),
              subtitle: Text(person.description),
              trailing: Text('${person.id} yo'),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
              title: Text('Item Two'),
              icon: Icon(Icons.apps)
          ),
          BottomNavyBarItem(
              title: Text('Item Three'),
              icon: Icon(Icons.chat_bubble)
          ),
          BottomNavyBarItem(
              title: Text('Item Four'),
              icon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
}
