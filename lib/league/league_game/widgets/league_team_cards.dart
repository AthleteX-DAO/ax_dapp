import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/user_team.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueTeamCards extends StatelessWidget {
  const LeagueTeamCards({
    super.key,
    required this.userTeam,
    required this.rosters,
  });

  final UserTeam userTeam;
  final List<MapEntry<int, List<String>>> rosters;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final athletes =
        context.select((LeagueGameBloc bloc) => bloc.state.athletes);
    var formattedWalletAddress = '';
    var iconSize = 16.0;
    var textSize = 16.0;
    var percentageStatusIcon = 50.0;
    if (userTeam.address.isNotEmpty) {
      final walletAddressPrefix = userTeam.address.substring(0, 7);
      final walletAddressSuffix = userTeam.address.substring(
        userTeam.address.length - 5,
        userTeam.address.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }
    if (_width < 800) {
      iconSize = 12.0;
      textSize = 12.0;
      percentageStatusIcon = 25.0;
    }
    return ExpansionTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _width <= 800 ? formattedWalletAddress : userTeam.address,
            style: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'OpenSans',
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                getPercentageDesc(
                  userTeam.teamPerformance,
                ),
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: textSize,
                  color: getPercentageColor(
                    userTeam.teamPerformance,
                  ),
                ),
              ),
              Icon(
                getPercentStatusIcon(
                  userTeam.teamPerformance,
                ),
                size: percentageStatusIcon,
                color: getPercentageColor(
                  userTeam.teamPerformance,
                ),
              ),
            ],
          ),
          Visibility(
            visible: userTeam.address == walletAddress,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.amber[400]!),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Edit Teams',
                  style: TextStyle(
                    color: Colors.amber,
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      expandedAlignment: Alignment.center,
      textColor: Colors.white,
      iconColor: Colors.white,
      childrenPadding: const EdgeInsets.all(10),
      children: _width <= 800
          ? rosters.map((athleteName) {
              return Row(
                children: [
                  Icon(
                    getSportIcon(
                      athletes.getAthleteSport(
                        athleteName.key,
                      ),
                    ),
                    size: iconSize,
                  ),
                  const Spacer(),
                  Text(
                    athleteName.value[0],
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    athletes.getAthleteTeam(
                      athleteName.key,
                    ),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList()
          : [
              Row(
                children: rosters.map((athleteName) {
                  return Expanded(
                    child: Row(
                      children: [
                        Icon(
                          getSportIcon(
                            athletes.getAthleteSport(
                              athleteName.key,
                            ),
                          ),
                          size: iconSize,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            Text(
                              athleteName.value[0],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: 'OpenSans',
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              athletes.getAthleteTeam(
                                athleteName.key,
                              ),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: 'OpenSans',
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
    );
  }
}
