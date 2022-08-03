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
    trackingRepository.track(
      LandingPageEvent.onPressedStartTrading({}),
    );
  }
}

extension ConnectWalletTracking on TrackingCubit {
  void onPressedConnectWallet(
    String publicAddress,
  ) {
    trackingRepository.track(
      ScoutPageTrackingEvent.onPressedConnectWallet({
        'public_address': publicAddress,
      }),
    );
  }
}

extension ScoutPageTracking on TrackingCubit {
  /// Get athlete view information for analytics
  void trackAthleteView(
    String athleteName,
  ) {
    trackingRepository.track(
      ScoutPageTrackingEvent.onPressedAthleteView(
        {'apt_player_name': athleteName},
      ),
    );
  }
}

extension AthletePageTracking on TrackingCubit {
  void trackAddToWallet(
    String athleteName,
    String walletId,
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAddToWallet({
        'apt_player_name': athleteName,
        'wallet_id': walletId,
      }),
    );
  }
}

extension AthleteBuyTracking on TrackingCubit {
  /// Get athlete info when buy approve button clicked for analytics
  void trackAthleteBuyApproveButtonClicked(
    String aptName,
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteBuy(
        {
          'apt_name': aptName,
        },
      ),
    );
  }

  /// Get athlete info when buy confirm button clicked for analytics
  void trackAthleteBuyConfirmButtonClicked(
    int id,
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmBuy(
        {
          'apt_id': id,
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
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteBuySuccess({
        'long_short': buyPosition,
        'apt_units': unit,
        'currency_spent': currencySpent,
        'currency': currency,
        'total_fee': totalFee,
        'sport': sport,
        'wallet_id': walletId
      }),
    );
  }
}

extension AthleteSellTracking on TrackingCubit {
  /// Get athlete info when sell button clicked for analytics
  void trackAthleteSellApproveButtonClicked(
    String athleteName,
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteSell(
        {
          'apt_name': athleteName,
        },
      ),
    );
  }

  /// Get athlete info when sell confirm button clicked for analytics
  void trackAthleteSellConfirmButtonClicked(
    int id,
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmSell(
        {
          'apt_id': id,
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
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteSellSuccess({
        'long_short': sellPosition,
        'apt_units': unit,
        'currency_spent': currencySpent,
        'currency': currency,
        'total_fee': totalFee,
        'sport': sport,
        'wallet_id': walletId
      }),
    );
  }
}

extension AthleteMintTracking on TrackingCubit {
  /// Get athlete info when mint button clicked for analytics
  void trackAthleteMintApproveButtonClicked(
    String aptName,
  ) {
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
  ) {
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
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteMintSuccess({
        'input_apt': inputApt,
        'value_in_ax': valueInAx,
        'wallet_id': walletId
      }),
    );
  }
}

extension AthleteRedeemTracking on TrackingCubit {
  /// Get athlete info when redeem successful for analytics
  void trackAthleteRedeemSuccess(
    String name,
    String sport,
    String inputLongApt,
    String inputShortApt,
    String valueInAx,
    String walletId,
  ) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteRedeemSuccess({
        'apt_name': name,
        'sport': sport,
        'input_long_apt': inputLongApt,
        'input_short_apt': inputShortApt,
        'value_in_ax': valueInAx,
        'wallet_id': walletId
      }),
    );
  }
}

extension PoolPageTracking on TrackingCubit {
  void onPoolCreated(
    String valueOne,
    String valueTwo,
    String lpTokens,
    String shareOfPool,
    String lpTokenName,
    String walletId,
  ) {
    trackingRepository.track(
      PoolPageUserEvent.onPoolCreate(
        {
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'lp_token_name': lpTokenName,
          'wallet_id': walletId,
        },
      ),
    );
  }

  void onPoolApproveClick(String currencyOne) {
    trackingRepository.track(
      PoolPageUserEvent.onApprovePoolClick(
        {
          'currency_1': currencyOne,
        },
      ),
    );
  }

  void onPoolConfirmClick(String currencyTwo) {
    trackingRepository.track(
      PoolPageUserEvent.onConfirmPoolClick(
        {
          'currency_2': currencyTwo,
        },
      ),
    );
  }

  void onPoolRemoval(
    double valueOne,
    double valueTwo,
    String lpTokens,
    String shareOfPool,
    double percentRemoval,
    String walletId,
  ) {
    trackingRepository.track(
      PoolPageUserEvent.onPoolRemove(
        {
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'percent_removal': percentRemoval,
          'wallet_id': walletId
        },
      ),
    );
  }

  void onPoolRemovalApproveClick(String currencyOne) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveApproveClick(
        {
          'currency_1': currencyOne,
        },
      ),
    );
  }

  void onPoolRemovalConfirmClick(String currencyTwo) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveConfirmClick(
        {
          'currency_2': currencyTwo,
        },
      ),
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
        {'from_currency': fromCurrency},
      ),
    );
  }

  void onSwapConfirmClick(String toCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onConfirmClick(
        {'to_currency': toCurrency},
      ),
    );
  }
}
