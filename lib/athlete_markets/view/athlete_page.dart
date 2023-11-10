import 'package:ax_dapp/athlete_markets/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete_markets/widgets/athlete_page_web_view.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/controller/markets/long_short_pair_repository.dart.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class AthletePage extends StatefulWidget {
  const AthletePage({
    super.key,
    required this.athlete,
  });

  final AthleteScoutModel? athlete;

  @override
  State<AthletePage> createState() => _AthletePageState();
}

class _AthletePageState extends State<AthletePage> {
  late AthleteScoutModel athlete;

  Color indexUnselectedStackBackgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    athlete = widget.athlete!;
    final aptPair = context.read<TokensRepository>().currentAptPair(athlete.id);
    context.read<LongShortPairRepository>().tokenAddress = aptPair.address;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthletePageBloc(
        walletRepository: context.read<WalletRepository>(),
        tokensRepository: context.read<TokensRepository>(),
        mlbRepo: RepositoryProvider.of<MLBRepo>(context),
        nflRepo: RepositoryProvider.of<NFLRepo>(context),
        athlete: athlete,
        getScoutAthletesDataUseCase: GetScoutAthletesDataUseCase(
          tokensRepository: context.read<TokensRepository>(),
          graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
          sportsRepos: [
            RepositoryProvider.of<MLBRepo>(context),
            RepositoryProvider.of<NFLRepo>(context),
          ],
        ),
      ),
      child: BlocListener<AthletePageBloc, AthletePageState>(
        listener: (context, state) {
          if (state.failure is DisconnectedWalletFailure) {
            context.showWalletWarningToast();
          }
          if (state.failure is InvalidAthleteFailure) {
            context.showWarningToast(
              title: 'Error',
              description: 'Cannot add athlete to wallet',
            );
          }
        },
        child: BlocBuilder<AthletePageBloc, AthletePageState>(
          buildWhen: (previous, current) => previous.stats != current.stats,
          builder: (_, state) {
            final chartStats = state.stats;
            return AthletePageWebView(
              athlete: athlete,
              chartStats: chartStats,
            );
          },
        ),
      ),
    );
  }
}
