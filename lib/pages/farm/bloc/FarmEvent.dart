import 'package:equatable/equatable.dart';

class FarmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnLoadFarms extends FarmEvent {
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
