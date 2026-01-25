import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/util/text_field_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRecipentAddressInput extends StatefulWidget {
  const AccountRecipentAddressInput({super.key});

  @override
  State<AccountRecipentAddressInput> createState() =>
      _AccountRecipentAddressInputState();
}

class _AccountRecipentAddressInputState
    extends State<AccountRecipentAddressInput> {
  final TextEditingController recipentAddressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: recipentAddressController,
      textAlign: TextAlign.center,
      onChanged: (value) {
        context.read<AccountBloc>().add(
              UpdateRecipentAddressRequested(
                recipentAddress: value.trim(),
              ),
            );
      },
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter Receiving Address (0x...)',
        labelText: 'Recipient Address',
        helperText: 'Ethereum address (42 characters)',
      ),
    );
  }

  @override
  void dispose() {
    recipentAddressController.dispose();
    super.dispose();
  }
}
