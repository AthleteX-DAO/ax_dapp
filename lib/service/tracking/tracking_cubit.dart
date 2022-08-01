import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_repository/tracking_repository.dart';

class TrackingState {
  const TrackingState(
    this.loggedEvents,
  );

  final List<TrackEvent> loggedEvents;
}

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(this.trackingRepository) : super(const TrackingState([]));

  final TrackingRepository trackingRepository;

  void setup() {
    trackingRepository.loggedEventsStream.listen((loggedEvents) {
      emit(TrackingState(loggedEvents));
    });
  }
}

extension LandingPageTracking on TrackingCubit {
  void onPressedStartTrading() {
    trackingRepository.track(
      LandingPageEvent.onPressedStartTrading(),
    );
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
      TradePageUserEvent.onSwapConfirmedTransaction(
        {
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletID,
        },
      ),
    );
  }

  void onSwapApproveClick(String fromCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onApproveClick(
        {
          'from_currency': fromCurrency,
        },
      ),
    );
  }

  void onSwapConfirmClick(String toCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onConfirmClick(
        {
          'to_currency': toCurrency,
        },
      ),
    );
  }
}
