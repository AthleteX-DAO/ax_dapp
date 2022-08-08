import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        super(const AppState()) {
    on<WatchChainChangesStarted>(_onWatchChainChangesStarted);

    add(const WatchChainChangesStarted());
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;

  Future<void> _onWatchChainChangesStarted(
    WatchChainChangesStarted _,
    Emitter<AppState> emit,
  ) async {
    await emit.onEach<EthereumChain>(
      _walletRepository.chainChanges,
      onData: _tokensRepository.switchTokens,
    );
  }
}
