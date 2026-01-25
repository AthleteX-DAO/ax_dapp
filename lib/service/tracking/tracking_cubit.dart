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

extension ConnectWalletSuccessfulTracking on TrackingCubit {
  void onConnectWalletSuccessful({
    required String publicAddress,
    required String axUnits,
    required String walletType,
  }) {
    trackingRepository.track(
      MarketsPageTrackingEvent.onConnectWalletSuccessful({
        'public_address': publicAddress,
        'ax_units': axUnits,
        'wallet_type': walletType,
      }),
    );
  }

  void onConnectWalletPressed({
    required String publicAddress,
    required String axUnits,
    required String walletType,
  }) {
    trackingRepository.track(
      MarketsPageTrackingEvent.onConnectWalletPressed({
        'public_address': publicAddress,
        'ax_units': axUnits,
        'wallet_type': walletType,
      }),
    );
  }
}

extension MarketsPageTracking on TrackingCubit {
  /// Get athlete view information for analytics
  void trackAthleteView({
    required String athleteName,
    required String walletId,
  }) {
    trackingRepository.track(
      MarketsPageTrackingEvent.onPressedAthleteView(
        {'apt_player_name': athleteName, 'wallet_id': walletId},
      ),
    );
  }
}

extension AthletePageTracking on TrackingCubit {
  void trackAddToWallet({
    required String athleteName,
    required String walletId,
  }) {
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
  void trackAthleteBuyApproveButtonClicked({
    required String aptName,
    required int id,
    required String buyPosition,
    required double unit,
    required String currencySpent,
    required String currency,
    required double totalFee,
    required String sport,
    required String walletId,
    required double valueInUSD,
    required double feeInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteBuy(
        {
          'apt_name': aptName,
          'apt_id': id,
          'long_short': buyPosition,
          'apt_units': unit,
          'currency_spent': currencySpent,
          'currency': currency,
          'total_fee': totalFee,
          'sport': sport,
          'wallet_id': walletId,
          'value_in_usd': valueInUSD,
          'fee_in_usd': feeInUSD,
        },
      ),
    );
  }

  /// Get athlete info when buy confirm button clicked for analytics
  void trackAthleteBuyConfirmButtonClicked({
    required String aptName,
    required int id,
    required String buyPosition,
    required double unit,
    required String currencySpent,
    required String currency,
    required double totalFee,
    required String sport,
    required String walletId,
    required double valueInUSD,
    required double feeInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmBuy(
        {
          'apt_name': aptName,
          'apt_id': id,
          'long_short': buyPosition,
          'apt_units': unit,
          'currency_spent': currencySpent,
          'currency': currency,
          'total_fee': totalFee,
          'sport': sport,
          'wallet_id': walletId,
          'value_in_usd': valueInUSD,
          'fee_in_usd': feeInUSD,
        },
      ),
    );
  }

  /// Get athlete info when buy success for analytics
  void trackAthleteBuySuccess({
    required String aptName,
    required int id,
    required String buyPosition,
    required double unit,
    required String currencySpent,
    required String currency,
    required double totalFee,
    required String sport,
    required String walletId,
    required double valueInUSD,
    required double feeInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteBuySuccess({
        'apt_name': aptName,
        'apt_id': id,
        'long_short': buyPosition,
        'apt_units': unit,
        'currency_spent': currencySpent,
        'currency': currency,
        'total_fee': totalFee,
        'sport': sport,
        'wallet_id': walletId,
        'value_in_usd': valueInUSD,
        'fee_in_usd': feeInUSD,
      }),
    );
  }
}

extension AthleteSellTracking on TrackingCubit {
  /// Get athlete info when sell button clicked for analytics
  void trackAthleteSellApproveButtonClicked({
    required String athleteName,
    required int id,
    required String sellPosition,
    required String unit,
    required double currencyReceive,
    required String currency,
    required double totalFee,
    required String sport,
    required String walletId,
    required double valueInUSD,
    required double feeInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteSell(
        {
          'apt_name': athleteName,
          'apt_id': id,
          'long_short': sellPosition,
          'apt_units': unit,
          'currency_received': currencyReceive,
          'currency': currency,
          'total_fee': totalFee,
          'sport': sport,
          'wallet_id': walletId,
          'value_in_usd': valueInUSD,
          'fee_in_usd': feeInUSD,
        },
      ),
    );
  }

  /// Get athlete info when sell confirm button clicked for analytics
  void trackAthleteSellConfirmButtonClicked({
    required String athleteName,
    required int id,
    required String sellPosition,
    required String unit,
    required double currencyReceive,
    required String currency,
    required double totalFee,
    required String sport,
    required String walletId,
    required double valueInUSD,
    required double feeInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmSell(
        {
          'apt_name': athleteName,
          'apt_id': id,
          'long_short': sellPosition,
          'apt_units': unit,
          'currency_received': currencyReceive,
          'currency': currency,
          'total_fee': totalFee,
          'sport': sport,
          'wallet_id': walletId,
          'value_in_usd': valueInUSD,
          'fee_in_usd': feeInUSD,
        },
      ),
    );
  }

