import 'package:ax_dapp/my_liquidity/models/models.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'my_liquidity_event.dart';
part 'my_liquidity_state.dart';

class MyLiquidityBloc extends Bloc<MyLiquidityEvent, MyLiquidityState> {
  MyLiquidityBloc({
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required this.repo,
  })  : _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChanges,
        super(const MyLiquidityState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<FetchAllLiquidityPositionsRequested>(
      _onFetchAllLiquidityPositionsRequested,
    );
    on<SearchTermChanged>(_onSearchTermChanged);

    add(const FetchAllLiquidityPositionsRequested());
  }

  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final GetAllLiquidityInfoUseCase repo;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<MyLiquidityState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (_) => add(const FetchAllLiquidityPositionsRequested()),
    );
  }

  Future<void> _onFetchAllLiquidityPositionsRequested(
    FetchAllLiquidityPositionsRequested event,
    Emitter<MyLiquidityState> emit,
  ) async {
    if (_walletRepository.currentWallet.isDisconnected) {
      emit(
        state.copyWith(
          status: BlocStatus.noWallet,
          failure: DisconnectedWalletFailure(),
        ),
      );
      return;
    }
    emit(state.copyWith(status: BlocStatus.loading, failure: Failure.none));
    final currentWallet = _walletRepository.currentWallet;
    try {
      final response = await repo.fetchAllLiquidityPositions(
        walletAddress: currentWallet.address,
      );
      final isSuccess = response.isLeft();
      if (isSuccess) {
        final liquidityPositionsList =
            response.getLeft().toNullable()!.liquidityPositionsList;
        if (liquidityPositionsList != null) {
          emit(
            state.copyWith(
              cards: liquidityPositionsList,
              filteredCards: liquidityPositionsList,
              status: BlocStatus.success,
              failure: Failure.none,
            ),
          );
        } else {
          emit(state.copyWith(
              status: BlocStatus.noData, filteredCards: [], cards: []));
        }
        add(SearchTermChanged(searchTerm: state.searchTerm));
      } else {
        emit(state.copyWith(status: BlocStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<MyLiquidityState> emit,
  ) async {
    final searchTerm = event.searchTerm;
    if (searchTerm.isEmpty && state.cards.isEmpty) {
      return;
    }
    final formattedSearchTerm = searchTerm.trim().toLowerCase();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        searchTerm: formattedSearchTerm,
      ),
    );
    final filteredList = state.cards
        .where(
          (liquidityPosition) =>
              liquidityPosition.token0Name
                  .toLowerCase()
                  .contains(formattedSearchTerm) ||
              liquidityPosition.token1Name
                  .toLowerCase()
                  .contains(formattedSearchTerm) ||
              liquidityPosition.token0Symbol
                  .toLowerCase()
                  .contains(formattedSearchTerm) ||
              liquidityPosition.token1Symbol
                  .toLowerCase()
                  .contains(formattedSearchTerm),
        )
        .toList();
    emit(
      state.copyWith(
        status: BlocStatus.success,
        filteredCards: filteredList,
      ),
    );
  }
}
