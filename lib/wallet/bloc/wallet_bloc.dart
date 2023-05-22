import 'dart:async';
import 'package:ax_dapp/wallet/models/models.dart';
import 'package:ax_dapp/wallet/repository/magic_repository.dart';
import 'package:flutter/foundation.dart';
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
    required MagicRepository magicRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _magicRepository = magicRepository,
        super(WalletState.fromWallet(walletRepository.currentWallet)) {
    on<ConnectWalletRequested>(_onConnectWalletRequested);
    on<DisconnectWalletRequested>(_onDisconnectWalletRequested);
    on<WatchWalletChangesStarted>(_onWatchWalletChangesStarted);
    on<SwitchChainRequested>(_onSwitchChainRequested);
    on<WatchAxtChangesStarted>(_onWatchAxtChangesStarted);
    on<WatchMagicWalletChangesStarted>(_onWatchMagicWalletChangesStarted);
    on<UpdateAxDataRequested>(_onUpdateAxDataRequested);
    on<GetGasPriceRequested>(_onGetGasPriceRequested);
    on<WalletFailed>(_onWalletFailed);

    // Magic Wallet
    on<ConnectWalletMagic>(_onConnectWalletMagic);
    on<DisconnectWalletMagic>(_onDisconnectWalletMagic);
    add(const WatchWalletChangesStarted());
    add(const WatchMagicWalletChangesStarted());

    // Native Wallet
    on<ConnectNativeWallet>(_onConnectNativeWallet);

    add(const WatchAxtChangesStarted());
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;
  final MagicRepository _magicRepository;

  Future<void> _onConnectWalletRequested(
    ConnectWalletRequested _,
    Emitter<WalletState> emit,
  ) async {
    try {
      final walletAddress = await _walletRepository.connectWallet();
      emit(state.copyWith(walletAddress: walletAddress));
    } on WalletFailure catch (failure) {
      add(WalletFailed(failure));
    }
  }

  Future<void> _onConnectNativeWallet(
    ConnectNativeWallet event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final walletAddress = await _walletRepository.connectWallet();
      emit(state.copyWith(walletAddress: walletAddress));
    } on WalletFailure catch (e) {
      add(WalletFailed(e));
    }
  }

  void _onDisconnectWalletRequested(
    DisconnectWalletRequested _,
    Emitter<WalletState> emit,
  ) {
    _walletRepository.disconnectWallet();
    emit(state.copyWith(walletAddress: kEmptyAddress));
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

  FutureOr<void> _onSwitchChainRequested(
    SwitchChainRequested event,
    Emitter<WalletState> emit,
  ) async {
    final chain = event.chain;
    // user cancelled dropdown
    if (chain == null) return;
    try {
      await _walletRepository.switchChain(chain);
    } on WalletFailure catch (failure) {
      add(WalletFailed(failure));
    }
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

  Future<void> _onWatchMagicWalletChangesStarted(
    WatchMagicWalletChangesStarted event,
    Emitter<WalletState> emit,
  ) async {
    await emit.forEach<Wallet>(
      _magicRepository.walletChanges,
      onData: (wallet) => state.copyWithWallet(
        wallet,
      ),
    );
  }

  Future<void> _onConnectWalletMagic(
    ConnectWalletMagic event,
    Emitter<WalletState> emit,
  ) async {
    // This invokes the magicSDK to connect magic to the dapp
    debugPrint(
      'ConnectWalletMagic event emitted!',
    );

    final address = await _magicRepository.connect();

    debugPrint('Updating UI with this address: $address');
    emit(
      state.copyWith(
        walletAddress: address.toString(),
      ),
    );
  }

  Future<void> _onDisconnectWalletMagic(
    DisconnectWalletMagic event,
    Emitter<WalletState> emit,
  ) async {
    await _magicRepository.disconnect();
  }
}
