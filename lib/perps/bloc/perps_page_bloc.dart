import 'dart:async';

import 'package:ax_dapp/perps/models/perps_order_model.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============ EVENTS ============

abstract class PerpsPageEvent extends Equatable {
  const PerpsPageEvent();

  @override
  List<Object> get props => [];
}

class PerpsPageInitialize extends PerpsPageEvent {
  const PerpsPageInitialize({this.symbol = 'ETH'});
  final String symbol;

  @override
  List<Object> get props => [symbol];
}

class PerpsPageRefresh extends PerpsPageEvent {
  const PerpsPageRefresh();
}

/// Fired when user selects a different market from the dropdown.
class MarketChanged extends PerpsPageEvent {
  const MarketChanged(this.symbol);
  final String symbol;

  @override
  List<Object> get props => [symbol];
}

class OrdersRequested extends PerpsPageEvent {

  const OrdersRequested({this.offset = 0, this.limit = 25});
  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}

class OrdersPaginated extends PerpsPageEvent {

  const OrdersPaginated(this.page);
  final int page;

  @override
  List<Object> get props => [page];
}

class TradeHistoryRequested extends PerpsPageEvent {

  const TradeHistoryRequested({this.offset = 0, this.limit = 25});
  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];
}

// ============ STATES ============

abstract class PerpsPageState extends Equatable {
  const PerpsPageState();

  @override
  List<Object?> get props => [];
}

class PerpsPageInitial extends PerpsPageState {
  const PerpsPageInitial();
}

class PerpsPageLoading extends PerpsPageState {
  const PerpsPageLoading();
}

class PerpsPageLoaded extends PerpsPageState {

  const PerpsPageLoaded({
    required this.marketData,
    this.symbol = 'ETH',
    this.openOrders = const [],
    this.orderHistory = const [],
    this.tradeHistory = const [],
    this.currentPage = 0,
    this.hasMoreOrders = false,
  });
  final PerpsMarketData marketData;
  final String symbol;
  final List<PerpsOrderModel> openOrders;
  final List<PerpsOrderModel> orderHistory;
  final List<PerpsOrderModel> tradeHistory;
  final int currentPage;
  final bool hasMoreOrders;

  /// Alias for backwards compat in UI code.
  PerpsMarketData get btcPerpsData => marketData;

  PerpsPageLoaded copyWith({
    PerpsMarketData? marketData,
    String? symbol,
    List<PerpsOrderModel>? openOrders,
    List<PerpsOrderModel>? orderHistory,
    List<PerpsOrderModel>? tradeHistory,
    int? currentPage,
    bool? hasMoreOrders,
  }) {
    return PerpsPageLoaded(
      marketData: marketData ?? this.marketData,
      symbol: symbol ?? this.symbol,
      openOrders: openOrders ?? this.openOrders,
      orderHistory: orderHistory ?? this.orderHistory,
      tradeHistory: tradeHistory ?? this.tradeHistory,
      currentPage: currentPage ?? this.currentPage,
      hasMoreOrders: hasMoreOrders ?? this.hasMoreOrders,
    );
  }

  @override
  List<Object?> get props => [
        marketData,
        symbol,
        openOrders,
        orderHistory,
        tradeHistory,
        currentPage,
        hasMoreOrders,
      ];
}

class PerpsPageError extends PerpsPageState {

  const PerpsPageError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

// ============ BLOC ============

class PerpsPageBloc extends Bloc<PerpsPageEvent, PerpsPageState> {

  PerpsPageBloc({required this.perpsRepository})
      : super(const PerpsPageInitial()) {
    on<PerpsPageInitialize>((event, emit) async {
      _currentSymbol = event.symbol;
      await _initialize(emit);
    });

    on<PerpsPageRefresh>((event, emit) async {
      await _loadMarketData(emit);
    });

    on<MarketChanged>((event, emit) async {
      _currentSymbol = event.symbol;
      // Cancel existing polling & restart for new market
      _cancelPolling();
      emit(const PerpsPageLoading());
      await _loadMarketData(emit);
      _startPolling();
    });

    on<OrdersRequested>((event, emit) async {
      await _loadOrders(event.offset, event.limit, emit);
    });

    on<OrdersPaginated>((event, emit) async {
      if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        final offset = event.page * _pageSize;
        await _loadOrders(offset, _pageSize, emit, currentState: loadedState);
      }
    });

