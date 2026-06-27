import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/dialogs/delegate_collateral_dialog.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class AccountAssetCard extends StatelessWidget {
  const AccountAssetCard({
    super.key,
    required this.token,
  });

  final Token token;

  @override
  Widget build(BuildContext context) {
    final walletState = context.watch<WalletBloc>().state;
    final accountState = context.watch<AccountBloc>().state;
    final isConnected = walletState.walletAddress.isNotEmpty &&
        walletState.walletAddress != kEmptyAddress;

    // Check ticker to determine the balance.
    final double? balanceValue;
    if (!isConnected) {
      balanceValue = null;
    } else if (token.ticker == 'AX') {
      balanceValue = accountState.serverAxBalance;
    } else if (token.ticker == 'Matic') {
      balanceValue = accountState.serverMaticBalance;
    } else if (token.ticker == 'USDC') {
      balanceValue = accountState.serverUsdcBalance;
    } else {
      balanceValue = null; // Fetch on-chain balance asynchronously for other tokens (SX, WETH)
    }

    if (isConnected && balanceValue == null) {
      return FutureBuilder<double?>(
        future: context.read<WalletRepository>().getTokenBalance(token.address),
        builder: (context, snapshot) {
          final balance = snapshot.data ?? 0.0;
          return _buildCard(context, balance, isConnected);
        },
      );
    } else {
      return _buildCard(context, balanceValue ?? 0.0, isConnected);
    }
  }

  Widget _buildCard(BuildContext context, double balance, bool isConnected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: InkWell(
        onTap: () {
          context
              .read<AccountBloc>()
              .add(AccountTokenViewRequested(token: token));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: <Widget>[
              // Token Image
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: tokenImage(token),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Ticker and Name
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.ticker,
                      style: textStyle(
                        Colors.white,
                        13,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      token.name,
                      style: textStyle(
                        Colors.grey[400]!,
                        9,
                        isBold: false,
                        isUline: false,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Balance
              if (isConnected)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        balance.toStringAsFixed(4),
                        style: textStyle(
                          Colors.white,
                          13,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Balance',
                        style: textStyle(
                          Colors.white54,
                          9,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              // Delegation Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                    color: Colors.greenAccent,
                    tooltip: 'Delegate',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<AccountBloc>(),
                          child: DelegateCollateralDialog(
                            token: token,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward_rounded, size: 18),
                    color: Colors.redAccent,
                    tooltip: 'Undelegate',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<AccountBloc>(),
                          child: DelegateCollateralDialog(
                            token: token,
                            initialMode: DelegationMode.undelegate,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
