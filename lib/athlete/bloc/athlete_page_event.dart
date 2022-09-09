part of 'athlete_page_bloc.dart';

class AthletePageEvent extends Equatable {
  const AthletePageEvent();

  @override
  List<Object?> get props => [];
}

class WatchAptPairStarted extends AthletePageEvent {
  const WatchAptPairStarted(this.athleteId);

  final int athleteId;

  @override
  List<Object?> get props => [athleteId];
}

class AptTypeSelectionChanged extends AthletePageEvent {
  const AptTypeSelectionChanged(this.aptType);

  final AptType aptType;

  @override
  List<Object?> get props => [aptType];
}

class GetPlayerStatsRequested extends AthletePageEvent {
  const GetPlayerStatsRequested(this.playerId);

  final int playerId;

  @override
  List<Object?> get props => [playerId];
}

class OnGraphRefresh extends AthletePageEvent {}

class AddTokenToWalletRequested extends AthletePageEvent {
  const AddTokenToWalletRequested();
}
