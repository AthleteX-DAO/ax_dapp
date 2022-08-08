import 'dart:async';

import 'package:shared/shared.dart';
import 'package:wallet_repository/wallet_repository.dart';

export 'package:wallet_repository/wallet_repository.dart' hide WalletRepository;

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        super(
          WalletState(
            chain: walletRepository.currentChain,
            status: WalletStatus.fromChain(walletRepository.currentChain),
          ),
        ) {
    on<ConnectWalletRequested>(_onConnectWalletRequested);
    on<DisconnectWalletRequested>(_onDisconnectWalletRequested);
    on<WatchChainChangesStarted>(_onWatchChainChangesStarted);
    on<SwitchChainRequested>(_onSwitchChainRequested);
    on<WalletFailed>(_onWalletFailed);

    add(const WatchChainChangesStarted());
  }

  final WalletRepository _walletRepository;

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

  void _onDisconnectWalletRequested(
    DisconnectWalletRequested _,
    Emitter<WalletState> emit,
  ) {
    _walletRepository.disconnectWallet();
    emit(state.copyWith(walletAddress: kEmptyAddress));
  }

  Future<void> _onWatchChainChangesStarted(
    WatchChainChangesStarted event,
    Emitter<WalletState> emit,
  ) async {
    await emit.forEach<EthereumChain>(
      _walletRepository.chainChanges,
      onData: (chain) => state.copyWith(
        chain: chain,
        status: WalletStatus.fromChain(chain),
      ),
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
}
