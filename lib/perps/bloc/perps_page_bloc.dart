import 'dart:async';
import 'package:ax_dapp/perps/models/perps_order_model.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============ EVENTS ============

abstract class PerpsPageEvent extends Equatable {
  const PerpsPageEvent();

  @override
  List<Object> get props => [];
}

class PerpsPageInitialize extends PerpsPageEvent {
  const PerpsPageInitialize();
}

class PerpsPageRefresh extends PerpsPageEvent {
  const PerpsPageRefresh();
}

class OrdersRequested extends PerpsPageEvent {
  final int offset;
  final int limit;

  const OrdersRequested({this.offset = 0, this.limit = 25});

  @override
  List<Object> get props => [offset, limit];
}

class OrdersPaginated extends PerpsPageEvent {
  final int page;

  const OrdersPaginated(this.page);

  @override
  List<Object> get props => [page];
}

class TradeHistoryRequested extends PerpsPageEvent {
  final int offset;
  final int limit;

  const TradeHistoryRequested({this.offset = 0, this.limit = 25});

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
  final BtcPerpsData btcPerpsData;
  final List<PerpsOrderModel> openOrders;
  final List<PerpsOrderModel> orderHistory;
  final List<PerpsOrderModel> tradeHistory;
  final int currentPage;
  final bool hasMoreOrders;

  const PerpsPageLoaded({
    required this.btcPerpsData,
    this.openOrders = const [],
    this.orderHistory = const [],
    this.tradeHistory = const [],
    this.currentPage = 0,
    this.hasMoreOrders = false,
  });

  PerpsPageLoaded copyWith({
    BtcPerpsData? btcPerpsData,
    List<PerpsOrderModel>? openOrders,
    List<PerpsOrderModel>? orderHistory,
    List<PerpsOrderModel>? tradeHistory,
    int? currentPage,
    bool? hasMoreOrders,
  }) {
    return PerpsPageLoaded(
      btcPerpsData: btcPerpsData ?? this.btcPerpsData,
      openOrders: openOrders ?? this.openOrders,
      orderHistory: orderHistory ?? this.orderHistory,
      tradeHistory: tradeHistory ?? this.tradeHistory,
      currentPage: currentPage ?? this.currentPage,
      hasMoreOrders: hasMoreOrders ?? this.hasMoreOrders,
    );
  }

  @override
  List<Object?> get props => [
        btcPerpsData,
        openOrders,
        orderHistory,
        tradeHistory,
        currentPage,
        hasMoreOrders,
      ];
}

class PerpsPageError extends PerpsPageState {
  final String message;

  const PerpsPageError({required this.message});

  @override
  List<Object> get props => [message];
}

// ============ BLOC ============

class PerpsPageBloc extends Bloc<PerpsPageEvent, PerpsPageState> {
  final PerpsRepository perpsRepository;

  StreamSubscription<void>? _priceSubscription;
  Timer? _metricsTimer;

  static const int _pageSize = 25; // Pagination size

  PerpsPageBloc({required this.perpsRepository})
      : super(const PerpsPageInitial()) {
    on<PerpsPageInitialize>((event, emit) async {
      await _initialize(emit);
    });

    on<PerpsPageRefresh>((event, emit) async {
      await _loadBtcPerpsData(emit);
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

  Future<void> _initialize(Emitter<PerpsPageState> emit) async {
    try {
      emit(const PerpsPageLoading());

      // Load initial BTC data
      await _loadBtcPerpsData(emit);

      // Start polling for real-time price and metrics
      _startPricePolling();
      _startMetricsPolling();
    } catch (e) {
      emit(PerpsPageError(message: 'Failed to initialize: $e'));
    }
  }

  Future<void> _loadBtcPerpsData(Emitter<PerpsPageState> emit) async {
    try {
      final btcData = await perpsRepository.getBtcPerpsData();

      if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState.copyWith(btcPerpsData: btcData));
      } else {
        emit(PerpsPageLoaded(btcPerpsData: btcData));
      }
    } catch (e) {
      if (state is PerpsPageLoaded) {
        // Keep existing state if we have it
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState);
      } else {
        emit(PerpsPageError(message: 'Failed to load BTC Perps data: $e'));
      }
    }
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
              ))
          .toList();

      final currentPage = offset ~/ limit;
      final hasMore = orders.length >= limit;

      if (currentState != null) {
        emit(currentState.copyWith(
          openOrders: orderModels,
          currentPage: currentPage,
          hasMoreOrders: hasMore,
        ));
      } else if (state is PerpsPageLoaded) {
        final loadedState = state as PerpsPageLoaded;
        emit(loadedState.copyWith(
          openOrders: orderModels,
          currentPage: currentPage,
          hasMoreOrders: hasMore,
        ));
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
              ))
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

  void _startPricePolling() {
    // Real-time price updates every 1-2 seconds
    _priceSubscription?.cancel();
    _priceSubscription = Stream.periodic(
      const Duration(seconds: 2),
      (_) {},
    ).listen((_) {
      if (!isClosed) {
        add(const PerpsPageRefresh());
      }
    });
  }

  void _startMetricsPolling() {
    // Poll market metrics (skew, open interest, funding) every 5-10 seconds
    _metricsTimer?.cancel();
    _metricsTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (!isClosed) {
          add(const PerpsPageRefresh());
        }
      },
    );
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    _metricsTimer?.cancel();
    return super.close();
  }
}
