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
  void onPressedStartTrading(
      String publicAddress,
      ) {
    trackingRepository.track(LandingPageEvent.onPressedStartTrading({
      'public_address': publicAddress,
    }),);
  }
}

extension ConnectWalletTracking on TrackingCubit {
  void onPressedConnectWallet(
      String publicAddress,
      ) {
    trackingRepository.track(ScoutPageTrackingEvent.onPressedConnectWallet(
      {
        'public_address': publicAddress,
      }
    ),);
  }
}

extension ScoutPageTracking on TrackingCubit {
  /// Get athlete view information for analytics
  void trackAthleteView(
      String athleteName,
      ){
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteMint(
        {
          'athlete_name': athleteName,
        },
      ),
    );

  }
}

extension AthleteBuyTracking on TrackingCubit {
  /// Get athlete info when buy approve button clicked for analytics
  void trackAthleteBuyApproveButtonClicked(
      String aptName,
      ){
    trackingRepository.track(
        AthletePageTrackingEvent.onPressedAthleteBuy(
            {'athlete_name': aptName,},
        ),
    );
  }

/// Get athlete info when buy confirm button clicked for analytics
  void trackAthleteBuyConfirmButtonClicked(
      int id,
      ){
    trackingRepository.track(
        AthletePageTrackingEvent.onPressedConfirmBuy(
          {
            'athlete_id': id,
          },
        ),
    );

  }

/// Get athlete info when buy success for analytics
  void trackAthleteBuySuccess(
      String buyPosition,
      double unit,
      String currencySpent,
      String currency,
      double totalFee,
      String sport,
      String walletId,
      ){

    trackingRepository.track(
        AthletePageTrackingEvent.onAthleteBuySuccess(
          {
            'athlete_buy_position': buyPosition,
            'apt_unit': unit,
            'currency_spent': currencySpent,
            'currency': currency,
            'total_fee': totalFee,
            'sport': sport,
            'wallet_id': walletId
          }
        ),
    );

  }
}

extension AthleteSellTracking on TrackingCubit {
  /// Get athlete info when sell button clicked for analytics
  void trackAthleteSellApproveButtonClicked(
      String athleteName,
      ){
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteSell(
        {
          'athlete_name': athleteName,
        },
      ),
    );

  }

  /// Get athlete info when sell confirm button clicked for analytics
  void trackAthleteSellConfirmButtonClicked(
      int id,
      ){
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmSell(
        {
          'athlete_id': id,
        },
      ),
    );
  }

  /// Get athlete info when sell successful for analytics
  void trackAthleteSellSuccess(
      String sellPosition,
      double unit,
      String currencySpent,
      String currency,
      double totalFee,
      String sport,
      String walletId,
      ){

    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteSellSuccess(
          {
            'athlete_sell_position': sellPosition,
            'apt_unit': unit,
            'currency_spent': currencySpent,
            'currency': currency,
            'total_fee': totalFee,
            'sport': sport,
            'wallet_id': walletId
          }
      ),
    );

  }
}

extension AthleteMintTracking on TrackingCubit{
  /// Get athlete info when mint button clicked for analytics
  void trackAthleteMintApproveButtonClicked(
      String aptName,
      ){
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteMint(
        {
          'apt_name': aptName,
        },
      ),
    );

  }

  /// Get athlete info when mint confirmed button clicked for analytics
  void trackAthleteMintConfirmButtonClicked(
      String sport,
      ){
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmMint(
        {
          'sport': sport,
        },
      ),
    );
  }

  /// Get athlete info when mint successful for analytics
  void trackAthleteMintSuccess(
      String inputApt,
      String valueInAx,
      String walletId,
      ){

    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteMintSuccess(
          {
            'input_apt': inputApt,
            'value_in_ax': valueInAx,
            'wallet_id': walletId
          }
      ),
    );

  }
}

extension AthleteRedeemTracking on TrackingCubit{
  /// Get athlete info when redeem successful for analytics
  void trackAthleteRedeemSuccess(
      String name,
      String sport,
      String inputLongApt,
      String inputShortApt,
      String valueInAx,
      String walletId,
      ){

    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteRedeemSuccess(
          {
            'name': name,
            'sport': sport,
            'input_long_apt': inputLongApt,
            'input_short_apt': inputShortApt,
            'value_in_ax': valueInAx,
            'wallet_id': walletId
          }
      ),
    );
  }
}
