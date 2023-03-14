import 'package:ax_dapp/pages/league/models/league.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';

class LeagueCard extends StatelessWidget {
  const LeagueCard({super.key, required this.league});

  final League league;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () => {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                Row(
                  children: league.sports
                      .map(
                        (sport) => Icon(
                          getSportIcon(sport),
                          color: Colors.grey[400],
                        ),
                      )
                      .toList(),
                ),
                Text(
                  league.name,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              '${league.dateStart} - ${league.dateEnd}',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/x.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  '${league.entryFee} AX',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/x.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                //TODO(anyone): get the prize pool for each league
                const Text(
                  '1000 AX',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              height: 50,
              padding: const EdgeInsets.all(10),
              verticalOffset: -100,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25),
              ),
              richMessage: TextSpan(
                //TODO(anyone): add relevant information to this tooltip
                text: '',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontFamily: 'OpenSans',
                ),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.grey,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
