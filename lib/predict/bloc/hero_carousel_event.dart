part of 'hero_carousel_bloc.dart';

sealed class HeroCarouselEvent extends Equatable {
  const HeroCarouselEvent();
}

class HeroCarouselLoadRequested extends HeroCarouselEvent {
  const HeroCarouselLoadRequested({this.limit = 4});

  final int limit;

  @override
  List<Object> get props => [limit];
}
