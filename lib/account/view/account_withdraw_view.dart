import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountWithdrawView extends StatelessWidget {
  const AccountWithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => context.read<AccountBloc>().add(
                    const AccountDetailsViewRequested(),
                  ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        'Your Withdraw Details',
                        style: textStyle(
                          Colors.grey[600]!,
                          13,
                          isBold: false,
                          isUline: false,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
