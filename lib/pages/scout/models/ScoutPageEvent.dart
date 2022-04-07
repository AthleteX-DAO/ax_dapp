import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:equatable/equatable.dart';

class ScoutPageEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SelectSport extends ScoutPageEvent {
  final SupportedSport selectedSport;

  SelectSport({
    required this.selectedSport,
  });

  @override
  List<Object?> get props => [selectedSport];
}

class OnPageRefresh extends ScoutPageEvent {
  @override
  List<Object?> get props => [];
}

class OnAthleteSearch extends ScoutPageEvent {
  final String searchedName;

  OnAthleteSearch({
    required this.searchedName,
  });

  @override
  List<Object?> get props => [searchedName];
}
