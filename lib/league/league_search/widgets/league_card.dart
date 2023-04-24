import 'package:ax_dapp/league/league_search/widgets/widgets.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeagueCard extends StatelessWidget {
  const LeagueCard({
    super.key,
    required this.league,
    required this.leagueTeams,
  });

  final League league;
  final List<LeagueTeam> leagueTeams;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var showToolTipIcon = true;
    var showDateRange = true;
    var textSize = 16.0;
    var axIconWidth = 30.0;
    var axIconHeight = 30.0;
    var sportIconSize = 30.0;
    if (_width < 800) {
      showToolTipIcon = false;
      showDateRange = false;
      textSize = 12.0;
      axIconWidth = 15.0;
      axIconHeight = 15.0;
      sportIconSize = 15.0;
    }
    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          context.goNamed(
            'league-game',
            params: {'leagueID': league.leagueID},
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LeagueName(
              width: _width,
              league: league,
              sportIconSize: sportIconSize,
              textSize: textSize,
            ),
            if (showDateRange)
              DateRange(
                width: _width,
                league: league,
                textSize: textSize,
              ),
            EntryFee(
              width: _width,
              axIconWidth: axIconWidth,
              axIconHeight: axIconHeight,
              league: league,
              textSize: textSize,
            ),
            PrizePool(
              width: _width,
              axIconWidth: axIconWidth,
              axIconHeight: axIconHeight,
              league: league,
              textSize: textSize,
              leagueTeams: leagueTeams,
            ),
            if (showToolTipIcon)
              LeagueSearchPageToolTip(
                league: league,
                textSize: textSize,
              ),
          ],
        ),
      ),
    );
  }
}
