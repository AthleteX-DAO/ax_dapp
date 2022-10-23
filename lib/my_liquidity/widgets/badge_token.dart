import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class BadgeToken extends StatelessWidget {
  const BadgeToken({
    super.key,
    required this.sport,
    required this.symbol,
  });

  final SupportedSport sport;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Badge(
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(
        sport.name.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      position: BadgePosition.topEnd(top: -14, end: -14),
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
      child: Text(
        symbol,
        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }
}
