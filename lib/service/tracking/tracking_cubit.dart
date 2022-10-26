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
      LandingPageEvent.onPressedStartTrading({}),
    );
  }
}

extension ConnectWalletSuccessfulTracking on TrackingCubit {
  void onConnectWalletSuccessful({
    required String publicAddress,
    required String axUnits,
  }) {
    trackingRepository.track(
      ScoutPageTrackingEvent.onConnectWalletSuccessful({
        'public_address': publicAddress,
        'ax_units': axUnits,
      }),
    );
  }
}

extension ScoutPageTracking on TrackingCubit {
  /// Get athlete view information for analytics
  void trackAthleteView({
    required String athleteName,
    required String walletId,
  }) {
    trackingRepository.track(
      ScoutPageTrackingEvent.onPressedAthleteView(
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
          'wallet_id': walletId
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
          'wallet_id': walletId
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
        'wallet_id': walletId
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
          'wallet_id': walletId
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
          'wallet_id': walletId
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
        'wallet_id': walletId
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteMint(
        {
          'apt_pair_name': aptName,
          'sport': sport,
          'input_apt': inputApt,
          'value_in_ax': valueInAx,
          'wallet_id': walletId
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmMint(
        {
          'apt_pair_name': aptName,
          'sport': sport,
          'input_apt': inputApt,
          'value_in_ax': valueInAx,
          'wallet_id': walletId
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteMintSuccess({
        'apt_pair_name': aptName,
        'sport': sport,
        'input_apt': inputApt,
        'value_in_ax': valueInAx,
        'wallet_id': walletId
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onAthleteRedeemSuccess({
        'apt_pair_name': name,
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
  void onPoolCreated({
    required String currencyOne,
    required String currencyTwo,
    required String valueOne,
    required String valueTwo,
    required String lpTokens,
    required String shareOfPool,
    required String lpTokenName,
    required String walletId,
  }) {
    trackingRepository.track(
      PoolPageUserEvent.onPoolCreate(
        {
          'currency_1': currencyOne,
          'currency_2': currencyTwo,
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

  void onPoolApproveClick({
    required String currencyOne,
    required String currencyTwo,
    required String valueOne,
    required String valueTwo,
    required String lpTokens,
    required String shareOfPool,
    required String lpTokenName,
    required String walletId,
  }) {
    trackingRepository.track(
      PoolPageUserEvent.onApprovePoolClick(
        {
          'currency_1': currencyOne,
          'currency_2': currencyTwo,
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

  void onPoolConfirmClick({
    required String currencyOne,
    required String currencyTwo,
    required String valueOne,
    required String valueTwo,
    required String lpTokens,
    required String shareOfPool,
    required String lpTokenName,
    required String walletId,
  }) {
    trackingRepository.track(
      PoolPageUserEvent.onConfirmPoolClick(
        {
          'currency_1': currencyOne,
          'currency_2': currencyTwo,
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

  void onPoolRemoval({
    required String currencyOne,
    required String currencyTwo,
    required double valueOne,
    required double valueTwo,
    required String lpTokens,
    required String shareOfPool,
    required double percentRemoval,
    required String walletId,
    required String lpTokenName,
  }) {
    trackingRepository.track(
      PoolPageUserEvent.onPoolRemove(
        {
          'currency_1': currencyOne,
          'currency_2': currencyTwo,
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'percent_removal': percentRemoval,
          'wallet_id': walletId,
          'lp_token_name': lpTokenName,
        },
      ),
    );
  }

  void onPoolRemovalApproveClick({
    required String currencyOne,
    required String currencyTwo,
    required double valueOne,
    required double valueTwo,
    required String lpTokens,
    required String shareOfPool,
    required double percentRemoval,
    required String walletId,
    required String lpTokenName,
  }) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveApproveClick(
        {
          'currency_1': currencyOne,
          'currency_2': currencyTwo,
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'percent_removal': percentRemoval,
          'wallet_id': walletId,
          'lp_token_name': lpTokenName,
        },
      ),
    );
  }

  void onPoolRemovalConfirmClick({
    required String currencyOne,
    required String currencyTwo,
    required double valueOne,
    required double valueTwo,
    required String lpTokens,
    required String shareOfPool,
    required double percentRemoval,
    required String walletId,
    required String lpTokenName,
  }) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveConfirmClick(
        {
          'currency_1': currencyOne,
          'currency_2': currencyTwo,
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'percent_removal': percentRemoval,
          'wallet_id': walletId,
          'lp_token_name': lpTokenName,
        },
      ),
    );
  }
}

extension TradePageTracking on TrackingCubit {
  void onSwapConfirmedTransaction({
    required String fromCurrency,
    required String toCurrency,
    required String fromUnits,
    required String toUnits,
    required String totalFee,
    required String walletId,
  }) {
    trackingRepository.track(
      TradePageUserEvent.onSwapConfirmedTransaction(
        {
          'from_currency': fromCurrency,
          'to_currency': toCurrency,
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletId,
        },
      ),
    );
  }

  void onSwapApproveClick({
    required String fromCurrency,
    required String toCurrency,
    required String fromUnits,
    required String toUnits,
    required String totalFee,
    required String walletId,
  }) {
    trackingRepository.track(
      TradePageUserEvent.onApproveClick(
        {
          'from_currency': fromCurrency,
          'to_currency': toCurrency,
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletId,
        },
      ),
    );
  }

  void onSwapConfirmClick({
    required String fromCurrency,
    required String toCurrency,
    required String fromUnits,
    required String toUnits,
    required String totalFee,
    required String walletId,
  }) {
    trackingRepository.track(
      TradePageUserEvent.onConfirmClick(
        {
          'from_currency': fromCurrency,
          'to_currency': toCurrency,
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletId,
        },
      ),
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
