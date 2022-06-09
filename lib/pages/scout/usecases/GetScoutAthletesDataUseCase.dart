import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/MarketModel.dart';
import 'package:ax_dapp/repositories/CoinGeckoRepo.dart';
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/repositories/subgraph/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:ax_dapp/service/TokenList.dart';
import 'package:ax_dapp/service/athleteModels/SportAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/market_data.dart';

class GetScoutAthletesDataUseCase {
  static const collateralizationMultiplier = 1000;
  final SubGraphRepo graphRepo;
  final CoinGeckoRepo coinGeckoRepo;
  final Map<SupportedSport, SportsRepo<SportAthlete>> _repos = Map();
  List<TokenPair> allPairs = [];

  GetScoutAthletesDataUseCase(
      {required this.graphRepo,
      required this.coinGeckoRepo,
      required List<SportsRepo<SportAthlete>> sportsRepos}) {
    sportsRepos.forEach((repo) {
      _repos[repo.sport] = repo;
    });
  }

  Future<double> fetchAxPrice() async {
    final axPrice;
    CoinGeckoResult axMarketData = await coinGeckoRepo.getAxPrice();
    List<MarketData> axDataByCurrency =
        axMarketData.data.marketData.dataByCurrency;
    axPrice = axDataByCurrency.firstWhere((axPrice) => axPrice.coinId == 'usd');
    print("AX Price: ${axPrice.currentPrice}");
    return axPrice.currentPrice ?? 0.0;
  }

  Future<List<AthleteScoutModel>> fetchSupportedAthletes(
      SupportedSport sportSelection) async {
    allPairs = await fetchSpecificPairs("AX");
    //fetching AX Price
    final axPrice = await fetchAxPrice();
    /// If specific sport is selected return athletes from that specific repo
    if (sportSelection != SupportedSport.ALL) {
      var repo = _repos[sportSelection]!;
      final List<SportAthlete> response = await repo.getSupportedPlayers();
      return _mapAthleteToScoutModel(response, repo, axPrice);
    } else {
      /// if ALL sports is selected fetch for each sport and add athletes to a
      /// combined list
      final athletes = <AthleteScoutModel>[];
      final response = await Future.wait(_repos
          .map((key, repo) => MapEntry(key, repo.getSupportedPlayers()))
          .values);
      response.asMap().forEach((key, response) {
        athletes.addAll(
            _mapAthleteToScoutModel(response, _repos.values.elementAt(key), axPrice));
      });
      return athletes;
    }
  }

  Future<List<TokenPair>> fetchSpecificPairs(String token) async {
    final response = await graphRepo.querySpecificPairs(token);
    if(!response.isLeft())
      return List.empty();
    final prefixInfos = response.getLeft().toNullable()!['prefix'];
    final suffixInfos = response.getLeft().toNullable()!['suffix'];
    List<TokenPair> prefixPairs = 
      prefixInfos.map<TokenPair>((pair) => TokenPair.fromJson(pair as Map<String, dynamic>)).toList();
    List<TokenPair> suffixPairs = 
      suffixInfos.map<TokenPair>((pair) => TokenPair.fromJson(pair as Map<String, dynamic>)).toList();
    final pairs = [...prefixPairs, ...suffixPairs];
    return pairs;
  }

  MarketModel getMarketModel(String strTokenAddr) {
    final String strAXTAddr = AXT.polygonAddress.toString().toUpperCase();
    // Looking for a pair which has the same token name as strTokenAddr (token address as uppercase)
    final int index0 = 
      allPairs.indexWhere((pair) => pair.token0.id.toUpperCase() == strTokenAddr && pair.token1.id.toUpperCase() == strAXTAddr);
    final int index1 = 
      allPairs.indexWhere((pair) => pair.token0.id.toUpperCase() == strAXTAddr && pair.token1.id.toUpperCase() == strTokenAddr);

    double marketPrice = 0.0;
    if(index0 >= 0) // if current token equals to token0 of the pair
      marketPrice =  double.parse(allPairs[index0].token1Price);
    else if(index1 >= 0) // if current token equals to token1 of the pair
      marketPrice = double.parse(allPairs[index1].token0Price);

    double recentPrice = marketPrice;
    if(index0 >= 0 && allPairs[index0].pairHourData!.length > 0) // if current token equals to token0 of the pair
      recentPrice = double.parse(allPairs[index0].pairHourData![0].pair.token1Price);
    else if (index1 >=0 && allPairs[index1].pairHourData!.length > 0) // if current token equals to token1 of the pair
      recentPrice = double.parse(allPairs[index1].pairHourData![0].pair.token0Price);

    return MarketModel(marketPrice: marketPrice, recentPrice: recentPrice);
  }

  List<AthleteScoutModel> _mapAthleteToScoutModel(
      List<SportAthlete> athletes, SportsRepo<SportAthlete> repo, double axPrice) {
    List<AthleteScoutModel> mappedAthletes = [];
    athletes.forEach((athlete) {
      //TODO DANGEROUS CHANGE THIS TO NOT BE COUPLED TO MLB
      final mlbAthlete = (athlete as MLBAthlete);
      final String strLongTokenAddr = TokenList.idToAddress[mlbAthlete.id]![1].toUpperCase();
      final String strShortTokenAddr = TokenList.idToAddress[mlbAthlete.id]![2].toUpperCase();
      MarketModel longToken = getMarketModel(strLongTokenAddr);
      MarketModel shortToken = getMarketModel(strShortTokenAddr);
      
      mappedAthletes.add(AthleteScoutModel(
          mlbAthlete.id,
          mlbAthlete.name,
          mlbAthlete.position,
          mlbAthlete.team,
          mlbAthlete.price * collateralizationMultiplier,
          repo.sport,
          mlbAthlete.timeStamp,
          mlbAthlete.homeRuns,
          mlbAthlete.strikeOuts,
          mlbAthlete.saves,
          mlbAthlete.stolenBases,
          mlbAthlete.atBats,
          mlbAthlete.weightedOnBasePercentage,
          mlbAthlete.errors,
          mlbAthlete.inningsPlayed,
          longToken.marketPrice,
          shortToken.marketPrice,
          longToken.percentage,
          shortToken.percentage,
          mlbAthlete.price * collateralizationMultiplier * axPrice, 
          longToken.marketPrice * axPrice, 
          shortToken.marketPrice * axPrice,
      ));
    });
    return mappedAthletes;
  }
}
