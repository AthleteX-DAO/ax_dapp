import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueTimerStatus extends StatelessWidget {
  const LeagueTimerStatus({
    super.key,
    required this.league,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final timerStatus =
        context.select((LeagueGameBloc bloc) => bloc.state.timerStatus);
    final differenceInDays =
        context.select((LeagueGameBloc bloc) => bloc.state.differenceInDays);
    final differenceInHours =
        context.select((LeagueGameBloc bloc) => bloc.state.differenceInHours);
    final differenceInMinutes =
        context.select((LeagueGameBloc bloc) => bloc.state.differenceInMinutes);
    final differenceInSeconds =
        context.select((LeagueGameBloc bloc) => bloc.state.differenceInSeconds);
    var textSize = 14.0;
    var leagueTitleTextSize = 18.0;
    if (_width <= 800) {
      textSize = 12.0;
      leagueTitleTextSize = 14.0;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            league.name,
            style: textStyle(
              Colors.amber[400]!,
              leagueTitleTextSize,
              isBold: false,
              isUline: false,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${league.dateStart} - ${league.dateEnd}',
            style: textStyle(
              Colors.grey[400]!,
              textSize,
              isBold: false,
              isUline: false,
            ),
          ),
          const SizedBox(height: 10),
          if (timerStatus.isPending) ...[
            Text(
              '$differenceInDays Days $differenceInHours Hours $differenceInMinutes Minutes $differenceInSeconds Seconds Until ${league.name} Begins!',
              style: textStyle(
                Colors.grey[400]!,
                textSize,
                isBold: false,
                isUline: false,
              ),
            ),
          ] else if (timerStatus.hasStarted) ...[
            Text(
              '$differenceInDays Days $differenceInHours Hours $differenceInMinutes Minutes $differenceInSeconds Seconds Remaining',
              style: textStyle(
                Colors.grey[400]!,
                textSize,
                isBold: false,
                isUline: false,
              ),
            ),
          ] else ...[
            Text(
              '${league.name} Has Ended!',
              style: textStyle(
                Colors.grey[400]!,
                textSize,
                isBold: false,
                isUline: false,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
