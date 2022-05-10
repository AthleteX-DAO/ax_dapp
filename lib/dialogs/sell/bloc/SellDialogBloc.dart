import 'package:ax_dapp/dialogs/buy/models/TransactionInfo.dart';
import 'package:ax_dapp/dialogs/sell/models/SellDailogEvent.dart';
import 'package:ax_dapp/dialogs/sell/models/SellDialogState.dart';
import 'package:ax_dapp/dialogs/sell/usecases/GetAPTSellInfoUseCase.dart';
import 'package:ax_dapp/service/BlockchainModels/AptSellInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double _slippage_tolerance = 0.01;

class SellDialogBloc extends Bloc<SellDialogEvent, SellDialogState> {
  GetAPTSellInfoUseCase repo;
  GetTotalTokenBalanceUseCase wallet;
  SwapController swapController;

  SellDialogBloc(
      {required this.repo,
      required this.wallet,
      required this.swapController})
      : super(const SellDialogState()) {
    on<LoadDialog>(_mapLoadDialogEventToState);
    on<MaxSellTap>(_mapMaxSellTapEventToState);
    on<ConfirmSell>(_mapConfirmBuyEventToState);
    on<NewAptInput>(_mapNewAptInputEventToState);
  }

  get initialState => SellDialogState();

  void _mapLoadDialogEventToState(
      LoadDialog event, Emitter<SellDialogState> emit) async {
    emit(state.copy(status: Status.loading));
    try {
      final response =
          await repo.fetchAptSellInfo(aptAddress: event.currentTokenAddress);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        swapController.updateToAddress(AXT.polygonAddress);
        swapController.updateFromAddress(event.currentTokenAddress);
        final sellInfo = response.getLeft().toNullable()!.aptSellInfo;
        final transactionInfo =
            calculateTransactionInfo(sellInfo, state.aptInputAmount);
        final balance = await wallet.getTotalBalanceForToken(event.currentTokenAddress);
        //do some math
        emit(state.copy(
            balance: balance,
            status: Status.success,
            minimumReceived: transactionInfo.minimumReceived!.toDouble(),
            priceImpact: transactionInfo.priceImpact!.toDouble(),
            receiveAmount: transactionInfo.receiveAmount!.toDouble(),
            tokenAddress: event.currentTokenAddress,
            totalFee: transactionInfo.totalFee!.toDouble(),
            price: transactionInfo.price!.toDouble()));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copy(status: Status.error));
      }
    } catch (e) {
      emit(state.copy(status: Status.error));
    }
  }

  TransactionInfo calculateTransactionInfo(
      AptSellInfo? sellInfo, double inputAmount) {
    final aptLiquidity = sellInfo!.aptLiquidity;
    final axLiquidity = sellInfo.axLiquidity;
    final price = sellInfo.axPrice;
    final aptInputAmount = inputAmount;
    final lpFee = aptInputAmount * 0.0025;
    final protocolFee = aptInputAmount * 0.0005;
    final totalFees = lpFee + protocolFee;
    final aptInputNoFees = aptInputAmount - totalFees;
    final receiveAmount =
        (aptInputNoFees) * (axLiquidity / (aptLiquidity + aptInputNoFees));
    final priceImpact = 100 *
        (1 -
            ((aptLiquidity * (axLiquidity - receiveAmount)) /
                (axLiquidity * (aptLiquidity + aptInputNoFees))));
    final minimumReceiveAmt = receiveAmount * (1 - _slippage_tolerance);
    return TransactionInfo(
        minimumReceiveAmt, priceImpact, receiveAmount, totalFees, price);
  }

  void _mapMaxSellTapEventToState(
      MaxSellTap event, Emitter<SellDialogState> emit) async {
    emit(state.copy(status: Status.loading));
    try {
      final maxInput = await wallet.getTotalAxBalance();
      emit(state.copy(
          aptInputValue: maxInput, status: Status.success));
      add(NewAptInput(aptInputAmount: maxInput));
    } catch (e) {
      //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      print(e);
      emit(state.copy(status: Status.error));
    }
  }

  void _mapConfirmBuyEventToState(
      ConfirmSell event, Emitter<SellDialogState> emit) {}

  void _mapNewAptInputEventToState(
      NewAptInput event, Emitter<SellDialogState> emit) async {
    final aptInputAmount = event.aptInputAmount;
    print(" New Apt Input: $aptInputAmount");
    try {
      final response =
          await repo.fetchAptSellInfo(aptAddress: state.tokenAddress!);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        print(" New Apt Input: Success");
        if (swapController.amount1.value != aptInputAmount) {
          swapController.updateFromAmount(aptInputAmount);
        }
        final sellInfo = response.getLeft().toNullable()!.aptSellInfo;
        final transactionInfo =
            calculateTransactionInfo(sellInfo, aptInputAmount);
        print("minReceived: ${transactionInfo.minimumReceived!.toDouble()}");
        print("priceImpact: ${transactionInfo.priceImpact!.toDouble()}");
        print("receiveAmount: ${transactionInfo.receiveAmount!.toDouble()}");
        print("totaFees: ${transactionInfo.totalFee!.toDouble()}");
        //do some math
        emit(state.copy(
            status: Status.success,
            minimumReceived: transactionInfo.minimumReceived!.toDouble(),
            priceImpact: transactionInfo.priceImpact!.toDouble(),
            receiveAmount: transactionInfo.receiveAmount!.toDouble(),
            totalFee: transactionInfo.totalFee!.toDouble(),
            price: transactionInfo.price!.toDouble()));
      } else {
        print(" New Apt Input: Failure");
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
