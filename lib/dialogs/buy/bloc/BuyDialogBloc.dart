import 'package:ax_dapp/dialogs/buy/models/BuyDialogEvent.dart';
import 'package:ax_dapp/dialogs/buy/models/BuyDialogState.dart';
import 'package:ax_dapp/dialogs/buy/models/TransactionInfo.dart';
import 'package:ax_dapp/dialogs/buy/usecases/GetAPTBuyInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptBuyInfo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _slippage_tolerance = 0.01;
class BuyDialogBloc extends Bloc<BuyDialogEvent, BuyDialogState> {
  GetAPTBuyInfoUseCase repo;

  BuyDialogBloc({required this.repo}) : super(const BuyDialogState()) {
    on<OnLoadDialog>(_mapLoadDialogEventToState);
    on<OnMaxBuyTap>(_mapMaxBuyTapEventToState);
    on<OnConfirmBuy>(_mapConfirmBuyEventToState);
    on<OnNewAptInput>(_mapNewAptInputEventToState);
  }

  get initialState => BuyDialogState();

  void _mapLoadDialogEventToState(
      OnLoadDialog event, Emitter<BuyDialogState> emit) async {
    emit(state.copy(status: Status.loading));
    try {
      final response = await repo.fetchAptBuyInfo(event.initialTokenAddress);
      final isSuccess = response.isLeft();

      if(isSuccess){
        final buyInfo = response.getLeft().toNullable()!.aptBuyInfo;
        final transactionInfo = calculateTransactionInfo(buyInfo, state.aptInputAmount);
        //do some math
        emit(state.copy(
            status: Status.success,
            minimumReceived: transactionInfo.minimumReceived!.toDouble(),
            priceImpact: transactionInfo.priceImpact!.toDouble(),
            receiveAmount: transactionInfo.receiveAmount!.toDouble(),
            tokenAddress: event.initialTokenAddress));
      }else{
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: Status.error));
      }
    } catch (e) {
      emit(state.copy(status: Status.error));
    }
  }

  TransactionInfo calculateTransactionInfo(AptBuyInfo? buyInfo, double inputAmount) {
    final aptLiquidity = buyInfo!.aptLiquidity;
    final axLiquidity = buyInfo.axLiquidity;
    final axInputAmount = inputAmount;
    final receiveAmount = axInputAmount * (aptLiquidity / (axLiquidity + axInputAmount));

    final priceImpact = 100 * (1 - ((axLiquidity * (aptLiquidity - receiveAmount)) / (aptLiquidity * (axLiquidity + axInputAmount))));

    final minimumReceiveAmt = receiveAmount * (1 - _slippage_tolerance);
    return TransactionInfo(
        minimumReceiveAmt, priceImpact, receiveAmount);
  }

  void _mapMaxBuyTapEventToState(
      OnMaxBuyTap event, Emitter<BuyDialogState> emit) {}

  void _mapConfirmBuyEventToState(
      OnConfirmBuy event, Emitter<BuyDialogState> emit) {}

  void _mapNewAptInputEventToState(
      OnNewAptInput event, Emitter<BuyDialogState> emit) async {
    print("On New Apt Input: ${event.aptInputAmount}");
    try {
      final response = await repo.fetchAptBuyInfo(state.tokenAddress!);
      final isSuccess = response.isLeft();

      if(isSuccess){
        print("On New Apt Input: Success");

        final buyInfo = response.getLeft().toNullable()!.aptBuyInfo;
        final transactionInfo = calculateTransactionInfo(buyInfo, event.aptInputAmount);
        print("minReceived: ${transactionInfo.minimumReceived!.toDouble()}");
        print("priceImpact: ${transactionInfo.priceImpact!.toDouble()}");
        print("receiveAmount: ${transactionInfo.receiveAmount!.toDouble()}");
        //do some math
        emit(state.copy(
            status: Status.success,
            minimumReceived: transactionInfo.minimumReceived!.toDouble(),
            priceImpact: transactionInfo.priceImpact!.toDouble(),
            receiveAmount: transactionInfo.receiveAmount!.toDouble()));
      }else{
        print("On New Apt Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: Status.error));
      }
    } catch (e) {
      emit(state.copy(status: Status.error));
    }

  }
}
