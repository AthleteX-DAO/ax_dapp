// File for getting the price of any APT  from the DEX using Postgres instead
// of http

import 'dart:developer';

import 'package:ax_dapp/service/athlete.dart';
import 'package:postgres/postgres.dart';

class Prices {
  Prices() {
    confirmConnection();
  }

  late Athlete athlete;
  late PostgreSQLConnection connection;

  void getBookPrice() {
    //
  }

  Future<void> connect() async {
    connection = PostgreSQLConnection(
      '139.99.74.201',
      8812,
      'qdb',
      username: 'admin',
      password: 'quest',
    );
    log('[Postgres] attempting connection to database...');
  }

  Future<void> confirmConnection() async {
    connection = PostgreSQLConnection(
      '139.99.74.201',
      8812,
      'qdb',
      username: 'admin',
      password: 'quest',
    );
    try {
      await connection
          .open()
          .then((value) => log('[Postgres] connection confirmed /n $value'));
    } catch (e) {
      log('[Postgres] error attempting to open connection : \n $e');
    }
  }

  void getMarketPrice() {}

  Future<void> query(String name) async {
    final List<List<dynamic>> results = await connection.query(
      '''SELECT @name, first(price) as StartingPrice, last(price) as LatestPrice from nfl''',
      substitutionValues: {'name': name},
    );

    for (final row in results) {
      final a = row[0];
      final b = row[0];
      log('[Postgres]: query results: \n$a \n$b');
    }

    // List<List<dynamic>> results = await connection.query("SELECT a, b FROM
    // table WHERE a = @aValue", substitutionValues: {
    //     "aValue" : 3
    // });
  }

  Future<void> close() async {
    // close the Postgresql connection
    await connection.close();
    log('[Postgres]: connection closed');
  }
}
