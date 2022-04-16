import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:runescape_tracker/searchPlayer.dart';
import 'package:runescape_tracker/testing.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'globalVars.dart';

import 'main.dart';


Future<void> Favorite() async {
  var futureItems = await DatabaseHelper.instance.getList();
  futureItems.clear();
  for (var i in futureItems) {
    itemNames.add(i.name);
  }
  print(itemNames);
  WidgetsFlutterBinding.ensureInitialized();




  runApp(const MyAppFav());
}

class MyAppFav extends StatefulWidget {
  const MyAppFav({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

var dataVar = DatabaseHelper.instance.getList();


class _HomeState extends State<MyAppFav> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _playerVarController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _searchBarController = TextEditingController();
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  var playerDataList = [];
  var searchedName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 8,
                child: Center(
                  child: FutureBuilder<List<geItems>>(
                      future: DatabaseHelper.instance.getList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<geItems>> snapshot) {
                        if (!snapshot.hasData) {
                          print(snapshot);
                          return Center(child: Text('Loading...'));
                        }
                        return snapshot.data!.isEmpty
                            ? Center(child: Text('No items in List'))
                            : ListView(
                          children: snapshot.data!.map((geItems) {
                            return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () async {
                                      await searchGE(geItems.id);
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            color: Color.fromRGBO(24,41,51,10),
                                            child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            testDataGlobal[
                                                                'item']['name'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            testDataGlobal[
                                                                    'item']
                                                                ['description'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          Text(
                                                            testDataGlobal['item']
                                                                        [
                                                                        'current']
                                                                    ['price']
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text(
                                                          'Close BottomSheet'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          );
                                        },
                                      );
                                    },
                                    leading: Text(geItems.id),
                                    title: Text(geItems.name),
                                    subtitle: Text(geItems.description),
                                    trailing: Text(geItems.members),
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

//https://apps.runescape.com/runemetrics/quests?user=madoshi api link for runemetrics quests search