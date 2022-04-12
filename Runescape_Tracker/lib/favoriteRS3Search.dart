import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:runescape_tracker/testing.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'main.dart';


Future<void> Favorite() async {
  WidgetsFlutterBinding.ensureInitialized();




  runApp(const MyAppFav());
}

class MyAppFav extends StatefulWidget {
  const MyAppFav({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

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
                        await testingSQL();
                        setState(() {

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
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

//https://apps.runescape.com/runemetrics/quests?user=madoshi api link for runemetrics quests search