import 'package:mysql1/mysql1.dart';

main() async {
  /*
  var settings = ConnectionSettings(
      host: '192.185.4.67',
      port: 3306,
      user: 'epischen_burgest',
      password: 'Mv!R2NFZ]Kh)',
      db: 'epischen_hiscoresMain'
  );

   */
  var settings = ConnectionSettings(
      host: '192.185.4.67',
      port: 3306,
      user: 'epischen_admin2',
      password: 'Lansing002',
      db: 'epischen_grandExchangeItems'
  );
  var conn = await MySqlConnection.connect(settings);

  var results = await conn.query('select * from items order by id');
  for (var i in results) {
    print(i[2]);
  }
  // print(results);
}