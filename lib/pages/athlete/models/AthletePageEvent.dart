import 'package:equatable/equatable.dart';

class AthletePageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnPageRefresh extends AthletePageEvent {
  final int playerId;

  OnPageRefresh({required this.playerId});

  @override
  List<Object?> get props => [];
}

class OnGraphRefresh extends AthletePageEvent {
  @override
  List<Object?> get props => [];
}
