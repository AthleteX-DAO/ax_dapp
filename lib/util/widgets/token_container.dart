import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/trade/widgets/widgets.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class TokenContainerWidget extends StatefulWidget {
  const TokenContainerWidget({super.key});

  @override
  State<TokenContainerWidget> createState() => _TokenContainerWidgetState();
}

class _TokenContainerWidgetState extends State<TokenContainerWidget> {
  final tokenInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentTokens =
        context.select((WalletBloc bloc) => bloc.state.tokens);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final wid = isWeb ? 550.0 : _width;
    final tokenContainerWid = wid * 0.95;
    final tokenFromBalance = toDecimal(0, 6);
    final amountBoxAndMaxButtonWid = tokenContainerWid * 0.5;
    final textSize = _height * 0.05;
    var tkrTextSize = textSize * 0.25;
    if (!isWeb) tkrTextSize = textSize * 0.35;

    return Container(
      width: tokenContainerWid,
      height: _height * 0.11,
      alignment: Alignment.center,
      decoration: boxDecoration(
        Colors.transparent,
        20,
        0.5,
        Colors.grey[400]!,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      //This columns contains token info and balance below
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Token Container
              Container(
                constraints: BoxConstraints(
                  maxWidth: (_width < 350.0) ? 115 : 150,
                  maxHeight: 100,
                ),
                height: 40,
                decoration: boxDecoration(
                  Colors.grey[800]!,
                  100,
                  0,
                  Colors.grey[800]!,
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: BlocSelector<AccountBloc, AccountState, Token>(
                      selector: (state) => state.selectedToken,
                      builder: (context, token) {
                        return DropdownButton<Token>(
                          dropdownColor: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 1,
                          value: token,
                          items: [
                            for (final token in currentTokens)
                              DropdownMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: tokenImage(token),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        token.ticker,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle(
                                          Colors.white,
                                          tkrTextSize,
                                          isBold: true,
                                          isUline: false,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (token) {
                            context
                                .read<AccountBloc>()
                                .add(SwitchTokenRequested(token));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              //Max button and amount box 1
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Max Button
                  Container(
                    height: 24,
                    width: 40,
                    decoration: boxDecoration(
                      Colors.transparent,
                      100,
                      0.5,
                      Colors.grey[400]!,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: FittedBox(
                        child: SizedBox(
                          child: Text(
                            'MAX',
                            style: textStyle(
                              Colors.grey[400]!,
                              8,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Amount box
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: amountBoxAndMaxButtonWid),
                    child: IntrinsicWidth(
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: tokenInputController,
                        onChanged: (value) => {},
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 22,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 22,
                            fontFamily: 'OpenSans',
                          ),
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
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Balance(balance: tokenFromBalance)],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    super.dispose();
  }
}
