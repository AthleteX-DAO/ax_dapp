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
  ) {
    trackingRepository.trackPoolCreation(PoolPageUserEvent.onPoolCreate(),
      valueOne, valueTwo, lpTokens, shareOfPool, lpTokenName,);
  }
}

extension PoolPageApproveClicked on TrackingCubit {
  void onPoolApproveClick(String currencyOne) {
    trackingRepository.trackPoolApproveClick(
        PoolPageUserEvent.onApprovePoolClick(), currencyOne,);
  }
}

extension PoolPageConfirmClicked on TrackingCubit {
  void onPoolConfirmClick(String currencyTwo) {
    trackingRepository.trackPoolConfirmClick(
        PoolPageUserEvent.onConfirmPoolClick(), currencyTwo,);
  }
}

extension PoolPageRemoval on TrackingCubit {
  void onPoolRemoval(
    String valueOne,
    String valueTwo,
    String lpTokens,
    String shareOfPool,
    double percentRemoval,
  ) {
    trackingRepository.trackPoolRemoval(PoolPageUserEvent.onPoolRemove(),
      valueOne, valueTwo, lpTokens, shareOfPool, percentRemoval,);
  }
}

extension PoolPageRemovalApproveClicked on TrackingCubit {
  void onPoolRemovalApproveClick(String currencyOne) {
    trackingRepository.trackPoolRemovalApproveClick(
        PoolPageUserEvent.onRemoveApproveClick(), currencyOne,);
  }
}

extension PoolPageRemovalConfirmClicked on TrackingCubit {
  void onPoolRemovalConfirmClick(String currencyTwo) {
    trackingRepository.trackPoolRemovalConfirmClick(
        PoolPageUserEvent.onRemoveConfirmClick(), currencyTwo,);
  }
}
