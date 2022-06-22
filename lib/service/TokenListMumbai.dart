import 'package:ax_dapp/service/athleteModels/mlb/contracts/MLBTestContractIds.dart';

class TokenListMumbai {
   static Map<int, List<String>> idToAddress = {
    10002087: MLBTestContractIds.aaronJudge, //  0 - pair address, 1 - Long, 2 - Short
    10001365: MLBTestContractIds.bryceHarper,
    10001918: MLBTestContractIds.carlosCorrea,
    10007217: MLBTestContractIds.fernandoTatisJr,
    10000352: MLBTestContractIds.joseRamirez,
    10006794: MLBTestContractIds.juanSoto,
    10000908: MLBTestContractIds.marcusSemien,
    10001009: MLBTestContractIds.starlingMarte,
    10002094: MLBTestContractIds.treaTurner,
    10007501: MLBTestContractIds.vladimirGuerreroJr
  };

  static const List<List<dynamic>> namesList = [
    ["Aaron Judge", 10002087, "AJLT1010", "AJST1010"],
    ["Bryce Harper", 10001365, "BHLT1010", "BHST1010"],
    ["Carlos Correa", 10001918, "CCLT1010", "CCST1010"],
    ["Fernando Tatis Jr.", 10007217, "FTJLT1010", "FTJST1010"],
    ["Jose Ramirez", 10000352, "JRLT1010", "JRST1010"],
    ["Juan Soto", 10006794, "JSLT1010", "JSST1010"],
    ["Marcus Semien", 10000908, "MSLT1010", "MSST1010",], 
    ["Starling Marte", 10001009, "SMLT1010", "SMST1010"],
    ["Trea Turner", 10002094, "TTLT1010", "TTST1010"],
    ["Vladimir Guerrero Jr.", 10007501, "VGJLT1010", "VGJST1010"],
  ];
}
