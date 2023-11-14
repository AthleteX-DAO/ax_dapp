import 'package:flutter/material.dart';

class LeagueTeamHeader extends StatelessWidget {
  const LeagueTeamHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var textSize = 16.0;
    var titleName = 'User Team / User Wallet Address';
    if (_width <= 768) {
      textSize = 12.0;
      titleName = 'Wallet ID';
    }
    return IgnorePointer(
      child: ExpansionTile(
        leading: const SizedBox.shrink(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleName,
              style: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'OpenSans',
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Appreciation %',
              style: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'OpenSans',
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible: false,
              child: Container(),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        expandedAlignment: Alignment.center,
      ),
    );
  }
}
