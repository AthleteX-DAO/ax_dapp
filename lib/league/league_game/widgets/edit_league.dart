import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/league/widgets/dialogs/edit_rules_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLeague extends StatelessWidget {
  const EditLeague({
    super.key,
    required this.league,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LeagueGameBloc>();
    final timerStatus =
        context.select((LeagueGameBloc bloc) => bloc.state.timerStatus);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!),
      ),
      child: TextButton(
        onPressed: () {
          if (timerStatus.hasStarted || timerStatus.hasEnded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.transparent,
                content: Text(
                  'Cannot Edit League At This Time Because Either The League Has Started Or Ended',
                  style: TextStyle(
                    color: Colors.amber,
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: EditRulesDialog(
                  league: league,
                ),
              ),
            );
          }
        },
        child: const Text(
          'Edit League',
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
