part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoginSignUpViewRequested extends WalletEvent {
  const LoginSignUpViewRequested();
}

class LoginViewRequested extends WalletEvent {
  const LoginViewRequested();
}

class SignUpViewRequested extends WalletEvent {
  const SignUpViewRequested();
}

class ProfileViewRequested extends WalletEvent {
  const ProfileViewRequested();
}

class ResetPasswordViewRequested extends WalletEvent {
  const ResetPasswordViewRequested();
}

class MetamaskProfileViewRequested extends WalletEvent {
  const MetamaskProfileViewRequested();
}

class ProfileViewRequestedFromSignUp extends WalletEvent {
  const ProfileViewRequestedFromSignUp({
    required this.email,
    required this.password,
  });
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [email, password];
}

class ProfileViewRequestedFromLogin extends WalletEvent {
  const ProfileViewRequestedFromLogin({
    required this.email,
    required this.password,
  });
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [email, password];
}

class ResetPassword extends WalletEvent {
  const ResetPassword({required this.email});

  final String? email;

  @override
  List<Object?> get props => [email];
}

class ConnectWalletRequested extends WalletEvent {
  const ConnectWalletRequested();
}

class DisconnectWalletRequested extends WalletEvent {
  const DisconnectWalletRequested();
}

class WatchWalletChangesStarted extends WalletEvent {
  const WatchWalletChangesStarted();
}

class SwitchChainRequested extends WalletEvent {
  const SwitchChainRequested(this.chain);

  final EthereumChain? chain;

  @override
  List<Object?> get props => [chain];
}

class WatchAxtChangesStarted extends WalletEvent {
  const WatchAxtChangesStarted();
}

class UpdateAxDataRequested extends WalletEvent {
  const UpdateAxDataRequested();
}

class GetGasPriceRequested extends WalletEvent {
  const GetGasPriceRequested();
}

class WalletFailed extends WalletEvent {
  const WalletFailed(this.failure);

  final WalletFailure failure;

  @override
  List<Object?> get props => [failure];
}

class AuthFailed extends WalletEvent {
  const AuthFailed({required this.walletViewStatus});

  final WalletViewStatus walletViewStatus;

  @override
  List<Object?> get props => [walletViewStatus];
}
