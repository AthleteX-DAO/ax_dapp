import 'dart:async';

import 'package:ax_dapp/wallet/models/models.dart';
import 'package:ax_dapp/wallet/usecases/cross_chain_balance_usecase.dart';
import 'package:ax_dapp/wallet/usecases/synthetix_account_bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:user_authentication/user_authentication.dart';
import 'package:wallet_repository/wallet_repository.dart';

export 'package:wallet_repository/wallet_repository.dart' hide WalletRepository;

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required WalletRepository walletRepository,
    required this.crossChainBalanceUseCase,
    required TokensRepository tokensRepository,
    required FireStoreCredentialsRepository fireStoreCredentialsRepository,
    required FireBaseAuthRepository fireBaseAuthRepository,
    required SynthetixAccountBootstrap synthetixAccountBootstrap,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _fireStoreCredentialsRepository = fireStoreCredentialsRepository,
        _fireBaseAuthRepository = fireBaseAuthRepository,
        _synthetixAccountBootstrap = synthetixAccountBootstrap,
        super(WalletState.fromWallet(wallet: walletRepository.currentWallet)) {
    on<ConnectWalletRequested>(_onConnectWalletRequested);
    on<DisconnectWalletRequested>(_onDisconnectWalletRequested);
    on<SwitchChainRequested>(_onSwitchChainRequested);
    on<LoginSignUpViewRequested>(_onLoginSignUpViewRequested);
    on<SignUpViewRequested>(_onSignUpViewRequested);
    on<LoginViewRequested>(_onLoginViewRequested);
    on<ProfileViewRequested>(_onProfileViewRequested);
    on<ProfileViewRequestedFromSignUp>(_onProfileViewRequestedFromSignUp);
    on<ProfileViewRequestedFromLogin>(_onProfileViewRequestedFromLogin);
    on<ResetPasswordViewRequested>(_onResetPasswordViewRequested);
    on<ResetPassword>(_onResetPassword);
    on<EmailChanged>(_onEmailChanged);
    on<PassWordChanged>(_onPassWordChanged);
    on<WatchWalletChangesStarted>(_onWatchWalletChangesStarted);
    on<WatchAxtChangesStarted>(_onWatchAxtChangesStarted);
    on<WatchTokenChangesStarted>(_onWatchTokenChangesStarted);
    on<UpdateAxDataRequested>(_onUpdateAxDataRequested);
    on<GetGasPriceRequested>(_onGetGasPriceRequested);
    on<WalletFailed>(_onWalletFailed);
    on<AuthFailed>(_onAuthFailed);
    on<InfoMessageCleared>(_onInfoMessageCleared);
    on<FetchWalletBalanceRequested>(_onFetchWalletBalanceRequested);

    add(const WatchWalletChangesStarted());
    add(const WatchTokenChangesStarted());
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;

  final CrossChainBalanceUseCase crossChainBalanceUseCase;
  final FireStoreCredentialsRepository _fireStoreCredentialsRepository;
  final FireBaseAuthRepository _fireBaseAuthRepository;
  final SynthetixAccountBootstrap _synthetixAccountBootstrap;

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
    emit(
      state.copyWith(walletViewStatus: WalletViewStatus.loading));
    debugPrint('========== LOGIN FLOW START ==========');
    debugPrint('1. Emitted loading');
    final email = state.email;
    final password = state.password;
    debugPrint('2. Email: $email, Password length: ${password.length}');
    try {
      debugPrint('3. About to signIn to Firebase Auth');
      await _fireBaseAuthRepository.signIn(
        email: email,
        password: password,
      );
      debugPrint('4. SignIn succeeded');
      
      debugPrint('5. About to load and decrypt credentials from Firebase');
      final privateKeyHex = await _fireStoreCredentialsRepository.loadCredentials(
        email,
        password,
      );
      debugPrint('6. Credentials decrypted, hex length: ${privateKeyHex.length}');
      
      debugPrint('7. About to import wallet');
      final walletAddress = await _walletRepository.importWallet(privateKeyHex);
      debugPrint('8. Imported wallet: $walletAddress');
      
      debugPrint('9. About to ensure Synthetix account');
      unawaited(_ensureSynthetixAccount(emit));
      
      debugPrint('10. About to emit profile');
      emit(
        state.copyWith(
          walletAddress: walletAddress,
          walletStatus: WalletStatus.connected,
          walletViewStatus: WalletViewStatus.profile,
        ),
      );
      debugPrint('11. LOGIN COMPLETE: walletViewStatus=${state.walletViewStatus}');
      debugPrint('========== LOGIN FLOW END ==========');
    } on LogInWithEmailAndPasswordFailure catch (e) {
      debugPrint('ERROR LoginFailure: $e');
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          errorMessage: e.message,
          walletViewStatus: WalletViewStatus.login,
        ),
      );
    } catch (e, st) {
      debugPrint('ERROR Generic: $e\n$st');
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          walletViewStatus: WalletViewStatus.login,
        ),
      );
    }
  }

  FutureOr<void> _onSwitchChainRequested(
    SwitchChainRequested event,
    Emitter<WalletState> emit,
  ) async {
    final chain = event.chain;
    if (chain == null) return;
    try {
      await _walletRepository.switchChain(chain);
      emit(state.copyWith(chain: event.chain));
    } on WalletFailure catch (failure) {
      add(WalletFailed(failure));
    }
  }

  Future<void> _onProfileViewRequestedFromSignUp(
    ProfileViewRequestedFromSignUp event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(walletViewStatus: WalletViewStatus.loading));
    final email = state.email;
    final password = state.password;
    debugPrint('========== SIGNUP FLOW START ==========');
    debugPrint('1. Emitted loading');
    debugPrint('2. Email: $email, Password length: ${password.length}');
    try {
      debugPrint('3. About to createUser in Firebase Auth');
      await _fireBaseAuthRepository.createUser(
        email: email,
        password: password,
      );
      debugPrint('4. User created successfully in Firebase Auth');
      
      debugPrint('5. About to create wallet with recovery phrase');
      final walletResult = await _walletRepository.createWalletWithRecoveryPhrase();
      
      if (!walletResult.isValid) {
        throw Exception('Failed to create wallet');
      }
      
      final walletAddress = walletResult.address;
      final privateKeyHex = walletResult.privateKeyHex;
      final recoveryPhrase = walletResult.recoveryPhrase;
      
      debugPrint('6. Wallet created: $walletAddress');
      debugPrint('7. Recovery phrase generated (${walletResult.recoveryWords.length} words)');
      
      debugPrint('8. About to encrypt and store credentials in Firebase');
      unawaited(
        _fireStoreCredentialsRepository
            .storeCredentials(email, password, privateKeyHex)
            .then((_) => debugPrint('9. Credentials encrypted and stored successfully'))
            .catchError((e) {
          debugPrint('9. Credentials backup failed: $e');
          if (!emit.isDone) {
            emit(
              state.copyWith(
                infoMessage:
                    'Backup failed. Please save your recovery phrase. You can retry backup from settings.',
              ),
            );
          }
        }),
      );

      debugPrint('10. About to ensure Synthetix account');
      unawaited(_ensureSynthetixAccount(emit));

      debugPrint('11. About to emit profile with recovery phrase');
      emit(
        state.copyWith(
          walletAddress: walletAddress,
          walletStatus: WalletStatus.connected,
          walletViewStatus: WalletViewStatus.profile,
          recoveryPhrase: recoveryPhrase, // Add recovery phrase to state
        ),
      );
      debugPrint('12. SIGNUP COMPLETE: walletViewStatus=${state.walletViewStatus}');
      debugPrint('========== SIGNUP FLOW END ==========');
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      debugPrint('ERROR SignUpFailure: $e');
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          errorMessage: e.message,
          walletViewStatus: WalletViewStatus.signup,
        ),
      );
    } catch (e, st) {
      debugPrint('ERROR Generic SignUp: $e\n$st');
      emit(
        state.copyWith(
          failure: WalletFailure.fromUnsuccessfulOperation(),
          errorMessage: 'Signup failed: ${e.toString()}',
          walletViewStatus: WalletViewStatus.signup,
        ),
      );
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<WalletState> emit,
  ) async {
    final email = state.email;
    try {
      await _fireBaseAuthRepository.resetPassword(email: email);
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

  void _onEmailChanged(
    EmailChanged event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onPassWordChanged(
    PassWordChanged event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onConnectWalletRequested(
    ConnectWalletRequested _,
    Emitter<WalletState> emit,
  ) async {
    try {
      final walletAddress = await _walletRepository.connectWallet();
      unawaited(_ensureSynthetixAccount(emit));
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
      onData: (wallet) {
        debugPrint('WALLET CHANGED: address=${wallet.address} status=${wallet.status} walletviewstatus=${state.walletViewStatus}');
        return state.copyWithWallet(wallet);
      }
    );
  }


  Future<void> _onFetchWalletBalanceRequested(
    FetchWalletBalanceRequested event,
    Emitter<WalletState> emit,
  ) async {
    final walletBalance =
        await crossChainBalanceUseCase.usdcBalance(state.chain);
    emit(state.copyWith(walletBalance: walletBalance));
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

  Future<void> _onWatchTokenChangesStarted(
    WatchTokenChangesStarted event,
    Emitter<WalletState> emit,
  ) async {
    await emit.onEach<List<Token>>(
      _tokensRepository.tokensChanges,
      onData: (tokens) => emit(
        state.copyWith(
          tokens: tokens,
        ),
      ),
    );
  }

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

  Future<void> _ensureSynthetixAccount(
    Emitter<WalletState> emit,
  ) async {
    try {
      await _synthetixAccountBootstrap.ensureAccount(
        walletAddress: state.walletAddress,
        walletRepository: _walletRepository,
      );
    } catch (e) {
      emit(
        state.copyWith(
          infoMessage: 'We could not finish your account setup. You can retry from settings.',
        ),
      );
    }
  }

  Future<void> _onAuthFailed(
    AuthFailed event,
    Emitter<WalletState> emit,
  ) async {
    debugPrint('🔴 AuthFailed dispatched! Current viewStatus: ${state.walletViewStatus}, Event viewStatus: ${event.walletViewStatus}');
    final walletViewStatus = event.walletViewStatus.currentStatus();
    debugPrint('🔴 AuthFailed setting viewStatus to: $walletViewStatus');
    
    // Use copyWith to preserve existing state instead of creating brand new state
    emit(
      state.copyWith(
        walletViewStatus: walletViewStatus,
        walletStatus: WalletStatus.disconnected,
        walletAddress: kEmptyAddress,
        failure: WalletFailure.none,
        errorMessage: null,
      ),
    );
    debugPrint('🔴 AuthFailed complete. New viewStatus: ${state.walletViewStatus}');
  }

  void _onInfoMessageCleared(
    InfoMessageCleared _,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(infoMessage: null));
  }

}
