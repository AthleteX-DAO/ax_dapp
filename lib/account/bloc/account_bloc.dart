import 'package:ax_dapp/account/models/models.dart';
import 'package:ax_dapp/wallet/view/account.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({
    required TokensRepository tokensRepository,
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        super(
          AccountState(
            chain: walletRepository.currentChain,
            walletAddress: walletRepository.currentWallet.address,
          ),
        ) {
    // Account Views
    on<AccountDetailsViewRequested>(_onAccountDetailsViewRequested);
    on<AccountWithdrawViewRequested>(_onAccountWithdrawViewRequested);
    on<AccountDepositViewRequested>(_onAccountDepositViewRequested);
    on<AccountBuyAndSellViewRequested>(_onAccountBuyAndSellViewRequested);
  }

  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;

  Future<void> _onAccountDetailsViewRequested(
    AccountDetailsViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.details),
    );
  }

  Future<void> _onAccountWithdrawViewRequested(
    AccountWithdrawViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.withdraw),
    );
  }

  Future<void> _onAccountDepositViewRequested(
    AccountDepositViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.deposit),
    );
  }

  Future<void> _onAccountBuyAndSellViewRequested(
    AccountBuyAndSellViewRequested _,
    Emitter<AccountState> emit,
  ) async {
    emit(
      state.copyWith(accountViewStatus: AccountViewStatus.buySell),
    );
  }
}
