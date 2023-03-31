part of 'league_draft_bloc.dart';

class LeagueDraftState extends Equatable {
  const LeagueDraftState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  @override
  List<Object> get props => [];
}
