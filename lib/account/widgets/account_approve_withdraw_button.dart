import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountApproveWithdrawButton extends StatelessWidget {
  const AccountApproveWithdrawButton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.5,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: Colors.amber[400]!),
                ),
              ),
              minimumSize: MaterialStateProperty.all(
                const Size(
                  50,
                  35,
                ),
              ),
            ),
            onPressed: () {
              context.read<AccountBloc>().add(const AccountWithdrawConfirm());
            },
            child: const Text(
              'Approve Withdraw',
              style: TextStyle(
                color: Colors.amber,
                fontFamily: 'OpenSans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
