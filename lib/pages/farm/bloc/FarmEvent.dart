import 'package:equatable/equatable.dart';

class FarmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnLoadFarms extends FarmEvent {
  @override
  List<Object?> get props => [];
}

class OnLoadStakedFarms extends FarmEvent {
  @override
  List<Object?> get props => [];
}

class OnSearchFarms extends FarmEvent {
  final String searchedName;

  OnSearchFarms({
    required this.searchedName,
  });

  @override
  List<Object?> get props => [searchedName];
}

class OnChangeFarmTab extends FarmEvent {
  final bool isAllFarms;

  OnChangeFarmTab({
    required this.isAllFarms,
  });

  @override
  List<Object?> get props => [isAllFarms];
}
