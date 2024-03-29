import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class Price extends StatelessWidget {
  const Price({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Price:',
          style: textStyle(
            Colors.white,
            15,
            isBold: false,
            isUline: false,
          ),
        ),
        BlocBuilder<SellDialogBloc, SellDialogState>(
          buildWhen: (previous, current) =>
              previous.aptTypeSelection != current.aptTypeSelection ||
              previous.aptSellInfo != current.aptSellInfo ||
              previous.longApt != current.longApt ||
              previous.shortApt != current.shortApt,
          builder: (context, state) {
            final price = state.aptSellInfo.axPrice.toStringAsFixed(6);
            final _textStyle = textStyle(
              Colors.white,
              15,
              isBold: false,
              isUline: false,
            );
            return state.aptTypeSelection.isLong
                ? SizedBox(
                    width: 223,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '$price AX per ${state.longApt.ticker} APT',
                        style: _textStyle,
                        maxLines: 1,
                      ),
                    ),
                  )
                : SizedBox(
                    width: 223,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '$price AX per ${state.shortApt.ticker} APT',
                        style: _textStyle,
                        maxLines: 1,
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
