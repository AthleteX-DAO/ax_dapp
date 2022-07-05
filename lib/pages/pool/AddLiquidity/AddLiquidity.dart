import 'package:ax_dapp/pages/pool/AddLiquidity/bloc/PoolBloc.dart';
import 'package:ax_dapp/service/ApproveButton.dart';
import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class AddLiquidity extends StatefulWidget {
  Token? token0;
  Token? token1;
  AddLiquidity({Key? key, this.token0, this.token1}) : super(key: key);

  @override
  State<AddLiquidity> createState() => _AddLiquidityState();
}

class _AddLiquidityState extends State<AddLiquidity> {
  final TextEditingController _tokenAmountOneController =
      TextEditingController();
  final TextEditingController _tokenAmountTwoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tokenAmountOneController.dispose();
    _tokenAmountTwoController.dispose();
    super.dispose();
  }

  var isReadOnly = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    double _height = mediaquery.size.height;
    double _width = mediaquery.size.width;
    bool isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double layoutHgt = _height * 0.8;
    double layoutWdt = isWeb ? _width * 0.8 : _width * 0.9;

    print(_width);
    return BlocBuilder<PoolBloc, PoolState>(
      buildWhen: (previous, current) => current != previous,
      builder: (context, state) {
        final bloc = context.read<PoolBloc>();
        final poolInfo = state.poolPairInfo;
        final balance0 = state.balance0;
        final balance1 = state.balance1;
        Token? token0 = state.token0;
        Token? token1 = state.token1;

        if (state.status == BlocStatus.initial) {
          bloc.add(PageRefreshEvent());
        }

        if (widget.token0 != null && widget.token1 != null) {
          bloc.add(Token0SelectionChanged(token0: widget.token0!));
          bloc.add(Token1SelectionChanged(token1: widget.token1!));
          widget.token0 = null;
          widget.token1 = null;
        }

        TextStyle textStyle(Color color, double size, bool isBold) {
          if (isBold)
            return TextStyle(
              color: color,
              fontFamily: 'OpenSans',
              fontSize: size,
              fontWeight: FontWeight.w500,
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

        isTokenSelected(Token currentToken, int tknNum) {
          if (tknNum == 1) {
            return currentToken.address == token0.address;
          } else {
            //tknNum == 2
            return currentToken.address == token1.address;
          }
        }

        Widget createTokenElement(Token token, int tknNum) {
          //Each element of listview is a tokenElement
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
                        if (token == token1) {
                          bloc.add(SwapTokens());
                        } else {
                          bloc.add(Token0SelectionChanged(token0: token));
                        }
                      } else {
                        if (token == token0) {
                          bloc.add(SwapTokens());
                        } else {
                          bloc.add(Token1SelectionChanged(token1: token));
                        }
                      }
                      bloc.add(PageRefreshEvent());
                      _tokenAmountOneController.clear();
                      _tokenAmountTwoController.clear();
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
                                width: 125,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  token.name,
                                  style: textStyle(Colors.white, 12, true),
                                )),
                            Container(
                                width: 125,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  (token.ticker),
                                  style: textStyle(Colors.grey[100]!, 9, false),
                                )),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        }

        Widget showBalance(int tknNum) {
          return Container(
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.bottomRight,
            child: Text(
              tknNum == 1 ? "Balance: $balance0" : "Balance: $balance1",
              style: textStyle(Colors.grey[600]!, 13, false),
            ),
          );
        }

        onTokenInputChange(tokenNumber, tokenInput, hasData) {
          if (tokenInput == '') {
            tokenInput = '0';
          }
          if (hasData) {
            if (tokenNumber == 1) {
              bloc.add(Token0InputChanged(tokenInput.toString()));
              final tokenTwoAmount = double.parse(tokenInput) / poolInfo.ratio;
              _tokenAmountTwoController.text =
                  tokenTwoAmount.toStringAsFixed(6);
              bloc.add(Token1InputChanged(tokenTwoAmount.toString()));
            } else {
              bloc.add(Token1InputChanged(tokenInput.toString()));
              final tokenOneAmount = double.parse(tokenInput) * poolInfo.ratio;
              _tokenAmountOneController.text =
                  tokenOneAmount.toStringAsFixed(6);
              bloc.add(Token0InputChanged(tokenOneAmount.toString()));
            }
          } else {
            if (tokenNumber == 1) {
              bloc.add(Token0InputChanged(tokenInput.toString()));
            } else {
              bloc.add(Token1InputChanged(tokenInput.toString()));
            }
          }
        }

        Widget createTokenButton(
          int tknNum,
          double elementWdt,
          TextEditingController tokenAmountController,
        ) {
          //Returns the tokenContainer containing dropdown menu button with token icon and ticker
          //and amount input box
          //element width refers to the width of half the all liquidity card (for desktop only

          double tokenContainerWdt = elementWdt * 0.9;
          String tkr = "Select a Token";
          AssetImage? tokenImage = AssetImage('assets/images/apt.png');
          BoxDecoration decor =
              boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!);
          if (tknNum == 1) {
            tkr = token0.ticker;
            tokenImage = token0.icon;
          } else {
            tkr = token1.ticker;
            tokenImage = token1.icon;
          }

          return Container(
            height: 80,
            width: tokenContainerWdt,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration:
                boxDecoration(Colors.transparent, 20, .5, Colors.grey[400]!),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // left-half of token box (dropdown menu button containing token)
                    Container(
                      width: 175,
                      height: 40,
                      decoration: decor,
                      child: TextButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => AthleteTokenList(
                              context, tknNum, createTokenElement),
                        ),
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
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(width: 10),
                            Expanded(
                              child: Text(tkr,
                                  style: textStyle(Colors.white, 16, true)),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 25)
                          ],
                        ),
                      ),
                    ),
                    // right-half of token box (max button and input box)
                    Container(
                        child: Row(
                      children: <Widget>[
                        //Max Button
                        if (tknNum == 1) ...[
                          Container(
                              height: 24,
                              width: 40,
                              decoration: boxDecoration(Colors.transparent, 100,
                                  0.5, Colors.grey[400]!),
                              child: TextButton(
                                  onPressed: () {
                                    _tokenAmountOneController.text = balance0;
                                    if (state.status == BlocStatus.success) {
                                      onTokenInputChange(
                                          tknNum, balance0, true);
                                    } else {
                                      onTokenInputChange(
                                          tknNum, balance0, false);
                                    }
                                  },
                                  child: Text("MAX",
                                      style: textStyle(
                                          Colors.grey[400]!, 8, false))))
                        ],
                        //Amount input box
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: tokenContainerWdt * 0.5),
                          child: IntrinsicWidth(
                            child: TextFormField(
                              readOnly: ((tknNum == 2) &&
                                      (state.status == BlocStatus.success))
                                  ? isReadOnly
                                  : !isReadOnly,
                              controller: tokenAmountController,
                              onChanged: (tokenInput) {
                                if (state.status == BlocStatus.success) {
                                  onTokenInputChange(tknNum, tokenInput, true);
                                } else {
                                  onTokenInputChange(tknNum, tokenInput, false);
                                }
                              },
                              style: textStyle(Colors.grey[400]!, 22, false),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle:
                                    textStyle(Colors.grey[400]!, 22, false),
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
                      ],
                    ))
                  ],
                ),
                showBalance(tknNum),
              ],
            ),
          );
        }

        Widget addLiquidityToolTip(double elementWdt) {
          return Tooltip(
            height: 50,
            padding: EdgeInsets.all(10),
            verticalOffset: -100,
            // preferBelow: false,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25)),
            richMessage: TextSpan(
                text:
                    "*Add liquidity to earn 0.25% of all trades on this pair proportional to your share of the pool and receive LP tokens.",
                style: TextStyle(color: Colors.grey[400], fontSize: 18)),
            child:
                Icon(Icons.info_outline_rounded, color: Colors.grey, size: 25),
          );
        }

        Widget youWillReceiveToolTip() {
          return Tooltip(
            height: 50,
            padding: EdgeInsets.all(10),
            verticalOffset: -60,
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(25)),
            richMessage: TextSpan(
                text:
                    "*Output is estimated. If the price changes by more than 2%, your transaction will revert.",
                style: TextStyle(color: Colors.grey[400], fontSize: 18)),
            child:
                Icon(Icons.info_outline_rounded, color: Colors.grey, size: 20),
          );
        }

        Widget poolShareDetailsHeader(double elementWdt, bool isAdvDetails) {
          return Container(
            height: 30,
            width: elementWdt,
            child: Row(
              mainAxisAlignment:
                  isWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    (isAdvDetails)
                        ? "Details: Price and Pool Share"
                        : "Details",
                    style: textStyle(Colors.white, 21, true),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 6),
                    child: addLiquidityToolTip(elementWdt))
              ],
            ),
          );
        }

        Widget showYouReceived(amountToReceive) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 25,
                child: Row(
                  mainAxisAlignment: isWeb
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "You will receive:",
                        style: textStyle(Colors.grey[600]!, 18, false),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      child: youWillReceiveToolTip(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Row(
                      mainAxisAlignment: isWeb
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Text(
                              "$amountToReceive",
                              style: textStyle(Colors.white, 21, false),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${token0.ticker}/${token1.ticker}",
                              style: textStyle(Colors.white, 15, false),
                            ),
                            Text(
                              "LP Tokens",
                              style: textStyle(Colors.white, 15, false),
                            )
                          ],
                        )
                      ],
                    )),
                  ],
                ),
              )
            ],
          );
        }

        Widget pricePoolShareDetails(double elementWdt, bool isAdvDetails) {
          //element width refers to the width of the widget that is returned by this method
          elementWdt = isWeb ? elementWdt * 0.85 : elementWdt * 0.9;
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                poolShareDetailsHeader(elementWdt, isAdvDetails),
                Container(
                  width: elementWdt,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "${token0.ticker} Liquidity:",
                          style: textStyle(Colors.grey[600]!, 15, false),
                        ),
                      ),
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "${poolInfo.reserve0}",
                          style: textStyle(Colors.white, 15, false),
                        ),
                      ),
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "${token1.ticker} Liquidity:",
                          style: textStyle(Colors.grey[600]!, 15, false),
                        ),
                      ),
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "${poolInfo.reserve1}",
                          style: textStyle(Colors.white, 15, false),
                        ),
                      ),
                    ],
                  ),
                ),
                // pool share / exp. yield
                Container(
                  width: elementWdt,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "Share of pool:",
                          style: textStyle(Colors.grey[600]!, 15, false),
                        ),
                      ),
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "${poolInfo.shareOfPool}%",
                          style: textStyle(Colors.white, 15, false),
                        ),
                      ),
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "Expected yield:",
                          style: textStyle(Colors.grey[600]!, 15, false),
                        ),
                      ),
                      Container(
                        width: elementWdt / 4,
                        child: Text(
                          "${poolInfo.apy}",
                          style: textStyle(Colors.white, 15, false),
                        ),
                      ),
                    ],
                  ),
                ),
                showYouReceived(poolInfo.recieveAmount),
                ApproveButton(
                    elementWdt * 0.95,
                    40,
                    "Approve",
                    bloc.poolController.approve,
                    bloc.poolController.addLiquidity,
                    transactionConfirmed)
              ],
            ),
          );
        }

        List<Widget> allLiquidityCardContents(
          double layoutHgt,
          double layoutWdt,
          double allLiquidityCardHgt,
          bool isAdvDetails,
        ) {
          //elementWdt is half the page layout width for desktop version
          double elementWdt = isWeb ? layoutWdt / 2 : layoutWdt;
          double tokensSectionHgt = isWeb ? 280 : allLiquidityCardHgt * 0.55;
          //Returns the contents of all liquidity pool card
          return <Widget>[
            //Tokens side add liq. -left side of all liquidity pool card in desktop, top of card in mobile-
            Container(
              height: tokensSectionHgt,
              width: elementWdt,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Top Token container
                  createTokenButton(1, elementWdt, _tokenAmountOneController),
                  Container(
                      child: Text(
                    "+",
                    style: textStyle(Colors.grey[600]!, 35, true),
                  )),
                  // Bottom Token container
                  createTokenButton(2, elementWdt, _tokenAmountTwoController),
                  if (state.status == BlocStatus.no_data) ...[
                    Text('Not Created - Please input both token amounts'),
                  ]
                ],
              ),
            ),
            // Pool details side (add liq.) -right side of liquidity pool card, bottom of card in mobile-
            pricePoolShareDetails(elementWdt, isAdvDetails),
          ];
        }

        Widget allLiquidityLayout(double layoutHgt, double layoutWdt) {
          //Boolean to show advanced details
          //Using 87% of layoutHgt at the moment (76) Pool Card + (5) Title + (6) Toggle Button
          bool isAdvDetails = true;
          double allLiquidityCardHgt = isWeb ? 300 : layoutHgt * 0.76;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Liquidity pool grey card
              Container(
                margin: EdgeInsets.only(top: 20),
                width: layoutWdt,
                height: allLiquidityCardHgt,
                decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.25),
                    30, 1.5, Colors.grey[400]!),
                //if isWeb return a row structure for all liquidity card, else return a column
                child: isWeb
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: allLiquidityCardContents(layoutHgt, layoutWdt,
                            allLiquidityCardHgt, isAdvDetails),
                      )
                    : Column(
                        children: allLiquidityCardContents(layoutHgt, layoutWdt,
                            allLiquidityCardHgt, isAdvDetails),
                      ),
              ),
            ],
          );
        }

        //Bloc builder return
        return allLiquidityLayout(layoutHgt, layoutWdt);
      },
    );
  }
}