    on<TradeHistoryRequested>((event, emit) async {
      await _loadTradeHistory(event.offset, event.limit, emit);
    });
  }
  final PerpsRepository perpsRepository;

  String _currentSymbol = 'ETH';
  Timer? _pollTimer;

  static const int _pageSize = 25;
  static const Duration _pollInterval = Duration(seconds: 10);

  Future<void> _initialize(Emitter<PerpsPageState> emit) async {
    try {
      emit(const PerpsPageLoading());
      await _loadMarketData(emit);
      _startPolling();
    } catch (e) {
      emit(PerpsPageError(message: 'Failed to initialize: $e'));
    }
  }

  Future<void> _loadMarketData(Emitter<PerpsPageState> emit) async {
    try {
      final data = await perpsRepository.getMarketData(_currentSymbol);

      if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState.copyWith(marketData: data, symbol: _currentSymbol));
      } else {
        emit(PerpsPageLoaded(marketData: data, symbol: _currentSymbol));
      }
    } catch (e) {
      if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState);
      } else {
        emit(PerpsPageError(message: 'Failed to load $_currentSymbol data: $e'));
      }
    }
  }

  void _startPolling() {
    _cancelPolling();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!isClosed) {
        add(const PerpsPageRefresh());
      }
    });
  }

  void _cancelPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _loadOrders(
    int offset,
    int limit,
    Emitter<PerpsPageState> emit, {
    PerpsPageLoaded? currentState,
  }) async {
    try {
      final orders = await perpsRepository.getOpenOrders(
        offset: offset,
        limit: limit,
      );

      // Convert maps to PerpsOrderModel
      final orderModels = orders
          .map((o) => PerpsOrderModel(
                orderId: (o['orderId'] as String?) ?? '',
                symbol: (o['symbol'] as String?) ?? 'BTC',
                side: (o['side'] as String?) ?? 'LONG',
                size: (o['size'] as num?)?.toDouble() ?? 0.0,
                price: (o['price'] as num?)?.toDouble() ?? 0.0,
                timestamp: DateTime.tryParse((o['timestamp'] as String?) ?? '') ??
                    DateTime.now(),
                status: (o['status'] as String?) ?? 'PENDING',
                txHash: (o['txHash'] as String?) ?? '',
              ),)
          .toList();

      final currentPage = offset ~/ limit;
      final hasMore = orders.length >= limit;

      if (currentState != null) {
        emit(currentState.copyWith(
          openOrders: orderModels,
          currentPage: currentPage,
          hasMoreOrders: hasMore,
        ),);
      } else if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState.copyWith(
          openOrders: orderModels,
          currentPage: currentPage,
          hasMoreOrders: hasMore,
        ),);
      }
    } catch (e) {
      if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState);
      } else {
        emit(PerpsPageError(message: 'Failed to load orders: $e'));
      }
    }
  }

  Future<void> _loadTradeHistory(
    int offset,
    int limit,
    Emitter<PerpsPageState> emit,
  ) async {
    try {
      final trades = await perpsRepository.getTradeHistory(
        offset: offset,
        limit: limit,
      );

      // Convert maps to PerpsOrderModel
      final tradeModels = trades
          .map((t) => PerpsOrderModel(
                orderId: (t['orderId'] as String?) ?? '',
                symbol: (t['symbol'] as String?) ?? 'BTC',
                side: (t['side'] as String?) ?? 'LONG',
                size: (t['size'] as num?)?.toDouble() ?? 0.0,
                price: (t['price'] as num?)?.toDouble() ?? 0.0,
                timestamp: DateTime.tryParse((t['timestamp'] as String?) ?? '') ??
                    DateTime.now(),
                status: (t['status'] as String?) ?? 'FILLED',
                txHash: (t['txHash'] as String?) ?? '',
              ),)
          .toList();

      if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState.copyWith(tradeHistory: tradeModels));
      }
    } catch (e) {
      print('Error loading trade history: $e');
      // Fail silently to not break the UI
    }
  }

  @override
  Future<void> close() {
    _cancelPolling();
    return super.close();
  }
}
