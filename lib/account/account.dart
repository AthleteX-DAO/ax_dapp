import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/status.dart';
import 'package:ax_dapp/account/view/view.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var wid = 400.0;
    const edge = 40.0;
    if (_width < 405) wid = _width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight * 0.85,
          width: constraints.maxWidth * 0.9,
          decoration:
              boxDecoration(Colors.transparent, 30, 0, Colors.transparent),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: constraints.maxWidth < 665
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.zero,
                  width: wid - edge,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Account Balances',
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: constraints.maxWidth < 665
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.zero,
                  width: constraints.maxWidth - edge,
                  height: constraints.maxHeight * 0.8,
                  decoration: boxDecoration(
                    Colors.transparent,
                    14,
                    .5,
                    primaryOrangeColor,
                  ),
                  child: BlocBuilder<AccountBloc, AccountState>(
                    builder: (BuildContext context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (state.accountViewStatus ==
                                  AccountViewStatus.initial ||
                              state.accountViewStatus ==
                                  AccountViewStatus.details ||
                              state.accountViewStatus == AccountViewStatus.none)
                            SizedBox(
                              height: constraints.maxHeight * 0.6,
                              child: const AccountDetails(),
                            ),
                          if (state.accountViewStatus ==
                              AccountViewStatus.buySell)
                            SizedBox(
                              height: constraints.maxHeight * 0.7,
                              child: const AccountBuyAndSell(),
                            ),
                          if (state.accountViewStatus ==
                              AccountViewStatus.deposit)
                            const AccountDepositView(),
                          if (state.accountViewStatus ==
                              AccountViewStatus.withdraw)
                            const AccountWithdrawView(),
                          if (state.accountViewStatus ==
                              AccountViewStatus.token)
                            const AccountTokenView(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
