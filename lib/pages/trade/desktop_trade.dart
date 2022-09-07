// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/pages/trade/components/trade_approve_button.dart';
import 'package:ax_dapp/service/athlete_token_list.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/util/warning_text_button.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({super.key});

  @override
  State<DesktopTrade> createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  SwapController swapController = Get.find();
  bool isWeb = true;
  final TextEditingController _tokenFromInputController =
      TextEditingController();
  final TextEditingController _tokenToInputController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _tokenFromInputController.dispose();
    _tokenToInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final mediaquery = MediaQuery.of(context);
    final _height = mediaquery.size.height;
    final _width = mediaquery.size.width;
    final wid = isWeb ? 550.0 : _width;
    // Token container refers to box with border that contains tokenButton and
    // input box
    final tokenContainerWid = wid * 0.95;
    final amountBoxAndMaxButtonWid = tokenContainerWid * 0.5;

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.isWalletConnected || state.isWalletDisconnected) {
          context.read<TradePageBloc>().add(WatchAppDataChangesStarted());
          _tokenFromInputController.clear();
          _tokenToInputController.clear();
        }
        if (state.isWalletUnavailable) {
          debugPrint('Wallet is unavailable -> ${state.isWalletUnavailable}');
        }
        if (state.isWalletUnsupported) {
          debugPrint('wallet is not supported -> ${state.isWalletUnsupported}');
        }
      },
      child: BlocConsumer<TradePageBloc, TradePageState>(
        listenWhen: (_, current) => current.status == BlocStatus.error,
        listener: (context, state) {
          if (state.failure is NoSwapInfoFailure) {
            context.showWarningToast(
              title: 'Action Error',
              description: 'No swap info found',
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<TradePageBloc>();
          final price = state.swapInfo.toPrice.toStringAsFixed(6);
          final tokenToBalance = state.tokenToBalance.toStringAsFixed(6);
          final tokenFromBalance = toDecimal(state.tokenFromBalance, 6);
          final minReceived = state.swapInfo.minimumReceived.toStringAsFixed(6);
          final priceImpact = state.swapInfo.priceImpact.toStringAsFixed(6);
          final receiveAmount = state.status != BlocStatus.error
              ? state.swapInfo.receiveAmount.toStringAsFixed(6)
              : '0';
          _tokenToInputController.text = receiveAmount;
          final totalFee = state.swapInfo.totalFee.toStringAsFixed(6);
          const slippageTolerance = 1;
          final tokenFrom = state.tokenFrom;
          final tokenTo = state.tokenTo;
          // TODO(mretana1999): add autofill feature

          TextStyle textStyle(Color color, double size, bool isBold) {
            if (isBold) {
              return TextStyle(
                color: color,
                fontFamily: 'OpenSans',
                fontSize: size,
                fontWeight: FontWeight.w400,
              );
            } else {
              return TextStyle(
                color: color,
                fontFamily: 'OpenSans',
                fontSize: size,
              );
            }
          }

          BoxDecoration boxDecoration(
            Color col,
            double rad,
            double borWid,
            Color borCol,
          ) {
            return BoxDecoration(
              color: col,
              borderRadius: BorderRadius.circular(rad),
              border: Border.all(color: borCol, width: borWid),
            );
          }

          Container maxButton() {
            return Container(
              height: 24,
              width: 40,
              decoration: boxDecoration(
                Colors.transparent,
                100,
                0.5,
                Colors.grey[400]!,
              ),
              child: TextButton(
                onPressed: () {
                  bloc
                    ..add(MaxSwapTapEvent())
                    ..add(
                      NewTokenFromInputEvent(
                        tokenInputFromAmount: double.parse(tokenFromBalance),
                      ),
                    );
                  _tokenFromInputController.text = tokenFromBalance;
                },
                child: Text(
                  'MAX',
                  style: textStyle(Colors.grey[400]!, 8, false),
                ),
              ),
            );
          }

          bool isTokenSelected(Token selectedToken, int tknNum) {
            if (tknNum == 1) {
              return selectedToken.address == state.tokenFrom.address;
            } else {
              //tknNum == 2
              return selectedToken.address == state.tokenTo.address;
            }
          }

          void _addEventForFromInputValue(String value, TradePageBloc bloc) {
            final _value = value.isEmpty ? '0' : value;
            bloc.add(
              NewTokenFromInputEvent(
                tokenInputFromAmount: double.parse(_value),
              ),
            );
          }

          Widget createTokenElement(
            Token token,
            int tknNum,
            BuildContext builderContext,
          ) {
            //Creates a token item for AthleteTokenList widget
            final _width = MediaQuery.of(context).size.width;
            return SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[900],
                  onSurface: isTokenSelected(token, tknNum)
                      ? Colors.amber
                      : Colors.grey,
                ),
                onPressed: isTokenSelected(token, tknNum)
                    ? null
                    : () {
                        if (tknNum == 1) {
                          if (token == tokenTo) {
                            // If the user changes the top token and it is the
                            // same as the bottom token, then swap the top and
                            // bottom
                            bloc.add(
                              SwapTokens(
                                tokenFromBalance: tokenFromBalance,
                                tokenToBalance: tokenToBalance,
                              ),
                            );
                          } else {
                            bloc.add(SetTokenFrom(tokenFrom: token));
                          }
                        } else {
                          if (token == tokenFrom) {
                            bloc.add(
                              SwapTokens(
                                tokenFromBalance: tokenFromBalance,
                                tokenToBalance: tokenToBalance,
                              ),
                            );
                          } else {
                            bloc.add(SetTokenTo(tokenTo: token));
                          }
                        }
                        _addEventForFromInputValue(
                          _tokenFromInputController.text,
                          bloc,
                        );

                        bloc.add(FetchTradeInfoRequested());
                        setState(() {
                          Navigator.pop(builderContext);
                        });
                      },
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 60,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            scale: 0.5,
                            image: tokenImage(token),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      // ticker/name column "AX/AthleteX"
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: (_width < 350.0) ? 110 : 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.ticker,
                              style: textStyle(Colors.white, 14, true),
                            ),
                          ),
                          Container(
                            width: (_width < 350.0) ? 110 : 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.name,
                              style: textStyle(Colors.grey[100]!, 9, false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          Widget createTokenButton(int tknNum) {
            final _height = MediaQuery.of(context).size.height;
            final _width = MediaQuery.of(context).size.width;
            final textSize = _height * 0.05;
            var tkrTextSize = textSize * 0.25;
            if (!isWeb) tkrTextSize = textSize * 0.35;
            var tkr = 'Select a Token';
            AssetImage? _tokenImage =
                const AssetImage('../assets/images/apt.png');
            final decor =
                boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!);
            if (tknNum == 1) {
              tkr = tokenFrom.ticker;
              _tokenImage = tokenImage(tokenFrom);
            } else {
              //tknNum == 2
              tkr = tokenTo.ticker;
              _tokenImage = tokenImage(tokenTo);
            }

            return Container(
              constraints: BoxConstraints(
                maxWidth: (_width < 350.0) ? 115 : 150,
                maxHeight: 100,
              ),
              height: 40,
              decoration: decor,
              child: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext builderContext) => AthleteTokenList(
                    tknNum,
                    (token, tknNumber) => createTokenElement(
                      token,
                      tknNumber,
                      builderContext,
                    ),
                  ),
                ).then((value) => setState(_tokenFromInputController.clear)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _tokenImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(width: 10),
                    Expanded(
                      child: Text(
                        tkr,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle(Colors.white, tkrTextSize, true),
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
            );
          }

          Widget fromAmountBox(double amountBoxAndMaxButtonWid) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: amountBoxAndMaxButtonWid),
              child: IntrinsicWidth(
                child: TextFormField(
                  controller: _tokenFromInputController,
                  onChanged: (value) => _addEventForFromInputValue(value, bloc),
                  style: textStyle(Colors.grey[400]!, 22, false),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: textStyle(Colors.grey[400]!, 22, false),
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

          Widget toAmountBox(double amountBoxAndMaxButtonWid) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: amountBoxAndMaxButtonWid),
              child: IntrinsicWidth(
                child: TextFormField(
                  readOnly: true,
                  controller: _tokenToInputController,
                  style: textStyle(Colors.grey[400]!, 22, false),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: textStyle(Colors.grey[400]!, 22, false),
                    contentPadding: const EdgeInsets.all(9),
                    border: InputBorder.none,
                  ),
                ),
              ),
            );
          }

          Widget showPrice(String price) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$price ${tokenTo.ticker} per ${tokenFrom.ticker}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          Widget showLPFee(String lpFee) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Fees',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$lpFee ${tokenFrom.ticker}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          Widget showMarketPriceImpact(String priceImpact) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Market Price Impact:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$priceImpact %',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          Widget showMinimumReceived(String minReceived) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minimum Received:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$minReceived ${tokenTo.ticker}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          Widget showSlippageTolerance(int slippageTolerance) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Slippage Tolerance:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$slippageTolerance %',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          Widget showYouReceived(String receiveAmount) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'You receive:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$receiveAmount ${tokenTo.ticker}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          Widget showBalance(String balance) {
            //Returns widget that shows balance underneath input box
            return Flexible(
              child: Text(
                'Balance: $balance',
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
            );
          }

          return SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: _height - 114,
              alignment: Alignment.center,
              child: Container(
                height: _height * 0.575,
                width: wid,
                decoration: boxDecoration(
                  Colors.grey[800]!.withOpacity(0.6),
                  30,
                  0.5,
                  Colors.grey[400]!,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: isWeb
                              ? const EdgeInsets.only(left: 20)
                              : EdgeInsets.zero,
                          width: wid - 50,
                          alignment:
                              isWeb ? Alignment.centerLeft : Alignment.center,
                          child: Text(
                            isWeb ? 'Swap' : 'Token Swap',
                            style: textStyle(Colors.white, 16, false),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: wid - 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'From',
                            style: textStyle(Colors.grey[400]!, 12, false),
                          ),
                        ),
                        //First Token container with border
                        Container(
                          width: tokenContainerWid,
                          height: _height * 0.1,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  createTokenButton(1),
                                  //Max button and amount box 1
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //Max Button
                                      maxButton(),
                                      //Amount box
                                      fromAmountBox(amountBoxAndMaxButtonWid),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [showBalance(tokenFromBalance)],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            bloc.add(
                              SwapTokens(
                                tokenFromBalance: tokenFromBalance,
                                tokenToBalance: tokenToBalance,
                              ),
                            );
                            _addEventForFromInputValue(
                              _tokenFromInputController.text,
                              bloc,
                            );
                          },
                          child: Icon(
                            Icons.arrow_downward,
                            size: _height * 0.05,
                            color: Colors.grey[400],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: wid - 50,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'To',
                            style: textStyle(Colors.grey[400]!, 12, false),
                          ),
                        ),
                        //Second Token container with border
                        Container(
                          width: tokenContainerWid,
                          height: _height * 0.1,
                          alignment: Alignment.center,
                          decoration: boxDecoration(
                            Colors.transparent,
                            20,
                            0.5,
                            Colors.grey[400]!,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // TODO(Ryan): make this and the input box
                                  //  above
                                  // a single function
                                  // dropdown
                                  // tknNum = 2 (this is a comment)
                                  createTokenButton(2),
                                  // Amount box 2
                                  toAmountBox(amountBoxAndMaxButtonWid),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [showBalance(tokenToBalance)],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: wid,
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          showPrice(price),
                          showLPFee(totalFee),
                          showMarketPriceImpact(priceImpact),
                          showMinimumReceived(minReceived),
                          showSlippageTolerance(slippageTolerance),
                          showYouReceived(receiveAmount)
                        ],
                      ),
                    ),
                    if (state.status != BlocStatus.error)
                      TradeApproveButton(
                        tokenFromInputController: _tokenFromInputController,
                        tokenToInputController: _tokenToInputController,
                        width: 175,
                        height: 40,
                        text: 'Approve',
                        approveCallback: swapController.approve,
                        confirmCallback: swapController.swap,
                        confirmDialog: transactionConfirmed,
                        fromCurrency: tokenFrom.name,
                        toCurrency: tokenTo.name,
                        fromUnits: _tokenFromInputController.text,
                        toUnits: receiveAmount,
                        totalFee: totalFee,
                        tradePageBloc: bloc,
                      )
                    else
                      WarningTextButton(
                        warningTitle: () {
                          final failure = state.failure;
                          if (failure is DisconnectedWalletFailure) {
                            return 'Wallet not connected!';
                          }
                          if (failure is NoSwapInfoFailure) {
                            return 'No swap info found';
                          }
                          if (failure is InSufficientFailure) {
                            return 'Insufficient Balance';
                          }
                          return 'Something went wrong';
                        }(),
                      ),
                  ],
                ),
              ),
            ),
          );
        }, //BlocBuilder
      ),
    );
  }
}
