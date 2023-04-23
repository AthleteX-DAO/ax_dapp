import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/models/draft_apt.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTeamCard extends StatelessWidget {
  const MyTeamCard({
    super.key,
    required this.apt,
    required this.width,
    required this.height,
  });

  final DraftApt apt;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    const sportIconSize = 30.0;
    const statusIconSize = 30.0;
    const statusIconColor = Colors.white;

    // WR = width ratio
    const sportIconWR = .03;
    const athleteNameWR = .1;
    const moveIconWR = .05;

    return Container(
      height: 90,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF646464),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: width * sportIconWR,
            child: Icon(
              getSportIcon(apt.sport),
              color: Colors.grey[400],
              size: sportIconSize,
            ),
          ),
          SizedBox(
            width: width * athleteNameWR,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  apt.name,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  apt.team,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * moveIconWR,
            child: IconButton(
              icon: const Icon(
                Icons.remove_circle_outline_outlined,
                color: statusIconColor,
                size: statusIconSize,
              ),
              onPressed: () {
                context.read<LeagueDraftBloc>().add(
                      RemoveAptFromTeam(
                        apt: apt,
                      ),
                    );
              },
            ),
          )
        ],
      ),
    );
  }
}
