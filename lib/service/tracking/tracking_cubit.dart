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

extension PredictionPageTracking on TrackingCubit {
  /// Tracks when a user views a specific prediction market
  void trackPredictionView({
    required String marketName,
    required String walletId,
  }) {
    trackingRepository.track(
      PredictPageTrackingEvent.onPressedPredictionView({
        'market_name': marketName,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a buy (bet) on a prediction market
  void trackPredictionBuyPressed({
    required String marketName,
    required String side,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      PredictPageTrackingEvent.onPressedPredictionBuy({
        'market_name': marketName,
        'side': side,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a prediction buy transaction succeeds on-chain
  void trackPredictionBuySuccess({
    required String marketName,
    required String side,
    required double amount,
    required double valueInUsd,
    required String walletId,
  }) {
    trackingRepository.track(
      PredictPageTrackingEvent.onPredictionBuySuccess({
        'market_name': marketName,
        'side': side,
        'amount': amount,
        'value_in_usd': valueInUsd,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a sell of their prediction position
  void trackPredictionSellPressed({
    required String marketName,
    required String side,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      PredictPageTrackingEvent.onPressedPredictionSell({
        'market_name': marketName,
        'side': side,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a prediction sell transaction succeeds on-chain
  void trackPredictionSellSuccess({
    required String marketName,
    required String side,
    required double amount,
    required double valueInUsd,
    required String walletId,
  }) {
    trackingRepository.track(
      PredictPageTrackingEvent.onPredictionSellSuccess({
        'market_name': marketName,
        'side': side,
        'amount': amount,
        'value_in_usd': valueInUsd,
        'wallet_id': walletId,
      }),
    );
  }
}

extension SpotMarketTracking on TrackingCubit {
  /// Tracks when a user views a specific spot market
  void trackSpotMarketView({
    required String marketName,
    required String walletId,
  }) {
    trackingRepository.track(
      SpotMarketsTrackingEvent.onSpotMarketView({
        'market_name': marketName,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a buy order on the spot market
  void trackSpotOrderBuyPressed({
    required String marketName,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      SpotMarketsTrackingEvent.onPressedSpotOrderBuy({
        'market_name': marketName,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a sell order on the spot market
  void trackSpotOrderSellPressed({
    required String marketName,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      SpotMarketsTrackingEvent.onPressedSpotOrderSell({
        'market_name': marketName,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a spot market order succeeds on-chain
  void trackSpotOrderSuccess({
    required String marketName,
    required String orderType,
    required double amount,
    required double valueInUsd,
    required String walletId,
  }) {
    trackingRepository.track(
      SpotMarketsTrackingEvent.onSpotOrderSuccess({
        'market_name': marketName,
        'order_type': orderType,
        'amount': amount,
        'value_in_usd': valueInUsd,
        'wallet_id': walletId,
      }),
    );
  }
}

extension AuthTracking on TrackingCubit {
  /// Tracks when a user presses the sign up button
  void trackSignUpPressed() {
    trackingRepository.track(
      AuthTrackingEvent.onSignUpPressed({
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }

  /// Tracks when a user successfully creates a new account
  void trackSignUpSuccess({
    required String walletId,
  }) {
    trackingRepository.track(
      AuthTrackingEvent.onSignUpSuccess({
        'wallet_id': walletId,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }
}

extension VaultTracking on TrackingCubit {
  /// Tracks when a user views a specific vault
  void trackVaultView({
    required String vaultName,
    required String walletId,
  }) {
    trackingRepository.track(
      VaultTrackingEvent.onVaultView({
        'vault_name': vaultName,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a deposit into a vault
  void trackVaultDepositPressed({
    required String vaultName,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      VaultTrackingEvent.onVaultDepositPressed({
        'vault_name': vaultName,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a vault deposit transaction settles on-chain
  void trackVaultDepositSuccess({
    required String vaultName,
    required double amount,
    required double valueInUsd,
    required String walletId,
  }) {
    trackingRepository.track(
      VaultTrackingEvent.onVaultDepositSuccess({
        'vault_name': vaultName,
        'amount': amount,
        'value_in_usd': valueInUsd,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a withdrawal from a vault
  void trackVaultWithdrawPressed({
    required String vaultName,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      VaultTrackingEvent.onVaultWithdrawPressed({
        'vault_name': vaultName,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a vault withdrawal transaction settles on-chain
  void trackVaultWithdrawSuccess({
    required String vaultName,
    required double amount,
    required double valueInUsd,
    required String walletId,
  }) {
    trackingRepository.track(
      VaultTrackingEvent.onVaultWithdrawSuccess({
        'vault_name': vaultName,
        'amount': amount,
        'value_in_usd': valueInUsd,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user initiates a borrow against their vault position
  void trackVaultBorrowPressed({
    required String vaultName,
    required double amount,
    required String walletId,
  }) {
    trackingRepository.track(
      VaultTrackingEvent.onVaultBorrowPressed({
        'vault_name': vaultName,
        'amount': amount,
        'wallet_id': walletId,
      }),
    );
  }
}

extension VersusTracking on TrackingCubit {
  /// Tracks when a user views a versus matchup
  void trackVersusMatchView({
    required String marketName,
    required String walletId,
  }) {
    trackingRepository.track(
      VersusTrackingEvent.onVersusMatchView({
        'market_name': marketName,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user casts a vote for an athlete
  void trackVersusVoteCast({
    required String athleteName,
    required String marketName,
    required String walletId,
  }) {
    trackingRepository.track(
      VersusTrackingEvent.onVersusVoteCast({
        'athlete_name': athleteName,
        'market_name': marketName,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user sends a message in the versus chat
  void trackVersusChatSent({
    required String marketName,
    required String walletId,
  }) {
    trackingRepository.track(
      VersusTrackingEvent.onVersusChatSent({
        'market_name': marketName,
        'wallet_id': walletId,
      }),
    );
  }

  /// Tracks when a user shares an athlete card
  void trackVersusShareCard({
    required String athleteName,
    required String walletId,
  }) {
    trackingRepository.track(
      VersusTrackingEvent.onVersusShareCard({
        'athlete_name': athleteName,
        'wallet_id': walletId,
      }),
    );
  }
}
