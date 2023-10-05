part of 'sports_page_bloc.dart';

abstract class SportsPageEvent extends Equatable {
  const SportsPageEvent();

  @override
  List<Object?> get props => [];
}

class FetchLatestInfo extends SportsPageEvent {}
