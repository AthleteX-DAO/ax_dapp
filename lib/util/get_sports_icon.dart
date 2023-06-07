import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

IconData getSportIcon(SupportedSport sport) {
  IconData sportsIcon;
  switch (sport) {
    case SupportedSport.all:
    case SupportedSport.MLB:
      sportsIcon = Icons.sports_baseball;
      break;
    case SupportedSport.NBA:
      sportsIcon = Icons.sports_basketball;
      break;
    case SupportedSport.NFL:
      sportsIcon = Icons.sports_football;
      break;
  }
  return sportsIcon;
}
