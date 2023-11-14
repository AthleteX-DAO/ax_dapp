import 'package:flutter/material.dart';
import 'package:league_repository/league_repository.dart';

class EntryFee extends StatelessWidget {
  const EntryFee({
    super.key,
    required double width,
    required this.axIconWidth,
    required this.axIconHeight,
    required this.league,
    required this.textSize,
  }) : _width = width;

  final double _width;
  final double axIconWidth;
  final double axIconHeight;
  final League league;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
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
            ),
          ],
        ),
      ),
    );
  }
}
