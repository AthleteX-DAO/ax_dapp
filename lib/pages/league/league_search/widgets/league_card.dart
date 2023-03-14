import 'package:ax_dapp/pages/league/models/league.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';

class LeagueCard extends StatelessWidget {
  const LeagueCard({super.key, required this.league});

  final League league;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var showToolTipIcon = true;
    var textSize = 16.0;
    var axIconWidth = 30.0;
    var axIconHeight = 30.0;
    var sportIconSize = 30.0;
    if (_width < 800) {
      showToolTipIcon = false;
      textSize = 12.0;
      axIconWidth = 15.0;
      axIconHeight = 15.0;
      sportIconSize = 15.0;
    }
    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () => {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FittedBox(
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
                    Text(
                      league.name,
                      style: TextStyle(
                        color: Colors.amber,
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                width: _width * 0.2,
                child: Text(
                  '${league.dateStart} - ${league.dateEnd}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                width: _width * 0.2,
                child: Row(
                  children: [
                    Container(
                      width: axIconWidth,
                      height: axIconHeight,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/x.jpg'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${league.entryFee} AX',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                width: _width * 0.2,
                child: Row(
                  children: [
                    Container(
                      width: axIconWidth,
                      height: axIconHeight,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/x.jpg'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    //TODO(anyone): get the prize pool for each league
                    Text(
                      '1000 AX',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (showToolTipIcon)
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
                    fontSize: textSize,
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
