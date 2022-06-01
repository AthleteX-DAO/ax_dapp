import 'package:ax_dapp/pages/pool/MyLiqudity/models/MyLiquidityItemInfo.dart';
import 'package:ax_dapp/repositories/usecases/GetAllLiquidityInfoUseCase.dart';
import 'package:ax_dapp/service/Controller/usecases/GetWalletAddressUseCase.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'MyLiquidityEvent.dart';
part 'MyLiquidityState.dart';

class MyLiquidityBloc extends Bloc<MyLiquidityEvent, MyLiquidityState> {
  final GetWalletAddressUseCase controller;
  final GetAllLiquidityInfoUseCase repo;

  MyLiquidityBloc({required this.repo, required this.controller})
      : super(MyLiquidityState.initial()) {
    on<LoadEvent>(_mapLoadEventToState);
    on<SearchBarInputEvent>(_mapSearchBarInputEventToState);
  }

  Future<void> _mapLoadEventToState(
      LoadEvent event, Emitter<MyLiquidityState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final String? walletAddress = controller.getWalletAddress();
    try {
      if (walletAddress != null) {
        final response =
            await repo.fetchAllLiquidityPositions(walletAddress: walletAddress);
        final isSuccess = response.isLeft();
        if (isSuccess) {
          final liquidityPositionsList =
              response.getLeft().toNullable()!.liquidityPositionsList;
          if (liquidityPositionsList != null) {
            emit(state.copyWith(
                cards: liquidityPositionsList,
                filteredCards: liquidityPositionsList,
                status: BlocStatus.success));
          } else {
            emit(state.copyWith(status: BlocStatus.no_data));
          }
        } else {
          final errorMsg = response.getRight().toNullable()!.errorMsg;
          //TODO Create User facing error messages
          print(errorMsg);
          emit(state.copyWith(status: BlocStatus.error));
        }
      } else {
        emit(state.copyWith(status: BlocStatus.no_wallet));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapSearchBarInputEventToState(
      SearchBarInputEvent event, Emitter<MyLiquidityState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    String parsedInput = event.searchBarInput.trim().toLowerCase();
    final List<LiquidityPositionInfo> filteredList = state.cards
        .where((liquidityPosition) =>
            liquidityPosition.token0Name.toLowerCase().contains(parsedInput) ||
            liquidityPosition.token1Name.toLowerCase().contains(parsedInput) ||
            liquidityPosition.token0Symbol
                .toLowerCase()
                .contains(parsedInput) ||
            liquidityPosition.token1Symbol.toLowerCase().contains(parsedInput))
        .toList();
    emit(state.copyWith(
      status: BlocStatus.success,
      filteredCards: filteredList,
    ));
  }
}
