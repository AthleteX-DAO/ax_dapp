part of 'athlete_page_bloc.dart';

class AthletePageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnPageRefresh extends AthletePageEvent {
  OnPageRefresh({required this.playerId});

  final int playerId;
}

class OnGraphRefresh extends AthletePageEvent {}
