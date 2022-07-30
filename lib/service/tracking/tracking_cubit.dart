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

extension PoolPageTracking on TrackingCubit {
  void onPoolCreated(
    String currencyOne,
    String currencyTwo,
    String valueOne,
    String valueTwo,
    String lpTokens,
  ) {
    trackingRepository.trackPoolCreation(PoolPageUserEvent.onPoolCreate(),
        currencyOne, currencyTwo, valueOne, valueTwo, lpTokens,);
  }
}
