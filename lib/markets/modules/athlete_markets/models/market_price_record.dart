import 'package:ax_dapp/service/athlete_models/athlete_price_record.dart';

class MarketPriceRecord {
  MarketPriceRecord({required this.longRecord, required this.shortRecord});

  final AthletePriceRecord longRecord;
  final AthletePriceRecord shortRecord;
}
