import 'package:ax_dapp/league/models/league.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class LeagueSearchPageToolTip extends StatelessWidget {
  const LeagueSearchPageToolTip({
    super.key,
    required this.league,
    required this.textSize,
  });

  final League league;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      height: 50,
      padding: const EdgeInsets.all(10),
      verticalOffset: -100,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      richMessage: TextSpan(
        children: [
          TextSpan(
            text: 'Name: ',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: '${league.name}\n',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: 'Max Teams: ',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: '${league.maxTeams}\n',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: 'Team Size: ',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: '${league.teamSize}\n',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: 'Sport(s): ',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text:
                '${league.sports.map((e) => e.convertToSportString()).join(', ')}\n',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
      child: const Icon(
        Icons.info_outline_rounded,
        color: Colors.grey,
        size: 25,
      ),
    );
  }
}
