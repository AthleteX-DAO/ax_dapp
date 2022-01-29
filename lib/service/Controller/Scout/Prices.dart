// File for getting the price of any APT  from the DEX using Postgres instead of http

import 'package:ax_dapp/service/Athlete.dart';
import 'package:postgres/postgres.dart';

class Prices {
  late Athlete athlete;
  late PostgreSQLConnection connection;
  var databaseUrl;
  var firstPrice, lastPrice;

  void getBookPrice() {
    //
  }

  Prices() {
    confirmConnection();
  }

  void connect() async {
    connection = PostgreSQLConnection("139.99.74.201", 8812, "qdb",
        username: "admin", password: "quest");
    print('[Postgres] Attempting Connection to Database');
  }

  void confirmConnection() async {
    connection = PostgreSQLConnection("139.99.74.201", 8812, "qdb",
        username: "admin", password: "quest");
    try {
      await connection
          .open()
          .then((value) => {print('Connection confirmed /n $value')});
    } catch (e) {
      print('[Postgres] Error attempting to open connection : \n $e');
    }
  }

  void getMarketPrice() {}

  void query(String name) async {
    print("QUERY: this came in: $name");
    String query =
        "SELECT $name, first(price) as StartingPrice, last(price) as LatestPrice from nfl;";

    List<List<dynamic>> results = await connection.query(
        "SELECT @name, first(price) as StartingPrice, last(price) as LatestPrice from nfl",
        substitutionValues: {"name": name});

    for (final row in results) {
      var a = row[0];
      var b = row[0];
      print("results: $a \n $b");
    }

    // List<List<dynamic>> results = await connection.query("SELECT a, b FROM table WHERE a = @aValue", substitutionValues: {
    //     "aValue" : 3
    // });
  }

  void close() async {
    // close the Postgresql connection
    connection.close();
  }
}
