import 'package:ax_dapp/pages/trade/bloc/TradePageBloc.dart';
import 'package:ax_dapp/service/ApproveButton.dart';
import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({Key? key}) : super(key: key);

  @override
  _DesktopTradeState createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  SwapController swapController = Get.find();
  WalletController walletController = Get.find();
  bool isWeb = true;
  TextEditingController _tokenFromInputController = TextEditingController();
  TextEditingController _tokenToInputController = TextEditingController();

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
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _height = mediaquery.size.height;
    double _width = mediaquery.size.width;
    double wid = isWeb ? 550 : _width;
    //Token container refers to box with border that contains tokenButton and input box
    double tokenContainerWid = wid * 0.95;
    double amountBoxAndMaxButtonWid = tokenContainerWid * 0.5;

    return BlocBuilder<TradePageBloc, TradePageState>(
      buildWhen: (previous, current) => current.status.name.isNotEmpty,
      builder: (context, state) {
        final bloc = context.read<TradePageBloc>();
        final price = state.swapInfo.toPrice.toStringAsFixed(6);
        final tokenToBalance = state.tokenToBalance.toStringAsFixed(6);
        final tokenFromBalance = state.tokenFromBalance.toStringAsFixed(6);
        final minReceived = state.swapInfo.minimumReceived.toStringAsFixed(6);
        final priceImpact = state.swapInfo.priceImpact.toStringAsFixed(6);
        final receiveAmount = state.swapInfo.receiveAmount.toStringAsFixed(6);
        final totalFee = state.swapInfo.totalFee.toStringAsFixed(6);
        final slippageTolerance = 1;
        // print("TradePage tokenFrom: ${state.tokenFrom!.address.value}");
        final Token tokenFrom = state.tokenFrom;
        final Token tokenTo = state.tokenTo;
        // TODO: add autofill feature
        // final tokenInputFromAmount = state.tokenInputFromAmount;
        // final tokenInputToAmount = state.tokenInputToAmount;

        if (state.status == BlocStatus.initial) {
          bloc.add(PageRefreshEvent());
        }

        TextStyle textStyle(Color color, double size, bool isBold) {
          if (isBold)
            return TextStyle(
              color: color,
              fontFamily: 'OpenSans',
              fontSize: size,
              fontWeight: FontWeight.w400,
            );
          else
            return TextStyle(
              color: color,
              fontFamily: 'OpenSans',
              fontSize: size,
            );
        }

        BoxDecoration boxDecoration(
            Color col, double rad, double borWid, Color borCol) {
          return BoxDecoration(
              color: col,
              borderRadius: BorderRadius.circular(rad),
              border: Border.all(color: borCol, width: borWid));
        }

        Container maxButton() {
          return Container(
            height: 24,
            width: 40,
            decoration:
                boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
            child: TextButton(
              onPressed: () {
                bloc.add(MaxSwapTapEvent());
                bloc.add(NewTokenFromInputEvent(
                    tokenInputFromAmount: double.parse(tokenFromBalance)));
                _tokenFromInputController.text = tokenFromBalance;
              },
              child: Text(
                "MAX",
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
          if (value == '') {
            value = '0';
          }
          bloc.add(
            NewTokenFromInputEvent(
              tokenInputFromAmount: double.parse(value),
            ),
          );
        }

        Widget createTokenElement(Token token, int tknNum) {
          //Creates a token item for AthleteTokenList widget
          double _width = MediaQuery.of(context).size.width;
          return Container(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[900],
                onSurface:
                    isTokenSelected(token, tknNum) ? Colors.amber : Colors.grey,
              ),
              onPressed: isTokenSelected(token, tknNum)
                  ? null
                  : () {
                      if (tknNum == 1) {
                        if (token == tokenTo) {
                          // If the user changes the top token and it is the same as the bottom token, then swap the top and bottom
                          bloc.add(SwapTokens());
                        } else {
                          bloc.add(SetTokenFrom(tokenFrom: token));
                        }
                      } else {
                        if (token == tokenFrom) {
                          bloc.add(SwapTokens());
                        } else {
                          bloc.add(SetTokenTo(tokenTo: token));
                        }
                      }
                      _addEventForFromInputValue(
                        _tokenFromInputController.text,
                        bloc,
                      );

                      bloc.add(PageRefreshEvent());
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                            image: token.icon!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      // ticker/name column "AX/AthleteX"
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
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
            ),
          );
        }

        Widget createTokenButton(int tknNum) {
          double _height = MediaQuery.of(context).size.height;
          double _width = MediaQuery.of(context).size.width;
          double textSize = _height * 0.05;
          double tkrTextSize = textSize * 0.25;
          if (!isWeb) tkrTextSize = textSize * 0.35;
          String tkr = "Select a Token";
          AssetImage? tokenImage = AssetImage('../assets/images/apt.png');
          BoxDecoration decor =
              boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!);
          if (tknNum == 1) {
            tkr = tokenFrom.ticker;
            tokenImage = tokenFrom.icon;
          } else {
            //tknNum == 2
            tkr = tokenTo.ticker;
            tokenImage = tokenTo.icon;
          }

          return Container(
              constraints: BoxConstraints(
                maxWidth: (_width < 350.0) ? 115 : 150,
                maxHeight: 100,
              ),
              height: 40,
              decoration: decor,
              child: TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AthleteTokenList(
                          context, tknNum, createTokenElement)),
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: tokenImage!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(width: 10),
                      Expanded(
                        child: Text(tkr,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle(Colors.white, tkrTextSize, true)),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 25)
                    ],
                  ))));
        }

        Widget fromAmountBox(amountBoxAndMaxButtonWid) {
          return Container(
            child: ConstrainedBox(
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
                        (RegExp(r'^(\d+)?\.?\d{0,6}'))),
                  ],
                ),
              ),
            ),
          );
        }

        Widget toAmountBox(amountBoxAndMaxButtonWid) {
          return Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: amountBoxAndMaxButtonWid),
              child: IntrinsicWidth(
                  child: Text(
                receiveAmount,
                style: textStyle(Colors.grey[400]!, 22, false),
              )),
            ),
          );
        }

        Widget showPrice(price) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Price:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "$price " + tokenTo.ticker + " per " + tokenFrom.ticker,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        Widget showLPFee(lpFee) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total Fees",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "$lpFee ${tokenFrom.ticker}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        Widget showMarketPriceImpact(priceImpact) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Market Price Impact:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "$priceImpact %",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        Widget showMinimumReceived(minReceived) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Minimum Received:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "$minReceived " + tokenTo.ticker,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        Widget showSlippageTolerance(slippageTolerance) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Slippage Tolerance:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "$slippageTolerance %",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        Widget showYouReceived(receiveAmount) {
          return Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "You receive:",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "$receiveAmount " + tokenTo.ticker,
                  style: TextStyle(
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
              "Balance: $balance",
              style: textStyle(Colors.grey[400]!, 14, false),
            ),
            // padding: EdgeInsets.only(right: 14),
          );
        }

        return SafeArea(
          bottom: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: _height - 114,
            alignment: Alignment.center,
            child: Container(
              height: _height * 0.575,
              width: wid,
              decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.6), 30,
                  0.5, Colors.grey[400]!),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                        padding: isWeb
                            ? EdgeInsets.only(left: 20)
                            : EdgeInsets.all(0),
                        width: wid - 50,
                        alignment:
                            isWeb ? Alignment.centerLeft : Alignment.center,
                        child: Text(isWeb ? "Swap" : "Token Swap",
                            style: textStyle(Colors.white, 16, false))),
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      width: wid - 50,
                      alignment: Alignment.centerLeft,
                      child: Text("From",
                          style: textStyle(Colors.grey[400]!, 12, false)),
                    ),
                    //First Token container with border
                    Container(
                      width: tokenContainerWid,
                      height: _height * 0.1,
                      alignment: Alignment.center,
                      decoration: boxDecoration(
                          Colors.transparent, 20, 0.5, Colors.grey[400]!),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      //This columns contains token info and balance below
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              createTokenButton(1),
                              //Max button and amount box 1
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
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
                  ]),
                  Column(
                    children: <Widget>[
                      Container(
                        child: TextButton(
                            onPressed: () {
                              bloc.add(SwapTokens());
                              _addEventForFromInputValue(
                                _tokenFromInputController.text,
                                bloc,
                              );
                              bloc.add(PageRefreshEvent());
                            },
                            child: Icon(
                              Icons.arrow_downward,
                              size: _height * 0.05,
                              color: Colors.grey[400],
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        width: wid - 50,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "To",
                          style: textStyle(Colors.grey[400]!, 12, false),
                        ),
                      ),
                      //Second Token container with border
                      Container(
                        width: tokenContainerWid,
                        height: _height * 0.1,
                        alignment: Alignment.center,
                        decoration: boxDecoration(
                            Colors.transparent, 20, 0.5, Colors.grey[400]!),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                //TO DO: make this and the input box above a single function
                                // dropdown
                                //tknNum = 2 (this is a comment)
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
                  Container(
                    width: wid,
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        showPrice(price),
                        showLPFee(totalFee),
                        showMarketPriceImpact(priceImpact),
                        showMinimumReceived(minReceived),
                        showSlippageTolerance(slippageTolerance),
                        showYouReceived(receiveAmount)
                      ],
                    ),
                  ),
                  ApproveButton(175, 40, "Approve", swapController.approve,
                      swapController.swap, transactionConfirmed),
                ],
              ),
            ),
          ),
        );
      }, //BlocBuilder
    );
  }
}
