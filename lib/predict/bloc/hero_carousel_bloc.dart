import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/usecases/get_top_prediction_markets_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'hero_carousel_event.dart';
part 'hero_carousel_state.dart';

/// BLoC for managing top prediction markets carousel
class HeroCarouselBloc extends Bloc<HeroCarouselEvent, HeroCarouselState> {
  HeroCarouselBloc({
    required GetTopPredictionMarketsUseCase getTopPredictionMarketsUseCase,
  })  : _getTopPredictionMarketsUseCase = getTopPredictionMarketsUseCase,
        super(const HeroCarouselState()) {
    on<HeroCarouselLoadRequested>(_onLoadRequested);
  }

  final GetTopPredictionMarketsUseCase _getTopPredictionMarketsUseCase;

  Future<void> _onLoadRequested(
    HeroCarouselLoadRequested event,
    Emitter<HeroCarouselState> emit,
  ) async {
    emit(state.copyWith(status: HeroCarouselStatus.loading));
    try {
      final topMarkets =
          await _getTopPredictionMarketsUseCase(limit: event.limit);
      emit(state.copyWith(
        status: HeroCarouselStatus.loaded,
        topMarkets: topMarkets,
      ));
    } catch (e) {
      debugPrint('HeroCarouselBloc error: $e');
      emit(state.copyWith(
        status: HeroCarouselStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
