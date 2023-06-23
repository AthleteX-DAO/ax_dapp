import 'package:ax_dapp/league/league_search/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:league_repository/league_repository.dart';

class LeagueCard extends StatelessWidget {
  const LeagueCard({
    super.key,
    required this.leaguePair,
  });

  final Pair<League, List<LeagueTeam>> leaguePair;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var showToolTipIcon = true;
    var showDateRange = true;
    var textSize = 16.0;
    var axIconWidth = 30.0;
    var axIconHeight = 30.0;
    var sportIconSize = 30.0;
    if (_width <= 768) {
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
            params: {'leagueID': leaguePair.first.leagueID},
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LeagueName(
              width: _width,
              league: leaguePair.first,
              sportIconSize: sportIconSize,
              textSize: textSize,
            ),
            if (showDateRange)
              DateRange(
                width: _width,
                league: leaguePair.first,
                textSize: textSize,
              ),
            EntryFee(
              width: _width,
              axIconWidth: axIconWidth,
              axIconHeight: axIconHeight,
              league: leaguePair.first,
              textSize: textSize,
            ),
            PrizePool(
              width: _width,
              axIconWidth: axIconWidth,
              axIconHeight: axIconHeight,
              league: leaguePair.first,
              textSize: textSize,
              leagueTeams: leaguePair.second,
            ),
            if (showToolTipIcon)
              LeagueSearchPageToolTip(
                league: leaguePair.first,
                textSize: textSize,
              ),
          ],
        ),
      ),
    );
  }
}
