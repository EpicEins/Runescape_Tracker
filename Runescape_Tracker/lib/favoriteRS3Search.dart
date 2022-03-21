import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'db_helper.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


Future<void> Favorite() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  Hive.init(directory.path);
  await Hive.openBox("FavPlayers");
  //var deleteAll = await Hive.openBox("favoritePlayer");
  //deleteAll.clear();

  Hive.registerAdapter(PlayerAdapter());

  runApp(const MyAppFav());
}

class MyAppFav extends StatelessWidget {
  const MyAppFav({Key? key}) : super(key: key);

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

class _HomeState extends State<Home> {
  late Box FavoriteBox;
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _playerVarController = TextEditingController();

  @override
  void initState() {
    FavoriteBox = Hive.box("FavPlayers");
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
                    valueListenable: FavoriteBox.listenable(),
                    builder: (context, Box FavPlayers, _) {
                      return ListView.separated(
                        itemBuilder: (ctx, i) {
                          final key = FavPlayers.keys.toList()[i];
                          var value = FavPlayers.get(key);
                          value = value.split(",");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(value),
                            )
                          );
                        },
                        separatorBuilder: (_, i) => const Divider(),
                        itemCount: FavPlayers.keys.length,
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

}