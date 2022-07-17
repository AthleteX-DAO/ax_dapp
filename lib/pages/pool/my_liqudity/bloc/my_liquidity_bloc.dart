import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/service/controller/usecases/get_wallet_address_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_liquidity_event.dart';
part 'my_liquidity_state.dart';

class MyLiquidityBloc extends Bloc<MyLiquidityEvent, MyLiquidityState> {
  MyLiquidityBloc({required this.repo, required this.controller})
      : super(MyLiquidityState.initial()) {
    on<LoadEvent>(_mapLoadEventToState);
    on<SearchBarInputEvent>(_mapSearchBarInputEventToState);
  }
  final GetWalletAddressUseCase controller;
  final GetAllLiquidityInfoUseCase repo;

  Future<void> _mapLoadEventToState(
    LoadEvent event,
    Emitter<MyLiquidityState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final walletAddress = controller.getWalletAddress();
    try {
      if (walletAddress != null) {
        final response =
            await repo.fetchAllLiquidityPositions(walletAddress: walletAddress);
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
              ),
            );
          } else {
            emit(state.copyWith(status: BlocStatus.noData));
          }
        } else {
          // TODO(anyone): Create User facing error messages
          emit(state.copyWith(status: BlocStatus.error));
        }
      } else {
        emit(state.copyWith(status: BlocStatus.noWallet));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapSearchBarInputEventToState(
    SearchBarInputEvent event,
    Emitter<MyLiquidityState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final parsedInput = event.searchBarInput.trim().toLowerCase();
    final filteredList = state.cards
        .where(
          (liquidityPosition) =>
              liquidityPosition.token0Name
                  .toLowerCase()
                  .contains(parsedInput) ||
              liquidityPosition.token1Name
                  .toLowerCase()
                  .contains(parsedInput) ||
              liquidityPosition.token0Symbol
                  .toLowerCase()
                  .contains(parsedInput) ||
              liquidityPosition.token1Symbol
                  .toLowerCase()
                  .contains(parsedInput),
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
