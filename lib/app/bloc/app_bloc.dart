import 'package:bloc/bloc.dart';
import 'package:config_repository/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
    required ConfigRepository configRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _configRepository = configRepository,
        super(const AppState()) {
    on<WatchChainChangesStarted>(_onWatchChainChangesStarted);
    on<WatchAptsChangesStarted>(_onWatchAptsChangesStarted);

    add(const WatchChainChangesStarted());
    add(const WatchAptsChangesStarted());
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;
  final ConfigRepository _configRepository;

  Future<void> _onWatchChainChangesStarted(
    WatchChainChangesStarted _,
    Emitter<AppState> emit,
  ) async {
    await emit.onEach<EthereumChain>(
      _walletRepository.chainChanges,
      onData: (chain) {
        _tokensRepository.switchTokens(chain);
        _configRepository.switchDependencies(chain);
      },
    );
  }

  Future<void> _onWatchAptsChangesStarted(
    WatchAptsChangesStarted _,
    Emitter<AppState> emit,
  ) async {
    await emit.onEach<List<Apt>>(
      _tokensRepository.aptsChanges,
      onData: (apts) {
        final previousApts = _tokensRepository.previousApts;
        if (previousApts.isEmpty) {
          return;
        }
        final currentLspAddress = _configRepository.currentLspAddress;
        final previousAptPair =
            previousApts.findPairByAddress(currentLspAddress);
        if (previousAptPair.isEmpty) {
          return;
        }
        final currentAptPair =
            apts.findPairByAthleteId(previousAptPair.athleteId);
        if (currentAptPair.isNotEmpty) {
          _configRepository.switchLspClient(currentAptPair.address);
        }
      },
    );
  }
}
