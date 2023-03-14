part of 'league_draft_bloc.dart';

abstract class LeagueDraftState extends Equatable {
  const LeagueDraftState();
  
  @override
  List<Object> get props => [];
}

class LeagueDraftInitial extends LeagueDraftState {}
