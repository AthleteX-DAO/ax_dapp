import 'package:ax_dapp/markets/markets.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class OvertimeSportsAPI {
  OvertimeSportsAPI(this.dio) {
    initState();
  }

  final Dio dio;
  late String baseDataUrl;
  final API_URL = 'https://api.thalesmarket.io'; // base API URL
  final NETWORK_ID = 10; // optimism network ID
  final NETWORK = 'optimism'; // optimism network
  final PARLAY_AMM_CONTRACT_ADDRESS =
      '0x82B3634C0518507D5d817bE6dAb6233ebE4D68D9'; // ParlayAMM contract address on optimism
  final MARKET_ADDRESS = '0x82B3634C0518507D5d817bE6dAb6233ebE4D68D9';
  final POSITION = 0;
  final BUY_IN = 0;

  Future<void> initState() async {
    try {
      baseDataUrl = 'https://api.thalesmarket.io';
      String compiledurl =
          '$API_URL/overtime/networks/$NETWORK_ID/markets/$MARKET_ADDRESS/quote?position=$POSITION&buyIn=$BUY_IN';
    } catch (e) {
      throw Exception('Failed to load Overtime Markets! \n $e');
    }
  }
}
