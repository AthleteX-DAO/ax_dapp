import 'package:flutter/material.dart';

class LeagueHeaderTitle extends StatelessWidget {
  const LeagueHeaderTitle({
    super.key,
    required this.textSize,
    required this.showDateRange,
    required this.showToolTipHeader,
  });

  final double textSize;
  final bool showDateRange;
  final bool showToolTipHeader;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: OutlinedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (_) => BorderSide.none,
          ),
          mouseCursor: MaterialStateProperty.resolveWith<MouseCursor>(
            (_) => MouseCursor.defer,
          ),
        ),
        onPressed: () => {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: SizedBox(
                width: _width * 0.2,
                child: Text(
                  'League Name',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (showDateRange)
              FittedBox(
                child: SizedBox(
                  width: _width * 0.2,
                  child: Text(
                    'Start/End Date',
                    style: TextStyle(
                      color: Colors.grey[400],
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
                child: Text(
                  'Entry Fee',
                  style: TextStyle(
                    color: Colors.grey[400],
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
                child: Text(
                  'Prize Pool',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (showToolTipHeader)
              FittedBox(
                child: Text(
                  'Info',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
