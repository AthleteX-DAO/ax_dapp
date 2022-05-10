import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:equatable/equatable.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'package:ax_dapp/dialogs/buy/models/BuyDialogEvent.dart';
part 'package:ax_dapp/dialogs/buy/models/BuyDialogState.dart';

class BuyDialogBloc extends Bloc<BuyDialogEvent, BuyDialogState> {
  GetAPTBuyInfoUseCase repo;
  GetTotalTokenBalanceUseCase wallet;
  SwapController swapController;

  BuyDialogBloc(
      {required this.repo, required this.wallet, required this.swapController})
      : super(BuyDialogState.initial()) {
    on<OnLoadDialog>(_mapLoadDialogEventToState);
    on<OnMaxBuyTap>(_mapMaxBuyTapEventToState);
    on<OnConfirmBuy>(_mapConfirmBuyEventToState);
    on<OnNewAxInput>(_mapNewAxInputEventToState);
  }

  void _mapLoadDialogEventToState(
      OnLoadDialog event, Emitter<BuyDialogState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final response =
          await repo.fetchAptBuyInfo(aptAddress: event.currentTokenAddress);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        swapController.updateFromAddress(AXT.polygonAddress);
        swapController.updateToAddress(event.currentTokenAddress);
        final buyInfo = response.getLeft().toNullable()!.aptBuyInfo;
        final balance = await wallet.getTotalAxBalance();
        //do some math
        emit(state.copyWith(
            balance: balance,
            status: BlocStatus.success,
            tokenAddress: event.currentTokenAddress,
            aptBuyInfo: buyInfo));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.error, aptBuyInfo: AptBuyInfo.empty()));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, aptBuyInfo: AptBuyInfo.empty()));
    }
  }

  void _mapMaxBuyTapEventToState(
      OnMaxBuyTap event, Emitter<BuyDialogState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final maxInput = await wallet.getTotalAxBalance();
      emit(state.copyWith(axInputAmount: maxInput, status: BlocStatus.success));
      add(OnNewAxInput(axInputAmount: maxInput));
    } catch (e) {
      //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      print(e);
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapConfirmBuyEventToState(
      OnConfirmBuy event, Emitter<BuyDialogState> emit) {}

  void _mapNewAxInputEventToState(
      OnNewAxInput event, Emitter<BuyDialogState> emit) async {
    final axInputAmount = event.axInputAmount;
    final balance = await wallet.getTotalAxBalance();
    print("On New Apt Input: $axInputAmount");
    try {
      final response =
          await repo.fetchAptBuyInfo(aptAddress: state.tokenAddress, axInput: axInputAmount);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        print("On New Apt Input: Success");
        if (swapController.amount1.value != axInputAmount) {
          swapController.updateFromAmount(axInputAmount);
        }
        final buyInfo = response.getLeft().toNullable()!.aptBuyInfo;
        //do some math
        emit(state.copyWith(
            status: BlocStatus.success,
            aptBuyInfo: buyInfo));
      } else {
        print("On New Apt Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.error, aptBuyInfo: AptBuyInfo.empty()));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, aptBuyInfo: AptBuyInfo.empty()));
    }
  }
}
