import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/MarketModel.dart';
import 'package:ax_dapp/pages/scout/models/SportsModel/MLBAthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/SportsModel/NFLAthleteScoutModel.dart';
import 'package:ax_dapp/repositories/CoinGeckoRepo.dart';
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/repositories/subgraph/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:ax_dapp/service/TokenList.dart';
import 'package:ax_dapp/service/athleteModels/SportAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/athleteModels/nfl/NFLAthlete.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/market_data.dart';

class GetScoutAthletesDataUseCase {
  static const collateralizationMultiplier = 1000;
  static const collateralizationPerPair = 15;
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
        athletes.addAll(_mapAthleteToScoutModel(
            response, _repos.values.elementAt(key), axPrice));
      });
      return athletes;
    }
  }

  Future<List<TokenPair>> fetchSpecificPairs(String token) async {
    final response = await graphRepo.querySpecificPairs(token);
    if (!response.isLeft()) return List.empty();
    final prefixInfos = response.getLeft().toNullable()!['prefix'];
    final suffixInfos = response.getLeft().toNullable()!['suffix'];
    List<TokenPair> prefixPairs = prefixInfos
        .map<TokenPair>(
            (pair) => TokenPair.fromJson(pair as Map<String, dynamic>))
        .toList();
    List<TokenPair> suffixPairs = suffixInfos
        .map<TokenPair>(
            (pair) => TokenPair.fromJson(pair as Map<String, dynamic>))
        .toList();
    final pairs = [...prefixPairs, ...suffixPairs];
    return pairs;
  }

  MarketModel getMarketModel(String strTokenAddr, double bookPrice) {
    final String strAXTAddr = AXT.polygonAddress.toString().toUpperCase();
    // Looking for a pair which has the same token name as strTokenAddr (token address as uppercase)
    final int index0 = allPairs.indexWhere((pair) =>
        pair.token0.id.toUpperCase() == strTokenAddr &&
        pair.token1.id.toUpperCase() == strAXTAddr);
    final int index1 = allPairs.indexWhere((pair) =>
        pair.token0.id.toUpperCase() == strAXTAddr &&
        pair.token1.id.toUpperCase() == strTokenAddr);

    double marketPrice = 0.0;
    if (index0 >= 0) // if current token equals to token0 of the pair
      marketPrice = double.parse(allPairs[index0].reserve1) /
          double.parse(allPairs[index0].reserve0);
    else if (index1 >= 0) // if current token equals to token1 of the pair
      marketPrice = double.parse(allPairs[index1].reserve0) /
          double.parse(allPairs[index1].reserve1);

    double recentPrice = marketPrice;
    if (index0 >= 0 &&
        allPairs[index0].pairHourData!.length >
            0) // if current token equals to token0 of the pair
      recentPrice =
          double.parse(allPairs[index0].pairHourData![0].pair.reserve1) /
              double.parse(allPairs[index0].pairHourData![0].pair.reserve0);
    else if (index1 >= 0 &&
        allPairs[index1].pairHourData!.length >
            0) // if current token equals to token1 of the pair
      recentPrice =
          double.parse(allPairs[index1].pairHourData![0].pair.reserve0) /
              double.parse(allPairs[index1].pairHourData![0].pair.reserve1);

    if (index1 >= 0 && allPairs[index1].name.contains("JRLT")) {
      print("[Reserve0] ${allPairs[index1].pairHourData![0].pair.reserve0}");
      print("[Reserve1] ${allPairs[index1].pairHourData![0].pair.reserve1}");
    }

    if (marketPrice != recentPrice) {
      if (index1 >= 0) {
        print("[Reserve0] ${allPairs[index1].pairHourData![0].pair.reserve0}");
        print("[Reserve1] ${allPairs[index1].pairHourData![0].pair.reserve1}");
      }
      print("[Market Price] $marketPrice");
      print("[Recent Price] $recentPrice");
    }
    return MarketModel(
        marketPrice: marketPrice,
        recentPrice: recentPrice,
        bookPrice: bookPrice * collateralizationMultiplier);
  }

  List<AthleteScoutModel> _mapAthleteToScoutModel(List<SportAthlete> athletes,
      SportsRepo<SportAthlete> repo, double axPrice) {
    List<AthleteScoutModel> mappedAthletes = [];
    athletes.forEach(
      (athlete) {
        bool isIdFound = TokenList.idToAddress.containsKey(athlete.id);
        String strLongTokenAddr = isIdFound
            ? TokenList.idToAddress[athlete.id]![1].toUpperCase()
            : "";
        String strShortTokenAddr = isIdFound
            ? TokenList.idToAddress[athlete.id]![2].toUpperCase()
            : "";
        MarketModel longToken = getMarketModel(strLongTokenAddr, athlete.price);
        MarketModel shortToken = getMarketModel(
            strShortTokenAddr, collateralizationPerPair - athlete.price);
        AthleteScoutModel athleteScoutModel;
        switch (repo.sport) {
          case (SupportedSport.MLB):
            {
              final mlbAthlete = athlete as MLBAthlete;
              athleteScoutModel = MLBAthleteScoutModel(
                  id: mlbAthlete.id,
                  name: mlbAthlete.name,
                  position: mlbAthlete.position,
                  team: mlbAthlete.team,
                  longTokenBookPrice: longToken.bookPrice,
                  longTokenBookPriceUsd: longToken.bookPrice * axPrice,
                  shortTokenBookPrice: shortToken.bookPrice,
                  shortTokenBookPriceUsd: shortToken.bookPrice * axPrice,
                  sport: repo.sport,
                  time: mlbAthlete.timeStamp,
                  longTokenPrice: longToken.marketPrice,
                  shortTokenPrice: shortToken.marketPrice,
                  longTokenPriceUsd: longToken.marketPrice * axPrice,
                  shortTokenPriceUsd: shortToken.marketPrice * axPrice,
                  longTokenPercentage: longToken.percentage,
                  shortTokenPercentage: shortToken.percentage,
                  homeRuns: mlbAthlete.homeRuns,
                  strikeOuts: mlbAthlete.strikeOuts,
                  saves: mlbAthlete.saves,
                  stolenBases: mlbAthlete.stolenBases,
                  atBats: mlbAthlete.atBats,
                  weightedOnBasePercentage: mlbAthlete.weightedOnBasePercentage,
                  errors: mlbAthlete.errors,
                  inningsPlayed: mlbAthlete.inningsPlayed);
            }
            break;
          case (SupportedSport.NFL):
            {
              final nflAthlete = athlete as NFLAthlete;
              athleteScoutModel = NFLAthleteScoutModel(
                  id: nflAthlete.id,
                  name: nflAthlete.name,
                  position: nflAthlete.position,
                  team: nflAthlete.team,
                  longTokenBookPrice: longToken.bookPrice,
                  longTokenBookPriceUsd: longToken.bookPrice * axPrice,
                  shortTokenBookPrice: shortToken.bookPrice,
                  shortTokenBookPriceUsd: shortToken.bookPrice * axPrice,
                  sport: repo.sport,
                  time: nflAthlete.timeStamp,
                  longTokenPrice: longToken.marketPrice,
                  shortTokenPrice: shortToken.marketPrice,
                  longTokenPercentage: longToken.percentage,
                  shortTokenPercentage: shortToken.percentage,
                  longTokenPriceUsd: longToken.marketPrice * axPrice,
                  shortTokenPriceUsd: shortToken.marketPrice * axPrice,
                  passingYards: nflAthlete.passingYards,
                  passingTouchDowns: nflAthlete.passingTouchDowns,
                  reception: nflAthlete.reception,
                  receiveYards: nflAthlete.receiveYards,
                  receiveTouch: nflAthlete.receiveTouch,
                  rushingYards: nflAthlete.rushingYards,
                  offensiveSnapsPlayed: nflAthlete.offensiveSnapsPlayed,
                  defensiveSnapsPlayed: nflAthlete.defensiveSnapsPlayed);
            }
            break;
          default:
            {
              athleteScoutModel = AthleteScoutModel(
                id: athlete.id,
                name: athlete.name,
                position: athlete.position,
                team: athlete.team,
                longTokenBookPrice: longToken.bookPrice,
                longTokenBookPriceUsd: longToken.bookPrice * axPrice,
                shortTokenBookPrice: shortToken.bookPrice,
                shortTokenBookPriceUsd: shortToken.bookPrice * axPrice,
                //TODO: check for sport
                sport: repo.sport,
                time: athlete.timeStamp,
                longTokenPrice: longToken.marketPrice,
                shortTokenPrice: shortToken.marketPrice,
                longTokenPercentage: longToken.percentage,
                shortTokenPercentage: shortToken.percentage,
                longTokenPriceUsd: longToken.marketPrice * axPrice,
                shortTokenPriceUsd: shortToken.marketPrice * axPrice,
              );
            }
        }
        mappedAthletes.add(athleteScoutModel);
      },
    );
    return mappedAthletes;
  }
}
