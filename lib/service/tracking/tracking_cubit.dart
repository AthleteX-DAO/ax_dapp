import 'package:ax_dapp/service/controller/token.dart';
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
    Token fromCurrency,
    Token toCurrency,
    double fromInput,
    double toInput,
    double totalFee,
    String walletID,
  ) {
    trackingRepository.track(TradePageUserEvent.onSwapConfirmedTransaction());
  }
}
