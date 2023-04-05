import 'package:ax_dapp/league/models/draft_apt.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';

class APTCard extends StatelessWidget {
  const APTCard({
    super.key,
    required this.apt,
    required this.onTeam,
  });

  final DraftApt apt;
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
          Text('${apt.bookPrice?.toStringAsFixed(2)} AX'),
          Text('${apt.bookPricePercent?.toStringAsFixed(2)}%'),
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
