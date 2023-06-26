import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/apt_buy_info.dart';
import 'package:ax_dapp/service/blockchain_models/apt_sell_info.dart';
import 'package:ax_dapp/service/blockchain_models/swap_info.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

part 'yes_button_event.dart';
part 'yes_button_state.dart';

class YesButtonBloc extends Bloc<YesButtonEvent, YesButtonState> {
  YesButtonBloc({
    required this.repo,
    required this.eventMarketRepository,
  }) : super(const YesButtonState()) {
    on<YesButtonPressed>(_onYesButtonPressed);
    on<FetchSwapInfoRequested>(_onFetchSwapInfoRequested);
    on<BuyButtonPressed>(_onBuyButtonPressed);
    on<SellButtonPressed>(_onSellButtonPressed);
  }

  final GetSwapInfoUseCase repo;
  final EventMarketRepository eventMarketRepository;

  Future<void> _onYesButtonPressed(
    YesButtonPressed event,
    Emitter<YesButtonState> emit,
  ) async {
    try {
      eventMarketRepository.address1.value = event.longTokenAddress;
      eventMarketRepository.address2.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      await eventMarketRepository.buy();
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onFetchSwapInfoRequested(
    FetchSwapInfoRequested event,
    Emitter<YesButtonState> emit,
  ) async {
    final response = await repo.fetchSwapInfo(
      tokenFrom: event.longTokenAddress,
      tokenTo: event.longTokenAddress,
    );
    final pairInfo = response.getLeft().toNullable()!.swapInfo;
    emit(
      state.copyWith(
        swapInfo: SwapInfo(
          toPrice: pairInfo.toPrice,
          minimumReceived: pairInfo.minimumReceived,
          priceImpact: pairInfo.priceImpact,
          receiveAmount: pairInfo.receiveAmount,
          totalFee: pairInfo.totalFee,
        ),
      ),
    );
  }

  Future<void> _onBuyButtonPressed(
    BuyButtonPressed event,
    Emitter<YesButtonState> emit,
  ) async {
    try {
      eventMarketRepository.address1.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      eventMarketRepository.address2.value = event.longTokenAddress;
      eventMarketRepository.amount1.value = 1 * 1e18;
      const contractAddress = '0x4C2295082FC932EDE19EefB1af03c0b6B323610A';
      const amount = 100.0;
      await eventMarketRepository
          .approve(contractAddress, amount)
          .then((value) => {eventMarketRepository.buy()});
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onSellButtonPressed(
    SellButtonPressed event,
    Emitter<YesButtonState> emit,
  ) async {
    try {
      eventMarketRepository.address1.value = event.longTokenAddress;
      eventMarketRepository.address2.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      eventMarketRepository.amount1.value = 1 * 1e18;
      const contractAddress = '0x4C2295082FC932EDE19EefB1af03c0b6B323610A';
      const amount = 100.0;
      await eventMarketRepository
          .approve(contractAddress, amount)
          .then((value) => {eventMarketRepository.sell()});
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
