import 'package:mysql1/mysql1.dart';


main() async {
  var settings = ConnectionSettings(
      host: '192.185.4.67',
      port: 3306,
      user: 'epischen_burgest',
      password: 'Mv!R2NFZ]Kh)',
      db: 'epischen_hiscoresMain'
  );
  var conn = await MySqlConnection.connect(settings);

  var userId = 1;
  var results = await conn.query('select playerName from MasterTab where id = ?', [userId]);

  print(results);
}
