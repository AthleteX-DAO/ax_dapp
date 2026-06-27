import 'package:tracking_repository/src/track_event.dart';

/// Events for the Earn/Vaults page
class VaultTrackingEvent extends TrackEvent {
  /// Tracks when a user views a specific vault
  VaultTrackingEvent.onVaultView(
    Map<String, dynamic> params,
  ) : super(name: 'vault_view', params: params);

  /// Tracks when a user initiates a deposit into a vault
  VaultTrackingEvent.onVaultDepositPressed(
    Map<String, dynamic> params,
  ) : super(name: 'vault_deposit_pressed', params: params);

  /// Tracks when a vault deposit transaction settles on-chain
  VaultTrackingEvent.onVaultDepositSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'vault_deposit_success', params: params);

  /// Tracks when a user initiates a withdrawal from a vault
  VaultTrackingEvent.onVaultWithdrawPressed(
    Map<String, dynamic> params,
  ) : super(name: 'vault_withdraw_pressed', params: params);

  /// Tracks when a vault withdrawal transaction settles on-chain
  VaultTrackingEvent.onVaultWithdrawSuccess(
    Map<String, dynamic> params,
  ) : super(name: 'vault_withdraw_success', params: params);

  /// Tracks when a user initiates a borrow against their vault position
  VaultTrackingEvent.onVaultBorrowPressed(
    Map<String, dynamic> params,
  ) : super(name: 'vault_borrow_pressed', params: params);
}
