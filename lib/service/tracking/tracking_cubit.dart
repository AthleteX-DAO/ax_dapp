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
