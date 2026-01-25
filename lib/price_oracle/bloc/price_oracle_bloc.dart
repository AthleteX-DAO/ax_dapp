import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ax_dapp/price_oracle/models/uniswap_price.dart';
import 'package:ax_dapp/price_oracle/repository/uniswap_v3_repository.dart';

// Events
abstract class PriceOracleEvent extends Equatable {
  const PriceOracleEvent();

  @override
  List<Object?> get props => [];
}

class FetchCurrentPrice extends PriceOracleEvent {
  const FetchCurrentPrice();
}

class FetchHistoricalPrices extends PriceOracleEvent {
  const FetchHistoricalPrices({required this.periodInHours});

  final int periodInHours;

  @override
  List<Object?> get props => [periodInHours];
}

class StartPricePolling extends PriceOracleEvent {
  const StartPricePolling({this.intervalSeconds = 30});

  final int intervalSeconds;

  @override
  List<Object?> get props => [intervalSeconds];
}

class StopPricePolling extends PriceOracleEvent {
  const StopPricePolling();
}

// States
abstract class PriceOracleState extends Equatable {
  const PriceOracleState();

  @override
  List<Object?> get props => [];
}

class PriceOracleInitial extends PriceOracleState {
  const PriceOracleInitial();
}

class PriceOracleLoading extends PriceOracleState {
  const PriceOracleLoading();
}

class PriceOracleLoaded extends PriceOracleState {
  const PriceOracleLoaded({
    required this.currentPrice,
    this.historicalPrices = const [],
  });

  final UniswapPrice currentPrice;
  final List<HistoricalPrice> historicalPrices;

  @override
  List<Object?> get props => [currentPrice, historicalPrices];
}

class PriceOracleError extends PriceOracleState {
  const PriceOracleError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// Bloc
class PriceOracleBloc extends Bloc<PriceOracleEvent, PriceOracleState> {
  PriceOracleBloc({required UniswapV3Repository repository})
      : _repository = repository,
        super(const PriceOracleInitial()) {
    on<FetchCurrentPrice>(_onFetchCurrentPrice);
    on<FetchHistoricalPrices>(_onFetchHistoricalPrices);
    on<StartPricePolling>(_onStartPricePolling);
    on<StopPricePolling>(_onStopPricePolling);
  }

  final UniswapV3Repository _repository;
  Timer? _pollingTimer;

  Future<void> _onFetchCurrentPrice(
    FetchCurrentPrice event,
    Emitter<PriceOracleState> emit,
  ) async {
    try {
      emit(const PriceOracleLoading());

      // Fetch current price from AX/USDC pool
      final price = await _repository.getAxUsdPrice();

      emit(PriceOracleLoaded(currentPrice: price));
    } catch (e) {
      emit(PriceOracleError(message: e.toString()));
    }
  }

  Future<void> _onFetchHistoricalPrices(
    FetchHistoricalPrices event,
    Emitter<PriceOracleState> emit,
  ) async {
    try {
      // Get pool address first
      final poolAddress = ''; // TODO: Get this from repository

      final historicalPrices = await _repository.getHistoricalPrices(
        poolAddress: poolAddress,
        periodInHours: event.periodInHours,
      );

      if (state is PriceOracleLoaded) {
        final currentState = state as PriceOracleLoaded;
        emit(
          PriceOracleLoaded(
            currentPrice: currentState.currentPrice,
            historicalPrices: historicalPrices,
          ),
        );
      } else {
        // Fetch current price if not already loaded
        final currentPrice = await _repository.getAxUsdPrice();
        emit(
          PriceOracleLoaded(
            currentPrice: currentPrice,
            historicalPrices: historicalPrices,
          ),
        );
      }
    } catch (e) {
      emit(PriceOracleError(message: e.toString()));
    }
  }

  Future<void> _onStartPricePolling(
    StartPricePolling event,
    Emitter<PriceOracleState> emit,
  ) async {
    // Cancel any existing timer
    _pollingTimer?.cancel();

    // Fetch initial price
    add(const FetchCurrentPrice());

    // Start polling
    _pollingTimer = Timer.periodic(
      Duration(seconds: event.intervalSeconds),
      (_) => add(const FetchCurrentPrice()),
    );
  }

  void _onStopPricePolling(
    StopPricePolling event,
    Emitter<PriceOracleState> emit,
  ) {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _repository.dispose();
    return super.close();
  }
}
