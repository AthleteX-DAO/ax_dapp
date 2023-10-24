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

class MetamaskProfileViewRequested extends ProfileViewRequested {
  const MetamaskProfileViewRequested();
}

class ProfileViewRequestedFromSignUp extends ProfileViewRequested {
  ProfileViewRequestedFromSignUp({
    required this.email,
    required this.password,
  });
  String? email;
  String? password;

  @override
  List<Object?> get props => [email, password];
}

class ProfileViewRequestedFromLogin extends ProfileViewRequested {
  ProfileViewRequestedFromLogin({
    required this.email,
    required this.password,
  });
  String? email;
  String? password;

  @override
  List<Object?> get props => [email, password];
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
