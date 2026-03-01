part of 'hero_carousel_bloc.dart';

enum HeroCarouselStatus { initial, loading, loaded, error }

class HeroCarouselState extends Equatable {
  const HeroCarouselState({
    this.status = HeroCarouselStatus.initial,
    this.topMarkets = const [],
    this.errorMessage = '',
  });

  final HeroCarouselStatus status;
  final List<PredictionModel> topMarkets;
  final String errorMessage;

  HeroCarouselState copyWith({
    HeroCarouselStatus? status,
    List<PredictionModel>? topMarkets,
    String? errorMessage,
  }) {
    return HeroCarouselState(
      status: status ?? this.status,
      topMarkets: topMarkets ?? this.topMarkets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, topMarkets, errorMessage];
}
