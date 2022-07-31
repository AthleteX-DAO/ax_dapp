import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tracking_repository/tracking_repository.dart';
import 'package:web3dart/src/credentials/address.dart';

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

extension ConnectWalletTracking on TrackingCubit {
  void onPressedConnectWallet() {
    trackingRepository.track(ScoutPageTrackingEvent.onPressedConnectWallet());
  }
}

extension ScoutPageTracking on TrackingCubit {
  void onPressedAthleteView(
      String aptName,
      ) {
    trackingRepository.trackAthleteView(
      ScoutPageTrackingEvent.onPressedAthleteView(), aptName,);
  }
}

extension TrackAthleteBuyApproveButtonClicked on TrackingCubit {
  void onPressedAthleteBuy(
      String aptName,
  ) {
    trackingRepository.trackAthleteBuyApproveButtonClicked(
      AthletePageTrackingEvent.onPressedAthleteBuy(),
      aptName,);
  }
}

extension TrackAthleteBuyConfirmButtonClicked on TrackingCubit {
  void onPressedConfirmBuy(
      int aptId,
      ) {
    trackingRepository.trackAthleteBuyConfirmButtonClicked(
      AthletePageTrackingEvent.onPressedConfirmBuy(),
      aptId,);
  }
}

extension TrackAthleteBuySuccess on TrackingCubit {
  void onAthleteBuySuccess(
      String buyPosition,
      String unit,
      String currencySpent,
      String currency,
      double totalFee,
      String sport,
      Rx<EthereumAddress> publicAddress,) {
    trackingRepository.trackAthleteBuySuccess(
      AthletePageTrackingEvent.onAthleteBuySuccess(),
      buyPosition,
      unit,
      currencySpent,
      currency,
      totalFee,
      sport,
      publicAddress.toString(),
    );
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
