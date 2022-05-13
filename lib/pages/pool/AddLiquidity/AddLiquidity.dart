import 'package:ax_dapp/pages/pool/bloc/PoolBloc.dart';
import 'package:ax_dapp/pages/pool/models/PoolEvent.dart';
import 'package:ax_dapp/pages/pool/models/PoolState.dart';
import 'package:ax_dapp/service/AthleteTokenList.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLiquidity extends StatefulWidget {
  AddLiquidity({Key? key}) : super(key: key);

  @override
  State<AddLiquidity> createState() => _AddLiquidityState();
}

class _AddLiquidityState extends State<AddLiquidity> {
  late double token1Amount;
  late double token2Amount;

  final TextEditingController _tokenAmountOneController =
      TextEditingController();
  final TextEditingController _tokenAmountTwoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  onTokenAmountChange() {
    // //if from amount changed, autocomplete to amount
    // if (_tokenAmountOneFocusNode.hasFocus) {
    //   final tokenOne = double.tryParse(_tokenAmountOneController.text);
    //
    //   if (tokenOne != null) {
    //     //Update amount 1
    //     token1Amount = double.parse(_tokenAmountOneController.text);
    //     poolController.updateTopAmount(token1Amount);
    //   }
    // }
    // //if to amount changed, autocomplete from amount
    // if (_tokenAmountTwoFocusNode.hasFocus) {
    //   final tokenTwo = double.tryParse(_tokenAmountTwoController.text);
    //
    //   if (tokenTwo != null) {
    //     //Autocomplete and update amount 1
    //     //Update amount 2
    //     token2Amount = double.parse(_tokenAmountTwoController.text);
    //     poolController.updateBottomAmount(token2Amount);
    //   }
    // }
  }

  @override
  void dispose() {
    _tokenAmountOneController.dispose();
    _tokenAmountTwoController.dispose();
    super.dispose();
  }

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
        final token0Price = state.token0Price.toStringAsFixed(6);
        final token1Price = state.token1Price.toStringAsFixed(6);
        final double balance0 = state.balance0;
        final double balance1 = state.balance1;
        Token? token0 = state.token0;
        Token? token1 = state.token1;
        print("$token0Price desktopPool");
        print("$token1Price desktopPool");

        if (state.status == BlocStatus.initial) {
          bloc.add(PageRefreshEvent());
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
            return currentToken.address == token0!.address;
          } else {
            //tknNum == 2
            return currentToken.address == token1!.address;
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
            if (token0 == null)
              decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

            if (token0 != null) {
              tkr = token0.ticker;
              tokenImage = token0.icon;
            }
          } else {
            if (token1 == null)
              decor = boxDecoration(Colors.blue, 100, 0, Colors.blue);

            if (token1 != null) {
              tkr = token1.ticker;
              tokenImage = token1.icon;
            }
          }

          return Container(
            height: 70,
            width: tokenContainerWdt,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration:
                boxDecoration(Colors.transparent, 20, .5, Colors.grey[400]!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // left-half of token box (dropdown menu button containing token)
                Container(
                  width: 175,
                  height: 40,
                  decoration: decor,
                  child: TextButton(
                    // onPressed: (){},
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AthleteTokenList(context, tknNum, createTokenElement),
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
                    Container(
                        height: 24,
                        width: 40,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                            onPressed: () {},
                            child: Text("MAX",
                                style:
                                    textStyle(Colors.grey[400]!, 8, false)))),
                    //Amount input box
                    SizedBox(
                      width: tokenContainerWdt * 0.15,
                      child: TextFormField(
                        controller: tokenAmountController,
                        onChanged: (token0Input) {
                          bloc.add(
                              Token0InputChanged(double.parse(token0Input)));
                        },
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
                  ],
                ))
              ],
            ),
          );
        }

        Widget pricePoolShareDetails(double elementWdt, bool isAdvDetails) {
          //element width refers to the width of the widget that is returned by this method
          elementWdt = isWeb ? elementWdt * 0.85 : elementWdt * 0.9;
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    (isAdvDetails)
                        ? "Details: Price and Pool Share"
                        : "Details",
                    style: textStyle(Colors.white, 21, true),
                  ),
                ),
                Container(
                  width: elementWdt,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        " ${token0!.ticker} per ${token1!.ticker}:",
                        style: textStyle(Colors.grey[600]!, 15, false),
                      ),
                      Text(
                        "$token0Price",
                        style: textStyle(Colors.white, 15, false),
                      ),
                      Text(
                        "Share of pool:",
                        style: textStyle(Colors.grey[600]!, 15, false),
                      ),
                      Text(
                        "0.12%",
                        style: textStyle(Colors.white, 15, false),
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
                      Text(
                        "${token1.ticker} per ${token0.ticker}:",
                        style: textStyle(Colors.grey[600]!, 15, false),
                      ),
                      Text(
                        "$token1Price",
                        style: textStyle(Colors.white, 15, false),
                      ),
                      Text(
                        "Expected yield:",
                        style: textStyle(Colors.grey[600]!, 15, false),
                      ),
                      Text(
                        "24.12%",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: elementWdt,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "*Add liquidity to earn 0.25% of all trades on this pair",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15)),
                        TextSpan(
                            text:
                                " proportional to your share of the pool and receive LP tokens.",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                (isAdvDetails)
                    ? Container(
                        width: elementWdt,
                        height: 45,
                        decoration: boxDecoration(
                            Colors.amber[400]!, 100, 0, Colors.amber[400]!),
                        child: TextButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  poolAddLiquidity(context,
                                      (token1.ticker + " " + token1.name))),
                          child: Text(
                            "Add Liquidity",
                            style: textStyle(Colors.black, 16, true),
                          ),
                        ),
                      )
                    : Container(
                        width: elementWdt,
                        height: 45,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 1, Colors.amber[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Approve",
                            style: textStyle(Colors.amber[400]!, 16, true),
                          ),
                        ),
                      )
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
          double elementWdt = isWeb ? layoutWdt / 2 : layoutWdt;
          double tokensSectionHgt = isWeb ? 275 : allLiquidityCardHgt * 0.55;
          //Returns the contents of all liquidity pool card
          return <Widget>[
            //Tokens side add liq. -left side of all liquidity pool card in desktop, top of card in mobile-
            Container(
              height: tokensSectionHgt,
              width: elementWdt,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //Balance text on top of tokenContainer
                  Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 50),
                      child: Text("Balance: $balance0",
                          style: textStyle(Colors.grey[600]!, 13, false))),
                  //Top Token container
                  createTokenButton(1, elementWdt, _tokenAmountOneController),
                  Container(
                      child: Text(
                    "+",
                    style: textStyle(Colors.grey[600]!, 35, true),
                  )),
                  Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 50),
                      child: Text("Balance: $balance1",
                          style: textStyle(Colors.grey[600]!, 13, false))),
                  // Bottom Token container
                  createTokenButton(2, elementWdt, _tokenAmountTwoController),
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
              //Empty filler space for web
              if (isWeb) Container(height: layoutHgt * 0.5 - 300),
            ],
          );
        }

        //Bloc builder return
        return allLiquidityLayout(layoutHgt, layoutWdt);
      },
    );
  }
}
