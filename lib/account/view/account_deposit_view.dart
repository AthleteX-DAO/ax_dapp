import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDepositView extends StatelessWidget {
  const AccountDepositView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 45,
              child: Row(
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
          ],
        );
      },
    );
  }
}
