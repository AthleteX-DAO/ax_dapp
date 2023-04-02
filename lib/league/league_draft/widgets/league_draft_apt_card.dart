import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';

class APTCard extends StatelessWidget {
  const APTCard({
    super.key,
    required this.apt,
    required this.onTeam,
  });

  final AthleteScoutModel apt;
  final bool onTeam;

  @override
  Widget build(BuildContext context) {
    const sportIconSize = 30.0;
    const statusIconSize = 30.0;
    var statusIcon = Icons.add_box_outlined;
    var statusIconColor = Colors.white;
    if (onTeam) {
      statusIcon = Icons.check_box_outlined;
      statusIconColor = Colors.green;
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
          Icon(
            getSportIcon(apt.sport),
            color: Colors.grey[400],
            size: sportIconSize,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(apt.name),
              Text(apt.team),
            ],
          ),
          Text('${apt.longTokenBookPrice?.toStringAsFixed(2)} AX'),
          Text('${apt.longTokenBookPricePercent}%'),
          Icon(
            statusIcon,
            color: statusIconColor,
            size: statusIconSize,
          )
        ],
      ),
    );
  }
}
