import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FromAmountBox extends StatelessWidget {
  const FromAmountBox({
    super.key,
    required this.amountBoxAndMaxButtonWid,
    required TextEditingController tokenFromInputController,
    required this.bloc,
    required this.addEventForFromInputValue,
  }) : _tokenFromInputController = tokenFromInputController;

  final double amountBoxAndMaxButtonWid;
  final TextEditingController _tokenFromInputController;
  final TradePageBloc bloc;
  final void Function(String, TradePageBloc) addEventForFromInputValue;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: amountBoxAndMaxButtonWid),
      child: IntrinsicWidth(
        child: TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _tokenFromInputController,
          onChanged: (value) => addEventForFromInputValue(value, bloc),
          style: TextStyle(color: Colors.grey[400], fontSize: 22),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 22),
            contentPadding: const EdgeInsets.all(9),
            border: InputBorder.none,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^(\d+)?\.?\d{0,6}'),
            ),
          ],
        ),
      ),
    );
  }
}
