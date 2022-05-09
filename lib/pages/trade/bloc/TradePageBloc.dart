import 'package:ax_dapp/dialogs/buy/models/TransactionInfo.dart';
import 'package:ax_dapp/dialogs/buy/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/pages/trade/models/TradePageEvent.dart';
import 'package:ax_dapp/pages/trade/models/TradePageState.dart';
import 'package:ax_dapp/service/BlockchainModels/SwapInfo.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradePageBloc extends Bloc<TradePageEvent, TradePageState> {
  GetSwapInfoUseCase repo;
  SwapController swapController;
  WalletController walletController;
  static const double _slippage_tolerance = 0.01;

  TradePageBloc(
      {required this.repo,
      required this.swapController,
      required this.walletController})
      : super(const TradePageState()) {
    on<PageRefreshEvent>(_mapRefreshEventToState);
    on<MaxSwapTapEvent>(_mapMaxSwapTapEventToState);
    on<NewTokenFromInputEvent>(_mapNewTokenFromInputEventToState);
    on<NewTokenToInputEvent>(_mapNewTokenToInputEventToState);
    on<SetTokenFrom>(_mapSetTokenFromEventToState);
    on<SetTokenTo>(_mapSetTokenToEventToState);
    on<SwapTokens>(_mapSwapTokensEventToState);
  }

  get initialState => TradePageState();

  void _mapRefreshEventToState(
      PageRefreshEvent event, Emitter<TradePageState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final tokenFromBalance = await walletController
          .getTokenBalance(state.tokenFrom!.address.value);
      final tokenToBalance =
          await walletController.getTokenBalance(state.tokenTo!.address.value);
      emit(state.copyWith(
          tokenFromBalance: double.parse(tokenFromBalance),
          tokenToBalance: double.parse(tokenToBalance)));
      final response = await repo.fetchSwapInfo(
          tokenFrom: state.tokenFrom!.address.value,
          tokenTo: state.tokenTo!.address.value);
      final isSuccess = response.isLeft();
      print("isSuccess - $isSuccess");
      if (isSuccess) {
        swapController.updateFromAddress(state.tokenFrom!.address.value);
        swapController.updateToAddress(state.tokenTo!.address.value);
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        final transactionInfo =
            calculateTransactionInfo(swapInfo, state.tokenInputFromAmount);

        //do some math
        emit(state.copyWith(
          status: Status.success,
          minimumReceived: transactionInfo.minimumReceived!.toDouble(),
          priceImpact: transactionInfo.priceImpact!.toDouble(),
          receiveAmount: transactionInfo.receiveAmount!.toDouble(),
          price: transactionInfo.price!.toDouble(),
          totalFees: transactionInfo.totalFee!.toDouble(),
        ));
      } else {
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(
          status: Status.error,
          minimumReceived: 0,
          priceImpact: 0,
          receiveAmount: 0,
          price: 0,
          totalFees: 0,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: Status.error));
    }
  }

  TransactionInfo calculateTransactionInfo(
      SwapInfo? swapInfo, double inputAmount) {
    final toReserve = swapInfo!.toReserve;
    final fromReserve = swapInfo.fromReserve;
    final fromInputAmount = inputAmount;
    final price = swapInfo.toPrice;
    final lpFee = fromInputAmount * 0.0025;
    final protocolFee = fromInputAmount * 0.0005;
    final totalFees = lpFee + protocolFee;
    final receiveAmount = (fromInputAmount - totalFees) *
        (toReserve / (fromReserve + fromInputAmount - totalFees));
    final priceImpact = 100 *
        (1 -
            ((fromReserve * (toReserve - receiveAmount)) /
                (toReserve * (fromReserve + fromInputAmount - totalFees))));

    final minimumReceiveAmt = receiveAmount * (1 - _slippage_tolerance);
    return TransactionInfo(
        minimumReceiveAmt, priceImpact, receiveAmount, totalFees, price);
  }

  void _mapNewTokenFromInputEventToState(
      NewTokenFromInputEvent event, Emitter<TradePageState> emit) async {
    final tokenInputFromAmount = event.tokenInputFromAmount;
    print("On New Apt Input: $tokenInputFromAmount");
    try {
      final response = await repo.fetchSwapInfo(
          tokenFrom: state.tokenFrom!.address.value,
          tokenTo: state.tokenTo!.address.value);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        print("On New Apt Input: Success");
        if (swapController.amount1.value != tokenInputFromAmount) {
          swapController.updateFromAmount(tokenInputFromAmount);
        }
        final swapInfo = response.getLeft().toNullable()!.swapInfo;
        final transactionInfo =
            calculateTransactionInfo(swapInfo, tokenInputFromAmount);

        print("minReceived: ${transactionInfo.minimumReceived!.toDouble()}");
        print("priceImpact: ${transactionInfo.priceImpact!.toDouble()}");
        print("receiveAmount: ${transactionInfo.receiveAmount!.toDouble()}");
        //do some math
        emit(state.copyWith(
            status: Status.success,
            minimumReceived: transactionInfo.minimumReceived!.toDouble(),
            priceImpact: transactionInfo.priceImpact!.toDouble(),
            receiveAmount: transactionInfo.receiveAmount!.toDouble(),
            price: transactionInfo.price!.toDouble(),
            totalFees: transactionInfo.totalFee!.toDouble()));
      } else {
        print("On New Apt Input: Failure");
        final errorMsg = response.getRight().toNullable()!.errorMsg;
        //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        print(errorMsg);
        emit(state.copyWith(status: Status.error));
      }
    } catch (e) {
      emit(state.copyWith(status: Status.error));
    }
  }

  void _mapNewTokenToInputEventToState(
      NewTokenToInputEvent event, Emitter<TradePageState> emit) async {}

  void _mapMaxSwapTapEventToState(
      MaxSwapTapEvent event, Emitter<TradePageState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final tokenFromBalance = await walletController
          .getTokenBalance(state.tokenFrom!.address.value);
      final maxInput = double.parse(tokenFromBalance);
      emit(state.copyWith(
          tokenInputFromAmount: maxInput, tokenFromBalance: maxInput));
    } catch (e) {
      //TODO Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      print(e);
      emit(state.copyWith(status: Status.error));
    }
  }

  void _mapSetTokenFromEventToState(
      SetTokenFrom event, Emitter<TradePageState> emit) {
    print("Updating tokenFrom: ${event.tokenFrom.address.value}");
    swapController.updateFromAddress(event.tokenFrom.address.value);
    emit(state.copyWith(tokenFrom: event.tokenFrom));
  }

  void _mapSetTokenToEventToState(
      SetTokenTo event, Emitter<TradePageState> emit) {
    swapController.updateToAddress(event.tokenTo.address.value);
    emit(state.copyWith(tokenTo: event.tokenTo));
  }

  void _mapSwapTokensEventToState(
      SwapTokens event, Emitter<TradePageState> emit) {
    final Token? tokenFrom = state.tokenTo;
    final Token? tokenTo = state.tokenFrom;
    final tokenInputFromAmount = state.tokenInputToAmount;
    final tokenInputToAmount = state.tokenInputFromAmount;
    emit(state.copyWith(
        tokenFrom: tokenFrom,
        tokenTo: tokenTo,
        tokenInputFromAmount: tokenInputFromAmount,
        tokenInputToAmount: tokenInputToAmount));
  }
}
