import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountWithdrawView extends StatelessWidget {
  const AccountWithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    const edge = 40;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () => context.read<AccountBloc>().add(
                          const AccountDetailsViewRequested(),
                        ),
                  ),
                  Text(
                    'Select a Token',
                    style: textStyle(
                      Colors.white,
                      16,
                      isBold: true,
                      isUline: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: constraints.maxWidth - edge,
              child: const Divider(
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
