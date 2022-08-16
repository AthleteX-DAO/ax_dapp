class BookPriceModel {
  BookPriceModel({
    required double startPrice,
    required double endPrice,
  }) : percentage =
            startPrice > 0 ? (endPrice - startPrice) * 100 / startPrice : 0.0;
  final double percentage;
}
