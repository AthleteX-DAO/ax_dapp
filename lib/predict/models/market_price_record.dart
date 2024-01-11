import 'package:ax_dapp/service/prediction_models/prediction_price_record.dart';

class MarketPriceRecord {
  MarketPriceRecord({required this.yesRecord, required this.noRecord});

  final PredictionPriceRecord yesRecord;
  final PredictionPriceRecord noRecord;
}
