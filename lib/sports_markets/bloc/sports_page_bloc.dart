import 'dart:async';

import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/sports_markets/usecases/get_sports_markets_data_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

import 'package:wallet_repository/wallet_repository.dart';

part 'sports_page_event.dart';
part 'sports_page_state.dart';

class SportsPageBloc extends Bloc<SportsPageEvent, SportsPageState> {
  SportsPageBloc({
    required WalletRepository walletRepository,
    required GetSportsMarketsDataUseCase getSportsMarketsDataUseCase,
  })  : _getSportsMarketsDataUseCase = getSportsMarketsDataUseCase,
        _walletRepository = walletRepository,
        super(
          const SportsPageState(),
        ) {
    on<FetchLatestInfo>(_onFetchLatestIntfo);
  }

  final WalletRepository _walletRepository;
  final GetSportsMarketsDataUseCase _getSportsMarketsDataUseCase;

  Future<void> _onFetchLatestIntfo(
    FetchLatestInfo event,
    Emitter<SportsPageState> emit,
  ) async {}
}
