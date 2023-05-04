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
    final _width = MediaQuery.of(context).size.width;
    var sportIconSize = 30.0;
    var statusIconSize = 30.0;
    var textSize = 16.0;
    var sportIconWR = .03;
    var athleteNameWR = .1;
    var moveIconWR = .05; 

    if (_width <= 800) {
      sportIconSize = 20.0;
      statusIconSize = 20.0;
      textSize = 14.0;
      sportIconWR = .025;
      athleteNameWR = .2;
      moveIconWR = .04;
    }

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
          FittedBox(
            child: SizedBox(
              width: width * sportIconWR,
              child: Icon(
                getSportIcon(apt.sport),
                color: Colors.grey[400],
                size: sportIconSize,
              ),
            ),
          ),
          FittedBox(
            child: SizedBox(
              width: width * athleteNameWR,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * athleteNameWR,
                    child: Text(
                      apt.name,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * athleteNameWR,
                    child: Text(
                      apt.team,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                        fontSize: textSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FittedBox(
            child: SizedBox(
              width: width * moveIconWR,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle_outline_outlined,
                  color: Colors.white,
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
            ),
          )
        ],
      ),
    );
  }
}
