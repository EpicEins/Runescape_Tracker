import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Center(
                  child: Text("Testing"))),
          ],
        ),
      ),
    );
  }

}

//https://apps.runescape.com/runemetrics/quests?user=madoshi api link for runemetrics quests search