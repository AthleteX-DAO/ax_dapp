import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'mint_dialog_state.dart';
part 'mint_dialog_event.dart';

class MintDialogBloc extends Bloc<MintDialogEvent, MintDialogState> {
  MintDialogBloc({required this.wallet}) : super(MintDialogState.initial()) {
    on<OnAxAmountChanged>(_mapAxAmountChangedEventToState);
  }
  GetTotalTokenBalanceUseCase wallet;

  Future<void> _mapAxAmountChangedEventToState(
    OnAxAmountChanged event,
    Emitter<MintDialogState> emit,
  ) async {
    try {
      final balnace = await wallet.getTotalAxBalance();
      final axAmount = event.axAmount;
      if (balnace < axAmount) {
        emit(
          state.copyWith(
            status: BlocStatus.error,
            message: Message.insufficientAX,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.initial,
            message: '',
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          message: Message.exception,
        ),
      );
    }
  }
}
