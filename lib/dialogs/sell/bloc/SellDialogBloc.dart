import 'package:ax_dapp/repositories/subgraph/usecases/GetSellInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptSellInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'package:ax_dapp/dialogs/sell/models/SellDailogEvent.dart';
part 'package:ax_dapp/dialogs/sell/models/SellDialogState.dart';

class SellDialogBloc extends Bloc<SellDialogEvent, SellDialogState> {
  GetSellInfoUseCase repo;
  GetTotalTokenBalanceUseCase wallet;
  SwapController swapController;

  SellDialogBloc(
      {required this.repo,
      required this.wallet,
      required this.swapController})
      : super(SellDialogState.initial()) {
    on<LoadDialog>(_mapLoadDialogEventToState);
    on<MaxSellTap>(_mapMaxSellTapEventToState);
    on<ConfirmSell>(_mapConfirmSellEventToState);
    on<NewAptInput>(_mapNewAptInputEventToState);
  }

  void _mapLoadDialogEventToState(
      LoadDialog event, Emitter<SellDialogState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final response =
          await repo.fetchAptSellInfo(aptAddress: event.currentTokenAddress);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        swapController.updateFromAddress(event.currentTokenAddress);
        swapController.updateToAddress(AXT.polygonAddress);
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        final balance = await wallet.getTotalBalanceForToken(event.currentTokenAddress);
        //do some math
        emit(state.copyWith(
            balance: balance,
            status: BlocStatus.success,
            tokenAddress: event.currentTokenAddress,
            aptSellInfo: AptSellInfo(
                axPrice: swapInfo.toPrice,
                minimumReceived: swapInfo.minimumReceived,
                priceImpact: swapInfo.priceImpact,
                receiveAmount: swapInfo.receiveAmount,
                totalFee: swapInfo.totalFee)));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.error, aptSellInfo: AptSellInfo.empty()));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, aptSellInfo: AptSellInfo.empty()));
    }
  }

  void _mapMaxSellTapEventToState(
      MaxSellTap event, Emitter<SellDialogState> emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final maxInput = await wallet.getTotalBalanceForToken(state.tokenAddress);
      emit(state.copyWith(aptInputAmount: maxInput, status: BlocStatus.success));
      add(NewAptInput(aptInputAmount: maxInput));
    } catch (e) {
      //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      print(e);
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapConfirmSellEventToState(
      ConfirmSell event, Emitter<SellDialogState> emit) {}

  void _mapNewAptInputEventToState(
      NewAptInput event, Emitter<SellDialogState> emit) async {
    final aptInputAmount = event.aptInputAmount;
    print(" New Apt Input: $aptInputAmount");
    try {
      final balance = await wallet.getTotalBalanceForToken(state.tokenAddress);
      final response =
          await repo.fetchAptSellInfo(aptAddress: state.tokenAddress, aptInput: aptInputAmount);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        print(" New Apt Input: Success");
        if (swapController.amount1.value != aptInputAmount) {
          swapController.updateFromAmount(aptInputAmount);
        }
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        //do some math
        emit(state.copyWith(
            balance: balance, 
            status: BlocStatus.success,
            aptSellInfo: AptSellInfo(
                axPrice: swapInfo.toPrice,
                minimumReceived: swapInfo.minimumReceived,
                priceImpact: swapInfo.priceImpact,
                receiveAmount: swapInfo.receiveAmount,
                totalFee: swapInfo.totalFee)));
      } else {
        print(" New Apt Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: BlocStatus.error, aptSellInfo: AptSellInfo.empty()));
      }
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, aptSellInfo: AptSellInfo.empty()));
    }
  }
}
