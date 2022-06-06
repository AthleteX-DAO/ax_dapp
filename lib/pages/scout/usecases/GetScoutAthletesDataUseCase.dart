import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/MarketModel.dart';
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/repositories/subgraph/SubGraphRepo.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:ax_dapp/service/athleteModels/SportAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/util/SupportedSports.dart';

class GetScoutAthletesDataUseCase {
  final SubGraphRepo graphRepo;
  final Map<SupportedSport, SportsRepo<SportAthlete>> _repos = Map();
  List<TokenPair> allPairs = [];

  GetScoutAthletesDataUseCase({required this.graphRepo, required List<SportsRepo<SportAthlete>> sportsRepos}) {
    sportsRepos.forEach((repo) {
      _repos[repo.sport] = repo;
    });
  }

  Future<List<AthleteScoutModel>> fetchSupportedAthletes(
      SupportedSport sportSelection) async {
    allPairs = await fetchSpecificPairs("AX");
    /// If specific sport is selected return athletes from that specific repo
    if (sportSelection != SupportedSport.ALL) {
      var repo = _repos[sportSelection]!;
      final List<SportAthlete> response = await repo.getSupportedPlayers();
      return _mapAthleteToScoutModel(response, repo);
    } else {
      /// if ALL sports is selected fetch for each sport and add athletes to a
      /// combined list
      final athletes = <AthleteScoutModel>[];
      final response = await Future.wait(_repos
          .map((key, repo) => MapEntry(key, repo.getSupportedPlayers()))
          .values);
      response.asMap().forEach((key, response) {
        athletes.addAll(_mapAthleteToScoutModel(response, _repos.values.elementAt(key)));
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

  MarketModel getMarketPrice(String strTokenName, bool isLong) {
    double marketPrice = 0.0;
    double recentPrice = 0.0;
    String strAXTokenName = "AthleteX";
    String strLongTokenPrefix = "Linear Long Token";
    String strShortTokenPrefix = "Linear Short Token";
    String strTokenFullName = isLong ? "$strTokenName $strLongTokenPrefix" : "$strTokenName $strShortTokenPrefix";
    final index0 = allPairs.indexWhere((pair) => pair.token0.name == strTokenFullName && pair.token1.name == strAXTokenName);
    final index1 = allPairs.indexWhere((pair) => pair.token0.name == strAXTokenName && pair.token1.name == strTokenFullName);
    if(index0 >= 0)
      marketPrice =  double.parse(allPairs[index0].token1Price);
    else if(index1 >= 0)
      marketPrice = double.parse(allPairs[index1].token0Price);
    
    return MarketModel(marketPrice: marketPrice, recentPrice: recentPrice);
  }

  List<AthleteScoutModel> _mapAthleteToScoutModel(
      List<SportAthlete> athletes, SportsRepo<SportAthlete> repo) {
    List<AthleteScoutModel> mappedAthletes = [];
    athletes.forEach((athlete) {
      //TODO DANGEROUS CHANGE THIS TO NOT BE COUPLED TO MLB
      final mlbAthlete = (athlete as MLBAthlete);
      MarketModel longToken = getMarketPrice(mlbAthlete.name, true);
      MarketModel shortToken = getMarketPrice(mlbAthlete.name, false);
      mappedAthletes.add(AthleteScoutModel(
          mlbAthlete.id,
          mlbAthlete.name,
          mlbAthlete.position,
          mlbAthlete.team,
          mlbAthlete.price,
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
          shortToken.marketPrice
      ));
    });
    return mappedAthletes;
  }
}