  /// Get athlete info when sell successful for analytics
  void trackAthleteSellSuccess({
    required String athleteName,
    required int id,
    required String sellPosition,
    required String unit,
    required double currencyReceive,
    required String currency,
    required double totalFee,
    required String sport,
    required String walletId,
    required double valueInUSD,
    required double feeInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteSellSuccess({
        'apt_name': athleteName,
        'apt_id': id,
        'long_short': sellPosition,
        'apt_units': unit,
        'currency_received': currencyReceive,
        'currency': currency,
        'total_fee': totalFee,
        'sport': sport,
        'wallet_id': walletId,
        'value_in_usd': valueInUSD,
        'fee_in_usd': feeInUSD,
      }),
    );
  }
}

extension AthleteMintTracking on TrackingCubit {
  /// Get athlete info when mint button clicked for analytics
  void trackAthleteMintApproveButtonClicked({
    required String aptName,
    required String sport,
    required String inputApt,
    required double valueInAx,
    required String walletId,
    required double valueInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteMint(
        {
          'apt_pair_name': aptName,
          'sport': sport,
          'input_apt': inputApt,
          'value_in_ax': valueInAx,
          'wallet_id': walletId,
          'value_in_usd': valueInUSD,
        },
      ),
    );
  }

  /// Get athlete info when mint confirmed button clicked for analytics
  void trackAthleteMintConfirmButtonClicked({
    required String aptName,
    required String sport,
    required String inputApt,
    required double valueInAx,
    required String walletId,
    required double valueInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmMint(
        {
          'apt_pair_name': aptName,
          'sport': sport,
          'input_apt': inputApt,
          'value_in_ax': valueInAx,
          'wallet_id': walletId,
          'value_in_usd': valueInUSD,
        },
      ),
    );
  }

  /// Get athlete info when mint successful for analytics
  void trackAthleteMintSuccess({
    required String aptName,
    required String sport,
    required String inputApt,
    required double valueInAx,
    required String walletId,
    required double valueInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteMintSuccess({
        'apt_pair_name': aptName,
        'sport': sport,
        'input_apt': inputApt,
        'value_in_ax': valueInAx,
        'wallet_id': walletId,
        'value_in_usd': valueInUSD,
      }),
    );
  }
}

extension AthleteRedeemTracking on TrackingCubit {
  /// Get athlete info when redeem successful for analytics
  void trackAthleteRedeemSuccess({
    required String name,
    required String sport,
    required String inputLongApt,
    required String inputShortApt,
    required String valueInAx,
    required String walletId,
    required double valueInUSD,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteRedeemSuccess({
        'apt_pair_name': name,
        'sport': sport,
        'input_long_apt': inputLongApt,
        'input_short_apt': inputShortApt,
        'value_in_ax': valueInAx,
        'wallet_id': walletId,
        'value_in_usd': valueInUSD,
      }),
    );
  }
}

extension FarmPageTracking on TrackingCubit {
  void onPressedStake({
    required String tickerPair,
    required String tickerPairName,
    required String axlInput,
    required String axlBalance,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onPressedStake({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'axl_input': axlInput,
        'axl_balance': axlBalance,
        'wallet_id': walletId,
      }),
    );
  }

  void onPressedStakeConfirm({
    required String tickerPair,
    required String tickerPairName,
    required String axlInput,
    required String axlBalance,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onPressedStakeConfirm({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'axl_input': axlInput,
        'axl_balance': axlBalance,
        'wallet_id': walletId,
      }),
    );
  }

  void onStakeSuccess({
    required String tickerPair,
    required String tickerPairName,
    required String axlInput,
    required String axlBalance,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onStakeSuccess({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'axl_input': axlInput,
        'axl_balance': axlBalance,
        'wallet_id': walletId,
      }),
    );
  }

  void onPressedClaimRewards({
    required String tickerPair,
    required String tickerPairName,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onPressedClaimRewards({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'wallet_id': walletId,
      }),
    );
  }

  void onClaimRewardsSuccess({
    required String tickerPair,
    required String tickerPairName,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onClaimRewardsSuccess({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'wallet_id': walletId,
      }),
    );
  }

  void onPressedUnStake({
    required String tickerPair,
    required String tickerPairName,
    required String axlInput,
    required String axlBalance,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onPressedUnStake({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'axl_input': axlInput,
        'axl_balance': axlBalance,
        'wallet_id': walletId,
      }),
    );
  }

  void onPressedUnStakeConfirm({
    required String tickerPair,
    required String tickerPairName,
    required String axlInput,
    required String axlBalance,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onPressedUnStakeConfirm({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'axl_input': axlInput,
        'axl_balance': axlBalance,
        'wallet_id': walletId,
      }),
    );
  }

  void onUnStakeSuccess({
    required String tickerPair,
    required String tickerPairName,
    required String axlInput,
    required String axlBalance,
    required String walletId,
  }) {
    trackingRepository.track(
      FarmPageTrackingEvent.onUnStakeSuccess({
        'ticker_pair': tickerPair,
        'ticker_pair_name': tickerPairName,
        'axl_input': axlInput,
        'axl_balance': axlBalance,
        'wallet_id': walletId,
      }),
    );
  }
}

extension PromoDialogTracking on TrackingCubit {
  void onDiscordLinkClicked({
    required String walletId,
  }) {
    trackingRepository.track(
      WalletPromoTrackingEvent.onDiscordLinkClicked({
        'wallet_id': walletId,
      }),
    );
  }
}
