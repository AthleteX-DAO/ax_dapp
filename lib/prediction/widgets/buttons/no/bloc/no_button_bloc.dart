import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'no_button_event.dart';
part 'no_button_state.dart';

class NoButtonBloc extends Bloc<NoButtonEvent, NoButtonState> {
  NoButtonBloc({
    required this.repo,
    required this.eventMarketRepository,
  }) : super(const NoButtonState()) {
    on<NoButtonPressed>(_onNoButtonPressed);
  }

  final GetBuyInfoUseCase repo;
  final EventMarketRepository eventMarketRepository;

  Future<void> _onNoButtonPressed(
    NoButtonPressed event,
    Emitter<NoButtonState> emit,
  ) async {
    try {
      print('No Button IS PRESSED');
      eventMarketRepository.address1.value = event.shortTokenAddress;
      eventMarketRepository.address2.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      await eventMarketRepository.sell();
    } catch (e) {
      // await _eventMarketRepository.No();
    }
  }

  Future<void> _onFetchBuyInfoRequested(
    NoButtonPressed event,
    Emitter<NoButtonState> emit,
  ) async {
    final aptAddress = event.shortTokenAddress;
    final response = await repo.fetchAptBuyInfo(aptAddress: aptAddress);

    final pairInfo = response.getLeft().toNullable()!.aptBuyInfo;
  }
}
