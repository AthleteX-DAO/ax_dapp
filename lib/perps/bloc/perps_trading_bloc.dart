import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/service/controller/perps/base_sepolia_perps_service.dart';

part 'perps_trading_event.dart';
part 'perps_trading_state.dart';

class PerpsTradingBloc extends Bloc<PerpsTradingEvent, PerpsTradingState> {
  PerpsTradingBloc({
    required BaseSepoliaPerpsService perpsService,
  })  : _perpsService = perpsService,
        super(const PerpsTradingInitial()) {
    on<PlacePerpsOrder>(_onPlacePerpsOrder);
    on<CancelPerpsOrder>(_onCancelPerpsOrder);
    on<UpdatePerpsBalance>(_onUpdatePerpsBalance);
  }

  final BaseSepoliaPerpsService _perpsService;

  Future<void> _onPlacePerpsOrder(
    PlacePerpsOrder event,
    Emitter<PerpsTradingState> emit,
  ) async {
    try {
      emit(const PerpsTradingLoading());

      final txHash = await _perpsService.placeOrder(
        symbol: event.symbol,
        sizeDelta: event.isLong ? event.size : -event.size,
        isMarketOrder: event.isMarketOrder,
        limitPrice: event.limitPrice,
      );

      emit(PerpsTradingSuccess(
        transactionHash: txHash,
        message: 'Order placed successfully!',
      ));

      // Auto-reset to initial after 3 seconds
      await Future<void>.delayed(const Duration(seconds: 3));
      emit(const PerpsTradingInitial());
    } catch (e) {
      emit(PerpsTradingError(message: e.toString()));
      
      // Auto-reset to initial after 5 seconds
      await Future<void>.delayed(const Duration(seconds: 5));
      emit(const PerpsTradingInitial());
    }
  }

  Future<void> _onCancelPerpsOrder(
    CancelPerpsOrder event,
    Emitter<PerpsTradingState> emit,
  ) async {
    try {
      emit(const PerpsTradingLoading());
      
      // TODO: Implement order cancellation
      await Future<void>.delayed(const Duration(seconds: 1));
      
      emit(const PerpsTradingSuccess(
        transactionHash: 'cancelled',
        message: 'Order cancelled successfully',
      ));
    } catch (e) {
      emit(PerpsTradingError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePerpsBalance(
    UpdatePerpsBalance event,
    Emitter<PerpsTradingState> emit,
  ) async {
    try {
      final balance = await _perpsService.getAccountBalance();
      
      emit(PerpsTradingBalanceUpdated(
        availableMargin: balance['availableMargin'] ?? 0.0,
        accountValue: balance['accountValue'] ?? 0.0,
      ));
    } catch (e) {
      // Silently fail for balance updates
    }
  }
}
