import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/usecases/cross_chain_balance_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AccountTokenView extends StatelessWidget {
  const AccountTokenView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedToken =
        context.select((AccountBloc bloc) => bloc.state.selectedToken);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constriants) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => context.read<AccountBloc>().add(
                        const AccountDetailsViewRequested(),
                      ),
                ),
              ],
            ),
            Container(
              height: 60,
              width: 80,
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    scale: 0.5,
                    image: tokenImage(selectedToken),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                selectedToken.name,
                style: textStyle(
                  Colors.grey[600]!,
                  13,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
            Center(
              child: Text(
                selectedToken.currency.currencyName,
                style: textStyle(
                  Colors.grey[600]!,
                  13,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
            Center(
              child: Text(
                'Token Details',
                style: textStyle(
                  Colors.grey[600]!,
                  13,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: selectedToken.address,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                      Text(
                        selectedToken.address,
                        style: textStyle(
                          Colors.grey[600]!,
                          13,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: FutureBuilder<double>(
                future: context
                    .read<CrossChainBalanceUseCase>()
                    .tokenBalance(selectedToken),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      '0',
                      style: textStyle(
                        Colors.white,
                        16,
                        isBold: false,
                        isUline: false,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data} ${selectedToken.ticker}',
                      style: textStyle(
                        Colors.white,
                        16,
                        isBold: false,
                        isUline: false,
                      ),
                    );
                  } else {
                    return const Loader();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
