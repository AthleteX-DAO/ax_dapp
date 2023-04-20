@JS()
library prizepool_factory;

import 'package:js/js.dart';

@JS()
class PrizePoolFactory {
  external PrizePoolFactory();

  external Future<dynamic> createLeague();
  external Future<dynamic> hello(); //This is to test js functionality
}
