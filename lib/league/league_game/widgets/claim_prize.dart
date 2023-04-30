import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClaimPrize extends StatelessWidget {
  const ClaimPrize({
    super.key,
    required this.league,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.amber[400]!),
        ),
        child: TextButton(
          onPressed: () {
            context.read<LeagueGameBloc>().add(
                  ClaimPrizeEvent(
                    prizePoolAddress: league.prizePoolAddress,
                    winnerAddress: league.winner,
                  ),
                );
          },
          child: const Text(
            'CLAIM PRIZE',
            style: TextStyle(
              color: Colors.amber,
              fontFamily: 'OpenSans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
