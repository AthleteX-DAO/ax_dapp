import 'package:equatable/equatable.dart';

class BookPriceModel extends Equatable {
  const BookPriceModel({
    required double startPrice,
    required double endPrice,
  }) : percentage =
            startPrice > 0 ? (endPrice - startPrice) * 100 / startPrice : 0.0;

  final double percentage;

  @override
  List<Object?> get props => [percentage];
}
