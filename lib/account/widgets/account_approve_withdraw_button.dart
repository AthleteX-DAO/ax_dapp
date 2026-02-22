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
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: Colors.amber[400]!),
                ),
              ),
              minimumSize: WidgetStateProperty.all(
                const Size(
                  50,
                  35,
                ),
              ),
            ),
            onPressed: () {
              final state = context.read<AccountBloc>().state;
              final recipientAddress = state.recipentAddress.trim();
              final amount = state.tokenAmountInput;
              final isValidAddress = recipientAddress.isNotEmpty && 
                  (recipientAddress.startsWith('0x') && recipientAddress.length == 42);
              
              if (!isValidAddress) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid Ethereum address'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter an amount greater than 0'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              
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
