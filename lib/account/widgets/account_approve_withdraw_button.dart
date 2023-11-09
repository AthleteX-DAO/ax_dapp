import 'package:flutter/material.dart';

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
            //TODO(anyone): Complete the logic to handle account withdraw
            onPressed: () {},
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
