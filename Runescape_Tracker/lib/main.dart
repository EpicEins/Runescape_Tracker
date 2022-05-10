import 'package:flutter/material.dart';
import 'package:runescape_tracker/adventuresLog.dart';
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
  checkThemeColor() {
    if (switchVal == true) {
      themeColor = Color.fromRGBO(24,41,51,10);
    } else if (switchVal == false) {
      themeColor = Color.fromRGBO(124,101,76, 10);
    }
  }
  checkThemeColor();
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  var futureItems = await DatabaseHelper.instance.getList();
  var futureItemsOldschool = await DatabaseHelper.instance.getListOldschool();
  await futureItems;
  await futureItemsOldschool;

  itemNames.clear();
  itemNamesOldschool.clear();
  for (var i in await futureItems) {

    itemNames.add(Person(i.name, i.description,i.id)
    );
  }
  for (var i in await futureItemsOldschool) {

    itemNamesOldschool.add(Person(i.name, i.description,i.id)
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(24,41,51,10),
        ),
      ),
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
  var appBarTitle = "Player Search";

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

  checkThemeColor() {
    if (switchVal == true) {
      themeColor = Color.fromRGBO(24,41,51,10);
    } else if (switchVal == false) {
      themeColor = Color.fromRGBO(124,101,76, 10);
    }
  }
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  var playerDataList = [];
  var searchedName = '';
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    checkThemeColor();
    super.initState();
    fabHideOrShow = false;
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
        backgroundColor: themeColor,
        title: Text(appBarTitle),
        
        actions: [
          Switch(value: switchVal, onChanged: (bool value) {
            setState(() {
              print(value);
              switchVal = value;
              checkThemeColor();
            });
          })
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
          searchPlayer(),
          MyAppFav(),
          playerAlog(),
        ],
      ),
      floatingActionButton: Visibility(
        visible: fabHideOrShow,
        child: FloatingActionButton(
          backgroundColor: themeColor,
          child: Icon(Icons.search),
          tooltip: 'Search Items',
          onPressed: () {
            if (switchVal == true) {
              print("switchVal == true");
              showSearch(
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
                            height: 300,
                            color: themeColor,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.network(testDataGlobal[
                                  'item']
                                  ['icon_large']),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          testDataGlobal['item']['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          testDataGlobal['item']['description'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          testDataGlobal['item']['current']
                                          ['price'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                    trailing: Text('${person.id}'),
                  ),
                ),
              );
            } else if (switchVal == false) {
              print("switchVal == false");
              showSearch(
                context: context,
                delegate: SearchPage<Person>(
                  items: itemNamesOldschool,
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
                      await searchGEOldschool(person.id);
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            color: themeColor,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.network(testDataGlobal[
                                  'item']
                                  ['icon_large']),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          testDataGlobal['item']['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          testDataGlobal['item']['description'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          testDataGlobal['item']['current']
                                          ['price'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                    trailing: Text('${person.id}'),
                  ),
                ),
              );
            }
          }
        ),
      ),

      bottomNavigationBar: BottomNavyBar(
        backgroundColor: themeColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          setState(() {
            if (index == 0) {
              appBarTitle = "Player Search";
              _currentIndex = index;
              _pageController.jumpToPage(index);
              fabHideOrShow = false;
            } else if (index == 1) {
              appBarTitle = "Grand Exchange";
              _currentIndex = index;
              _pageController.jumpToPage(index);
              fabHideOrShow = true;
            } else if (index == 2) {
              appBarTitle = "Player Adventure Log";
              _currentIndex = index;
              _pageController.jumpToPage(index);
              fabHideOrShow = false;
            }
          });
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: const Text('Player Search'),
              icon: Icon(Icons.person_outline)
          ),
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: Text('GE Search'),
              icon: Icon(Icons.account_balance)
          ),
          BottomNavyBarItem(
              inactiveColor: Colors.white,
              activeColor: Colors.white,
              title: Text('Adventures Log'),
              icon: Icon(Icons.people_alt)
          ),
        ],
      ),
    );
  }
}
