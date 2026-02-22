import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/status.dart';
import 'package:ax_dapp/account/view/view.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
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
                        'Portfolio',
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: BlocBuilder<AccountBloc, AccountState>(
                    buildWhen: (previous, current) =>
                        previous.accountViewStatus !=
                        current.accountViewStatus,
                    builder: (BuildContext context, state) {
                      Widget content = const SizedBox.shrink();

                      switch (state.accountViewStatus) {
                        case AccountViewStatus.initial:
                        case AccountViewStatus.details:
                        case AccountViewStatus.none:
                          content = const AccountDetails();
                          break;
                        case AccountViewStatus.buySell:
                          content = const AccountBuyAndSell();
                          break;
                        case AccountViewStatus.deposit:
                          content = const AccountDepositView();
                          break;
                        case AccountViewStatus.withdraw:
                          content = const AccountWithdrawView();
                          break;
                        case AccountViewStatus.wrap:
                          content = const WrapFlowView();
                          break;
                        case AccountViewStatus.token:
                          content = const AccountTokenView();
                          break;
                        case AccountViewStatus.loading:
                        case AccountViewStatus.error:
                          content = const SizedBox.shrink();
                          break;
                      }

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: content,
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

