import 'package:ax_dapp/markets/modules/sports_markets/repository/sports_markets_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'sports_page_event.dart';
part 'sports_page_state.dart';

class SportsPageBloc extends Bloc<SportsPageEvent, SportsPageState> {
  SportsPageBloc({
    required WalletRepository walletRepository,
    required SportsMarketsRepository sportsMarketsRepository,
  })  : _sportsMarketsRepository = sportsMarketsRepository,
        _walletRepository = walletRepository,
        super(
          const SportsPageState(),
        ) {}

  final WalletRepository _walletRepository;
  final SportsMarketsRepository _sportsMarketsRepository;
}
