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
    String valueOne,
    String valueTwo,
    String lpTokens,
    String shareOfPool,
    String lpTokenName,
    String walletId,
  ) {
    trackingRepository.track(
      PoolPageUserEvent.onPoolCreate()
        ..params = {
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'lp_token_name': lpTokenName,
          'wallet_id': walletId,
        },
    );
  }

  void onPoolApproveClick(String currencyOne) {
    trackingRepository.track(
      PoolPageUserEvent.onApprovePoolClick()
        ..params = {
          'currency_1': currencyOne,
        },
    );
  }

  void onPoolConfirmClick(String currencyTwo) {
    trackingRepository.track(
      PoolPageUserEvent.onConfirmPoolClick()
        ..params = {
          'currency_2': currencyTwo,
        },
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
      PoolPageUserEvent.onPoolRemove()
        ..params = {
          'value_1': valueOne,
          'value_2': valueTwo,
          'lp_tokens': lpTokens,
          'share_of_pool': shareOfPool,
          'percent_removal': percentRemoval,
          'wallet_id': walletId
        },
    );
  }

  void onPoolRemovalApproveClick(String currencyOne) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveApproveClick()
        ..params = {
          'currency_1': currencyOne,
        },
    );
  }

  void onPoolRemovalConfirmClick(String currencyTwo) {
    trackingRepository.track(
      PoolPageUserEvent.onRemoveConfirmClick()
        ..params = {
          'currency_2': currencyTwo,
        },
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
      TradePageUserEvent.onSwapConfirmedTransaction()
        ..params = {
          'from_units': fromUnits,
          'to_units': toUnits,
          'fee': totalFee,
          'wallet_id': walletID,
        },
    );
  }

  void onSwapApproveClick(String fromCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onApproveClick()
        ..params = {'from_currency': fromCurrency},
    );
  }

  void onSwapConfirmClick(String toCurrency) {
    trackingRepository.track(
      TradePageUserEvent.onConfirmClick()..params = {'to_currency': toCurrency},
    );
  }
}
