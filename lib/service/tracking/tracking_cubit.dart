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

extension AthleteBuyTracking on TrackingCubit {
  void onPressedAthleteBuy() {
    trackingRepository.track(AthletePageTrackingEvent.onPressedAthleteBuy());
  }
}

extension AthleteSellTracking on TrackingCubit {
  void onPressedAthleteSell() {
    trackingRepository.track(AthletePageTrackingEvent.onPressedAthleteSell());
  }
}

extension AthleteMintPairTracking on TrackingCubit {
  void onPressedAthleteMintPair() {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteMintPair(),
    );
  }
}

extension AthleteRedeemPairTracking on TrackingCubit {
  void onPressedAthleteRedeemPair() {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteRedeemPair(),
    );
  }
}
