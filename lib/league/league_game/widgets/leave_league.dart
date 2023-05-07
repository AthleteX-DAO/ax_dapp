import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';

class LeaveLeague extends StatelessWidget {
  const LeaveLeague({
    super.key,
    required this.league,
    required this.leagueID,
  });

  final League league;
  final String leagueID;

  @override
  Widget build(BuildContext context) {
    final timerStatus =
        context.select((LeagueGameBloc bloc) => bloc.state.timerStatus);
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
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
        if (timerStatus.hasStarted || timerStatus.hasEnded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              content: Text(
                'Cannot Leave ${league.name} At This Time Because Either The League Has Started Or Ended',
                style: const TextStyle(
                  color: Colors.amber,
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          context.read<LeagueGameBloc>().add(
                LeaveLeagueEvent(
                  leagueID: leagueID,
                  userWalletID: walletAddress,
                  prizePoolAddress: league.prizePoolAddress,
                ),
              );
        }
      },
      child: const Text(
        'Leave League',
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
