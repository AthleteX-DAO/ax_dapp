import 'package:equatable/equatable.dart';

class SportsMarketsModel extends Equatable {
  const SportsMarketsModel({
    required this.name,
  });

  final String name;

  static const empty = SportsMarketsModel(name: '');

  @override
  List<Object?> get props => [name];
}
