import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_draft/views/desktop_league_draft.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/util/snackbar_warning.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';
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
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: Colors.amber[400]!),
          ),
        ),
      ),
      onPressed: () {
        if (isWalletConnected) {
          final existingTeam = leagueTeams.findLeagueTeam(walletAddress);
          if (existingTeam.userWalletID == walletAddress) {
            ScaffoldMessenger.of(context).showSnackBar(
              context.showSnackBarWarning(
                warningMessage: 'You Are Already In This League!',
              ),
            );
          } else if (leagueTeams.length == league.maxTeams) {
            ScaffoldMessenger.of(context).showSnackBar(
              context.showSnackBarWarning(
                warningMessage: 'The League is Full!',
              ),
            );
          } else {
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
                    leagueUseCase: context.read<LeagueUseCase>(),
                    prizePoolRepository: context.read<PrizePoolRepository>(),
                    streamAppDataChangesUseCase:
                        context.read<StreamAppDataChangesUseCase>(),
                    walletRepository: context.read<WalletRepository>(),
                    isEditing: false,
                    leagueTeam: existingTeam,
                    league: league,
                  ),
                  child: DesktopLeagueDraft(
                    league: league,
                    existingTeam: existingTeam,
                  ),
                ),
              ),
            );
          }
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
    );
  }
}
