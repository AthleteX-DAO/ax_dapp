import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';

class APTCard extends StatelessWidget {
  const APTCard({
    super.key,
    required this.apt,
    required this.teamSize,
    required this.height,
  });

  final DraftApt apt;
  final int teamSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var sportIconSize = 30.0;
    var statusIconSize = 30.0;
    var textSize = 16.0;
    var bookPriceTextSize = 16.0;
    var showBookPricePercentChange = true;

    if (_width <= 768) {
      sportIconSize = 20.0;
      statusIconSize = 20.0;
      textSize = 12.0;
      showBookPricePercentChange = false;
      bookPriceTextSize = 10.0;
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
              width: _width * 0.1,
              child: Icon(
                getSportIcon(apt.sport),
                color: Colors.grey[400],
                size: sportIconSize,
              ),
            ),
          ),
          FittedBox(
            child: SizedBox(
              width: _width <= 768 ? _width * 0.25 : _width * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: SizedBox(
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
                  ),
                  FittedBox(
                    child: SizedBox(
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
                  ),
                ],
              ),
            ),
          ),
          FittedBox(
            child: SizedBox(
              width: _width * 0.1,
              child: Text(
                '${apt.bookPrice?.toStringAsFixed(2)} AX',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                  fontSize: bookPriceTextSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          if (showBookPricePercentChange)
            FittedBox(
              child: SizedBox(
                width: _width * 0.05,
                child: Text(
                  '${apt.bookPricePercent?.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          FittedBox(
            child: SizedBox(
              width: _width <= 768 ? _width * 0.15 : _width * 0.05,
              child: IconButton(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: statusIconSize,
                ),
                onPressed: () {
                  context.read<LeagueDraftBloc>().add(
                        AddAptToTeam(
                          apt: apt,
                          teamSize: teamSize,
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
