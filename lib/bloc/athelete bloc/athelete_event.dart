part of 'athelete_bloc.dart';

class AthletePageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnRefresh extends AthletePageEvent {
  final int playerId;

  OnRefresh({required this.playerId});

  @override
  List<Object?> get props => [];
}

class OnGraphRefresh extends AthletePageEvent {
  @override
  List<Object?> get props => [];
}
