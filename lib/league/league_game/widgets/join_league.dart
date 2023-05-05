import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_draft/views/desktop_league_draft.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/calculate_team_performance_usecase.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class JoinLeague extends StatelessWidget {
  const JoinLeague({
    super.key,
    required this.league,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    final leagueTeams =
        context.select((LeagueGameBloc bloc) => bloc.state.leagueTeams);
    final isWalletConnected =
        context.read<WalletBloc>().state.isWalletConnected;
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final athletes =
        context.select((LeagueGameBloc bloc) => bloc.state.athletes);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!),
      ),
      child: TextButton(
        onPressed: () {
          if (isWalletConnected) {
            final existingTeam = leagueTeams.firstWhere(
              (team) => team.userWalletID == walletAddress,
              orElse: () => LeagueTeam.empty,
            );
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => BlocProvider(
                  create: (context) => LeagueDraftBloc(
                    athletes: athletes,
                    leagueRepository: context.read<LeagueRepository>(),
                    getTotalTokenBalanceUseCase: GetTotalTokenBalanceUseCase(
                      walletRepository: context.read<WalletRepository>(),
                      tokensRepository: context.read<TokensRepository>(),
                    ),
                    calculateTeamPerformanceUseCase:
                        context.read<CalculateTeamPerformanceUseCase>(),
                    prizePoolRepository: context.read<PrizePoolRepository>(),
                    streamAppDataChangesUseCase:
                        context.read<StreamAppDataChangesUseCase>(),
                    walletRepository: context.read<WalletRepository>(),
                    isEditing: false,
                    leagueTeam: existingTeam,
                  ),
                  child: DesktopLeagueDraft(
                    league: league,
                    existingTeam: existingTeam,
                  ),
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: const Text(
          'Join League',
          style: TextStyle(
            color: Colors.amber,
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
