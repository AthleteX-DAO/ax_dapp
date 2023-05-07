import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/league_game/widgets/widgets.dart';
import 'package:ax_dapp/util/snackbar_warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';

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
            context.showSnackBarWarning(
              warningMessage:
                  'Cannot Edit League At This Time Because Either The League Has Started Or Ended',
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
    );
  }
}
