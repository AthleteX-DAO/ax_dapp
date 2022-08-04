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

extension ConnectWalletTracking on TrackingCubit {
  void onPressedConnectWallet({
    required String publicAddress,
  }) {
    trackingRepository.track(
      ScoutPageTrackingEvent.onPressedConnectWallet({
        'public_address': publicAddress,
      }),
    );
  }
}

extension ScoutPageTracking on TrackingCubit {
  /// Get athlete view information for analytics
  void trackAthleteView({
    required String athleteName,
  }) {
    trackingRepository.track(
      ScoutPageTrackingEvent.onPressedAthleteView(
        {'apt_player_name': athleteName},
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteBuy(
        {
          'apt_name': aptName,
        },
      ),
    );
  }

  /// Get athlete info when buy confirm button clicked for analytics
  void trackAthleteBuyConfirmButtonClicked({
    required int id,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmBuy(
        {
          'apt_id': id,
        },
      ),
    );
  }

  /// Get athlete info when buy success for analytics
  void trackAthleteBuySuccess({
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteSell(
        {
          'apt_name': athleteName,
        },
      ),
    );
  }

  /// Get athlete info when sell confirm button clicked for analytics
  void trackAthleteSellConfirmButtonClicked({
    required int id,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmSell(
        {
          'apt_id': id,
        },
      ),
    );
  }

  /// Get athlete info when sell successful for analytics
  void trackAthleteSellSuccess({
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
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedAthleteMint(
        {
          'apt_name': aptName,
        },
      ),
    );
  }

  /// Get athlete info when mint confirmed button clicked for analytics
  void trackAthleteMintConfirmButtonClicked({
    required String sport,
  }) {
    trackingRepository.track(
      AthletePageTrackingEvent.onPressedConfirmMint(
        {
          'sport': sport,
        },
      ),
    );
  }

  /// Get athlete info when mint successful for analytics
  void trackAthleteMintSuccess({
    required String inputApt,
    required String valueInAx,
    required String walletId,
  }) {
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
  void onPoolCreated({
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

  void onPoolApproveClick({required String currencyOne}) {
    trackingRepository.track(
      PoolPageUserEvent.onApprovePoolClick(
        {
          'currency_1': currencyOne,
        },
      ),
    );
  }

  void onPoolConfirmClick({required String currencyTwo}) {
    trackingRepository.track(
      PoolPageUserEvent.onConfirmPoolClick(
        {
          'currency_2': currencyTwo,
        },
      ),
    );
  }

  void onPoolRemoval({
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
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'percent_removal': percentRemoval,
          'wallet_id': walletId,
          'lp_token_name': lpTokenName
        },
      ),
    );
  }

  void onPoolRemovalApproveClick({required String currencyOne}) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveApproveClick(
        {
          'currency_1': currencyOne,
        },
      ),
    );
  }

  void onPoolRemovalConfirmClick({required String currencyTwo}) {
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
  void onSwapConfirmedTransaction({
    required String fromUnits,
    required String toUnits,
    required String totalFee,
    required String walletId,
  }) {
    trackingRepository.track(
      TradePageUserEvent.onSwapConfirmedTransaction(
        {
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletId,
        },
      ),
    );
  }

  void onSwapApproveClick({required String fromCurrency}) {
    trackingRepository.track(
      TradePageUserEvent.onApproveClick(
        {'from_currency': fromCurrency},
      ),
    );
  }

  void onSwapConfirmClick({required String toCurrency}) {
    trackingRepository.track(
      TradePageUserEvent.onConfirmClick(
        {'to_currency': toCurrency},
      ),
    );
  }
}
