part of 'farm_bloc.dart';

class FarmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends FarmEvent {}

class OnLoadFarms extends FarmEvent {}

class OnLoadStakedFarms extends FarmEvent {}

class OnSearchFarms extends FarmEvent {
  OnSearchFarms({
    required this.searchedName,
  });

  final String searchedName;

  @override
  List<Object?> get props => [searchedName];
}

class OnChangeFarmTab extends FarmEvent {
  OnChangeFarmTab({
    required this.isAllFarms,
  });

  final bool isAllFarms;

  @override
  List<Object?> get props => [isAllFarms];
}
