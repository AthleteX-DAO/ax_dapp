import 'package:ax_dapp/util/text_field_input_decoration.dart';
import 'package:flutter/material.dart';

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
      onChanged: (value) {},
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter Receiving Address',
        labelText: 'Recipent Address',
      ),
    );
  }
}
