import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';
import 'package:league_repository/league_repository.dart';

class LeagueName extends StatelessWidget {
  const LeagueName({
    super.key,
    required double width,
    required this.league,
    required this.sportIconSize,
    required this.textSize,
  }) : _width = width;

  final double _width;
  final League league;
  final double sportIconSize;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: _width * 0.2,
        child: Row(
          children: [
            Row(
              children: league.sports
                  .map(
                    (sport) => Icon(
                      getSportIcon(sport),
                      color: Colors.grey[400],
                      size: sportIconSize,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              width: 5,
            ),
            FittedBox(
              child: SizedBox(
                width: _width * 0.15,
                child: Text(
                  league.name,
                  style: TextStyle(
                    color: Colors.amber,
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
