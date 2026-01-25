import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:tokens_repository/tokens_repository.dart';

class GetScoutAthletesDataUseCase {
  const GetScoutAthletesDataUseCase({
    this.tokensRepository,
    this.graphRepo,
    this.sportsRepos = const [],
  });

  final Object? tokensRepository;
  final Object? graphRepo;
  final List<Object?> sportsRepos;

  Future<List<AthleteScoutModel>> fetchSupportedAthletes(
    SupportedSport supportedSport,
  ) async {
    return const [];
  }
}
