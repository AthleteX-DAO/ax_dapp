import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/apt_sell_info.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sell_dialog_event.dart';
part 'sell_dialog_state.dart';

class SellDialogBloc extends Bloc<SellDialogEvent, SellDialogState> {
  SellDialogBloc({
    required this.repo,
    required this.wallet,
    required this.swapController,
  }) : super(SellDialogState.initial()) {
    on<LoadDialog>(_mapLoadDialogEventToState);
    on<MaxSellTap>(_mapMaxSellTapEventToState);
    on<ConfirmSell>(_mapConfirmSellEventToState);
    on<NewAptInput>(_mapNewAptInputEventToState);
  }
  GetSellInfoUseCase repo;
  GetTotalTokenBalanceUseCase wallet;
  SwapController swapController;

  Future<void> _mapLoadDialogEventToState(
    LoadDialog event,
    Emitter<SellDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final response =
          await repo.fetchAptSellInfo(aptAddress: event.currentTokenAddress);
      final isSuccess = response.isLeft();

      if (isSuccess) {
        swapController
          ..updateFromAddress(event.currentTokenAddress)
          ..updateToAddress(AXT.polygonAddress);
        final swapInfo = response.getLeft().toNullable()!.sellInfo;
        final balance =
            await wallet.getTotalBalanceForToken(event.currentTokenAddress);
        //do some math
        emit(
          state.copyWith(
            balance: balance,
            status: BlocStatus.success,
            tokenAddress: event.currentTokenAddress,
            aptSellInfo: AptSellInfo(
              axPrice: swapInfo.toPrice,
              minimumReceived: swapInfo.minimumReceived,
              priceImpact: swapInfo.priceImpact,
              receiveAmount: swapInfo.receiveAmount,
              totalFee: swapInfo.totalFee,
            ),
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(
          state.copyWith(
            status: BlocStatus.error,
            aptSellInfo: AptSellInfo.empty(),
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          aptSellInfo: AptSellInfo.empty(),
        ),
      );
    }
  }

  Future<void> _mapMaxSellTapEventToState(
    MaxSellTap event,
    Emitter<SellDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final maxInput = await wallet.getTotalBalanceForToken(state.tokenAddress);
      emit(
        state.copyWith(aptInputAmount: maxInput, status: BlocStatus.success),
      );
      add(NewAptInput(aptInputAmount: maxInput));
    } catch (_) {
      // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapConfirmSellEventToState(
    ConfirmSell event,
    Emitter<SellDialogState> emit,
  ) {}

  Future<void> _mapNewAptInputEventToState(
    NewAptInput event,
    Emitter<SellDialogState> emit,
  ) async {
    final aptInputAmount = event.aptInputAmount;
    try {
      final balance = await wallet.getTotalBalanceForToken(state.tokenAddress);
      final response = await repo.fetchAptSellInfo(
        aptAddress: state.tokenAddress,
        aptInput: aptInputAmount,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        if (swapController.amount1.value != aptInputAmount) {
          swapController.updateFromAmount(aptInputAmount);
        }
        final swapInfo = response.getLeft().toNullable()!.sellInfo;
        //do some math
        emit(
          state.copyWith(
            balance: balance,
            status: BlocStatus.success,
            aptSellInfo: AptSellInfo(
              axPrice: swapInfo.toPrice,
              minimumReceived: swapInfo.minimumReceived,
              priceImpact: swapInfo.priceImpact,
              receiveAmount: swapInfo.receiveAmount,
              totalFee: swapInfo.totalFee,
            ),
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(
          state.copyWith(
            status: BlocStatus.error,
            aptSellInfo: AptSellInfo.empty(),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          aptSellInfo: AptSellInfo.empty(),
        ),
      );
    }
  }
}
