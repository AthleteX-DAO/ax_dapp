import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_repository/tracking_repository.dart';

class _TrackingState {
  const _TrackingState();
}

class TrackingCubit extends Cubit<_TrackingState> {
  TrackingCubit(this.trackingRepository) : super(const _TrackingState());

  final TrackingRepository trackingRepository;
}

extension LandingPageTracking on TrackingCubit {
  void onPressedStartTrading() {
    trackingRepository.track(LandingPageEvent.onPressedStartTrading());
  }
}

extension TradePageTracking on TrackingCubit {
  void onSwapConfirmedTransaction(
    String fromUnits,
    String toUnits,
    String totalFee,
    String walletID,
  ) {
    trackingRepository.track(
      TradePageUserEvent.onSwapConfirmedTransaction()
        ..params = {
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletID,
        },
    );
  }

  void onSwapApproveClick(String fromCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onApproveClick()
        ..params = {'from_currency': fromCurrency},
    );
  }

  void onSwapConfirmClick(String toCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onConfirmClick()..params = {'to_currency': toCurrency},
    );
  }
}
