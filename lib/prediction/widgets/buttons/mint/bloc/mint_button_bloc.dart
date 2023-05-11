import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'mint_button_event.dart';
part 'mint_button_state.dart';

class MintButtonBloc extends Bloc<MintButtonEvent, MintButtonState> {
  MintButtonBloc() : super(const MintButtonState()) {
    on<MintButtonPressed>(_onMintButtonPressed);
  }

  // final EventMarketRepository _eventMarketRepository;

  Future<void> _onMintButtonPressed(
    MintButtonPressed event,
    Emitter<MintButtonState> emit,
  ) async {
    try {
      print('Mint Button IS PRESSED');
    } catch (e) {
      // await _eventMarketRepository.mint();
    }
  }
}
