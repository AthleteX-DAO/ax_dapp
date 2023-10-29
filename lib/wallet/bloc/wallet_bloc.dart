import 'dart:async';

import 'package:ax_dapp/wallet/exceptions/exceptions.dart';
import 'package:ax_dapp/wallet/models/models.dart';
import 'package:ax_dapp/wallet/repository/firebase_auth_repository.dart';
import 'package:ax_dapp/wallet/repository/firestore_credentials_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

export 'package:wallet_repository/wallet_repository.dart' hide WalletRepository;

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
    required FireStoreCredentialsRepository fireStoreCredentialsRepository,
    required FireBaseAuthRepository fireBaseAuthRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _fireStoreCredentialsRepository = fireStoreCredentialsRepository,
        _fireBaseAuthRepository = fireBaseAuthRepository,
        super(WalletState.fromWallet(wallet: walletRepository.currentWallet)) {
    // Connect the web3 wallet
    on<ConnectWalletRequested>(_onConnectWalletRequested);
    on<DisconnectWalletRequested>(_onDisconnectWalletRequested);

    // WalletView Status
    on<LoginSignUpViewRequested>(_onLoginSignUpViewRequested);
    on<SignUpViewRequested>(_onSignUpViewRequested);
    on<LoginViewRequested>(_onLoginViewRequested);
    on<ProfileViewRequested>(_onProfileViewRequested);
    on<ProfileViewRequestedFromSignUp>(_onProfileViewRequestedFromSignUp);
    on<ProfileViewRequestedFromLogin>(_onProfileViewRequestedFromLogin);
    on<ResetPasswordViewRequested>(_onResetPasswordViewRequested);
    on<ResetPassword>(_onResetPassword);

    // Watch for changes
    on<WatchWalletChangesStarted>(_onWatchWalletChangesStarted);
    on<WatchAxtChangesStarted>(_onWatchAxtChangesStarted);
    on<UpdateAxDataRequested>(_onUpdateAxDataRequested);
    on<GetGasPriceRequested>(_onGetGasPriceRequested);
    on<WalletFailed>(_onWalletFailed);
    on<AuthFailed>(_onAuthFailed);

    add(const WatchWalletChangesStarted());
    add(const WatchAxtChangesStarted());
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;
  final FireStoreCredentialsRepository _fireStoreCredentialsRepository;
  final FireBaseAuthRepository _fireBaseAuthRepository;

  Future<void> _onLoginSignUpViewRequested(
    LoginSignUpViewRequested _,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.initial));
  }

  Future<void> _onSignUpViewRequested(
    SignUpViewRequested _,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.signup));
  }

  Future<void> _onLoginViewRequested(
    LoginViewRequested _,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.login));
  }

  void _onResetPasswordViewRequested(
    ResetPasswordViewRequested event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.resetPassword));
  }

  Future<void> _onProfileViewRequestedFromLogin(
    ProfileViewRequestedFromLogin event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.loading));
    final email = event.email;
    final password = event.password;
    try {
      await _fireBaseAuthRepository.signIn(
        email: email!,
        password: password!,
      );
      final hex = await _fireStoreCredentialsRepository.loadCredentials(email);
      final walletAddress = await _walletRepository.importWallet(hex);
      final privateKey = _walletRepository.privateKey;
      debugPrint(privateKey);
      emit(
        state.copyWith(
          walletAddress: walletAddress,
          walletStatus: WalletStatus.connected,
          walletViewStatus: WalletViewStatus.profile,
        ),
      );
    } on LogInWithEmailAndPasswordFailure catch (e) {
      debugPrint('ERROR: $e');
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          errorMessage: e.message,
          walletViewStatus: WalletViewStatus.login,
        ),
      );
    } catch (_) {
      debugPrint('ERROR: $_');
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          walletViewStatus: WalletViewStatus.login,
        ),
      );
    }
  }

  Future<void> _onProfileViewRequestedFromSignUp(
    ProfileViewRequestedFromSignUp event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.loading));
    final email = event.email;
    final password = event.password;
    try {
      await _fireBaseAuthRepository.createUser(
        email: email!,
        password: password!,
      );
      final walletAddress = await _walletRepository.createWallet();
      emit(
        state.copyWith(
          walletAddress: walletAddress,
          walletViewStatus: WalletViewStatus.profile,
        ),
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          errorMessage: e.message,
          walletViewStatus: WalletViewStatus.signup,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          walletViewStatus: WalletViewStatus.signup,
        ),
      );
    }

    try {
      await _fireStoreCredentialsRepository.storeCredentials(email!);
    } catch (e) {
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          walletViewStatus: WalletViewStatus.signup,
        ),
      );
      debugPrint('ERROR: $e');
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<WalletState> emit,
  ) async {
    final email = event.email;
    try {
      await _fireBaseAuthRepository.resetPassword(email: email!);
      emit(
        state.copyWith(
          walletViewStatus: WalletViewStatus.login,
        ),
      );
    } on SendPasswordResetFailure catch (e) {
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          errorMessage: e.message,
          walletViewStatus: WalletViewStatus.initial,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          walletViewStatus: WalletViewStatus.initial,
        ),
      );
    }
  }

  Future<void> _onProfileViewRequested(
    ProfileViewRequested _,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.loading));
    emit(state.copyWith(walletViewStatus: WalletViewStatus.profile));
  }

  Future<void> _onConnectWalletRequested(
    ConnectWalletRequested _,
    Emitter<WalletState> emit,
  ) async {
    try {
      final walletAddress = await _walletRepository.connectWallet();
      emit(
        state.copyWith(
          walletAddress: walletAddress,
          walletViewStatus: WalletViewStatus.profile,
        ),
      );
    } on WalletFailure catch (failure) {
      add(WalletFailed(failure));
    }
  }

  void _onDisconnectWalletRequested(
    DisconnectWalletRequested _,
    Emitter<WalletState> emit,
  ) {
    _walletRepository.disconnectWallet();
    _fireBaseAuthRepository.signOut();
    emit(
      WalletState.fromWallet(
        wallet: const Wallet.disconnected(),
      ),
    );
  }

  Future<void> _onWatchWalletChangesStarted(
    WatchWalletChangesStarted event,
    Emitter<WalletState> emit,
  ) async {
    await emit.forEach<Wallet>(
      _walletRepository.walletChanges,
      onData: (wallet) => state.copyWithWallet(wallet),
    );
  }

  Future<void> _onWatchAxtChangesStarted(
    WatchAxtChangesStarted event,
    Emitter<WalletState> emit,
  ) async {
    await emit.onEach<Token>(
      _tokensRepository.axtChanges,
      // Tokens are only being updated when the new chain is supported.
      // `axtChanges` will also emit after user's wallet is connected, since
      // new tokens will be generated, thus ax data will be updated.
      onData: (_) => add(const UpdateAxDataRequested()),
    );
  }

  // Again I think this should be handled elsewhere
  Future<void> _onUpdateAxDataRequested(
    UpdateAxDataRequested event,
    Emitter<WalletState> emit,
  ) async {
    final axMarketData = await _tokensRepository.getAxMarketData();
    final currentAxtAddress = _tokensRepository.currentAxt.address;
    final axBalance =
        await _walletRepository.getTokenBalance(currentAxtAddress);
    final axData = AxData.fromAxMarketData(axMarketData);
    emit(state.copyWith(axData: axData.copyWith(balance: axBalance)));
  }

  // IMO this should be moved to a repository or something that does this consistently
  Future<void> _onGetGasPriceRequested(
    GetGasPriceRequested event,
    Emitter<WalletState> emit,
  ) async {
    final gasPrice = await _walletRepository.getGasPrice();
    emit(state.copyWith(gasPrice: gasPrice));
  }

  void _onWalletFailed(
    WalletFailed event,
    Emitter<WalletState> emit,
  ) {
    final failure = event.failure;
    emit(state.copyWith(failure: failure));
    emit(state.copyWith(failure: WalletFailure.none));
    if (failure.needsReconnecting) {
      add(const DisconnectWalletRequested());
    }
  }

  Future<void> _onAuthFailed(
    AuthFailed event,
    Emitter<WalletState> emit,
  ) async {
    final walletViewStatus = event.walletViewStatus.currentStatus();
    emit(
      WalletState.fromWallet(
        walletViewStatus: walletViewStatus,
        wallet: const Wallet.disconnected(),
      ),
    );
  }
}
