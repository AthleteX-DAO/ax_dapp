@JS()
library prizepool_factory;

import 'package:js/js.dart';

@JS()
class PrizePoolFactory {
  external PrizePoolFactory();

  external Future<dynamic> createLeague(dynamic axToken, int entryFee, int leagueStartTime, int leagueEndTime);
  external Future<dynamic> hello(); //This is to test js functionality
}
