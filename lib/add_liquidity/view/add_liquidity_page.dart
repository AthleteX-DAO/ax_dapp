import 'package:ax_dapp/add_liquidity/bloc/add_liquidity_bloc.dart';
import 'package:ax_dapp/add_liquidity/widgets/pool_insufficient_button.dart';
import 'package:ax_dapp/add_liquidity/widgets/widgets.dart';
import 'package:ax_dapp/service/athlete_token_list.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/debouncer.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/util/warning_text_button.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tokens_repository/tokens_repository.dart';

// ignore: must_be_immutable
class AddLiquidityPage extends StatefulWidget {
  AddLiquidityPage({
    super.key,
    this.token0,
    this.token1,
    required this.goToPage,
  });

  Token? token0;
  Token? token1;
  final void Function(int pageNumber) goToPage;

  @override
  State<AddLiquidityPage> createState() => _AddLiquidityPageState();
}

class _AddLiquidityPageState extends State<AddLiquidityPage> {
  final TextEditingController _tokenAmountOneController =
      TextEditingController();
  final TextEditingController _tokenAmountTwoController =
      TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 200);
  Controller controller = Get.find();

  bool isSufficient(double balance0, double balance1) {
    var tokenOneAmount = double.tryParse(_tokenAmountOneController.text);
    var tokenTwoAmount = double.tryParse(_tokenAmountTwoController.text);
    if (tokenOneAmount == null || tokenTwoAmount == null) {
      tokenOneAmount = 0.0;
      tokenTwoAmount = 0.0;
    }
    final result = tokenOneAmount <= balance0 && tokenTwoAmount <= balance1;
    return result;
  }

  @override
  void dispose() {
    _tokenAmountOneController.dispose();
    _tokenAmountTwoController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  bool isReadOnly = true;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final _height = mediaquery.size.height;
    final _width = mediaquery.size.width;
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final layoutHgt = _height * 0.8;
    final layoutWdt = isWeb ? _width * 0.8 : _width * 0.9;

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.isWalletConnected || state.isWalletDisconnected) {
          context
              .read<AddLiquidityBloc>()
              .add(const WatchAppDataChangesStarted());
          _tokenAmountOneController.clear();
          _tokenAmountTwoController.clear();
        }
        if (state.isWalletUnavailable) {
          debugPrint('Wallet is unavailable -> ${state.isWalletUnavailable}');
        }
        if (state.isWalletUnsupported) {
          debugPrint('wallet is not supported -> ${state.isWalletUnsupported}');
        }
      },
      child: BlocConsumer<AddLiquidityBloc, AddLiquidityState>(
        listenWhen: (_, current) => current.status == BlocStatus.error,
        listener: (context, state) {
          if (state.failure is NoPoolInfoFailure) {
            context.showWarningToast(
              title: 'Action Error',
              description: 'No Pool Info found',
            );
            return;
          }
        },
        builder: (context, state) {
          final bloc = context.read<AddLiquidityBloc>();
          final poolInfo = state.poolPairInfo;
          final balance0 = state.balance0;
          final balance1 = state.balance1;
          final token0 = state.token0;
          final token1 = state.token1;

          if (widget.token0 != null && widget.token1 != null) {
            bloc
              ..add(Token0SelectionChanged(token0: widget.token0!))
              ..add(Token1SelectionChanged(token1: widget.token1!));
            widget
              ..token0 = null
              ..token1 = null;
          }

          bool isTokenSelected(Token currentToken, int tknNum) {
            if (tknNum == 1) {
              return currentToken.address == token0.address;
            } else {
              //tknNum == 2
              return currentToken.address == token1.address;
            }
          }

          Widget createTokenElement(
            Token token,
            int tknNum,
            BuildContext builderContext,
          ) {
            //Each element of listview is a tokenElement
            return SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  disabledForegroundColor: isTokenSelected(token, tknNum)
                      ? Colors.amber
                      : Colors.grey.withOpacity(0.38),
                  disabledBackgroundColor: isTokenSelected(token, tknNum)
                      ? Colors.amber
                      : Colors.grey.withOpacity(0.12),
                ),
                onPressed: isTokenSelected(token, tknNum)
                    ? null
                    : () {
                        if (tknNum == 1) {
                          if (token == token1) {
                            bloc.add(const SwapTokensRequested());
                          } else {
                            bloc.add(Token0SelectionChanged(token0: token));
                          }
                        } else {
                          if (token == token0) {
                            bloc.add(const SwapTokensRequested());
                          } else {
                            bloc.add(Token1SelectionChanged(token1: token));
                          }
                        }
                        bloc.add(const FetchPairInfoRequested());
                        _tokenAmountOneController.clear();
                        _tokenAmountTwoController.clear();
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
                            width: 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.name,
                              style: textStyle(Colors.white, 12, isBold: true),
                            ),
                          ),
                          Container(
                            width: 125,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              token.ticker,
                              style: textStyle(Colors.grey[100]!, 9, isBold: false),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          void onTokenInputChange(
            int tokenNumber,
            String tokenInput,
            {required bool hasData,}
          ) {
            final _tokenInput = tokenInput.isEmpty ? '0' : tokenInput;
            _debouncer.run(() {
              if (hasData) {
                if (tokenNumber == 1) {
                  bloc.add(Token0AmountChanged(_tokenInput));
                } else {
                  bloc.add(Token1AmountChanged(_tokenInput));
                }
              } else {
                if (tokenNumber == 1) {
                  bloc.add(Token0AmountChanged(_tokenInput));
                } else {
                  bloc.add(Token1AmountChanged(_tokenInput));
                }
              }
            });
          }

          Widget createTokenButton(
            int tknNum,
            double elementWdt,
            TextEditingController tokenAmountController,
          ) {
            final tokenContainerWdt = elementWdt * 0.9;
            var tkr = 'Select a Token';
            AssetImage? _tokenImage = const AssetImage('assets/images/apt.png');
            if (tknNum == 1) {
              tkr = token0.ticker;
              _tokenImage = tokenImage(token0);
            } else {
              tkr = token1.ticker;
              _tokenImage = tokenImage(token1);
            }

            return Container(
              height: 80,
              width: tokenContainerWdt,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration:
                  boxDecoration(Colors.transparent, 20, .5, Colors.grey[400]!),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // left-half of token box
                      // (dropdown menu button containing token)
                      Container(
                        width: 175,
                        height: 40,
                        decoration: boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!),
                        child: TextButton(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (BuildContext builderContext) =>
                                AthleteTokenList(
                              tknNum,
                              (token, tknNumber) => createTokenElement(
                                token,
                                tknNumber,
                                builderContext,
                              ),
                            ),
                          ),
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
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(width: 10),
                              Expanded(
                                child: Text(
                                  tkr,
                                  style: textStyle(Colors.white, 16, isBold: true),
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
                      ),
                      // right-half of token box (max button and input box)
                      Row(
                        children: [
                          //Max Button
                          if (tknNum == 1) ...[
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
                                onPressed: () {
                                  final formattedBalance0 =
                                      balance0.toStringAsFixed(6);
                                  _tokenAmountOneController.text =
                                      formattedBalance0;
                                  if (state.status == BlocStatus.success) {
                                    onTokenInputChange(
                                      tknNum,
                                      formattedBalance0,
                                      hasData: true,
                                    );
                                  } else {
                                    onTokenInputChange(
                                      tknNum,
                                      formattedBalance0,
                                      hasData: false,
                                    );
                                  }
                                },
                                child: Text(
                                  'MAX',
                                  style: textStyle(
                                    Colors.grey[400]!,
                                    8,
                                    isBold: false,
                                  ),
                                ),
                              ),
                            )
                          ],
                          //Amount input box
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: tokenContainerWdt * 0.5,
                            ),
                            child: IntrinsicWidth(
                              child: TextFormField(
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                readOnly: ((tknNum == 2) &&
                                        (state.status == BlocStatus.success))
                                    ? !isReadOnly
                                    : !isReadOnly,
                                controller: tokenAmountController,
                                onChanged: (tokenInput) {
                                  if (state.status == BlocStatus.success) {
                                    onTokenInputChange(
                                      tknNum,
                                      tokenInput,
                                      hasData: true,
                                    );
                                  } else {
                                    onTokenInputChange(
                                      tknNum,
                                      tokenInput,
                                      hasData: false,
                                    );
                                  }
                                },
                                style: textStyle(Colors.grey[400]!, 22, isBold: false),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle:
                                      textStyle(Colors.grey[400]!, 22, isBold: false),
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
                      )
                    ],
                  ),
                  Balance(tokenNumber: tknNum),
                ],
              ),
            );
          }

          Widget pricePoolShareDetails(double elementWdt, {required bool isAdvDetails}) {
            final _elementWdt = isWeb ? elementWdt * 0.85 : elementWdt * 0.9;
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShareDetailsHeader(elementWdt: _elementWdt, isAdvDetails: isAdvDetails),
                  // Liquidity details
                  LiquidityDetails(elementWdt: _elementWdt,),
                  // pool share / exp. yield
                  PoolShareDetails(elementWdt: _elementWdt,),
                  // Amount received
                  const YouReceived(),
                  if (state.status == BlocStatus.success ||
                      state.status == BlocStatus.noData)
                    if (isSufficient(balance0, balance1))
                      PoolApproveButton(
                        width: _elementWdt * 0.95 - 150,
                        tokenAmountOneController: _tokenAmountOneController,
                        tokenAmountTwoController: _tokenAmountTwoController,
                        height: 40,
                        text: 'Approve',
                        approveCallback: bloc.poolController.approve,
                        confirmCallback: bloc.poolController.addLiquidity,
                        currencyOne: token0.name,
                        currencyTwo: token1.name,
                        lpTokens: poolInfo.recieveAmount,
                        valueOne: _tokenAmountOneController.text,
                        valueTwo: _tokenAmountTwoController.text,
                        shareOfPool: poolInfo.shareOfPool,
                        lpTokenName: '${token0.ticker}/${token1.ticker}',
                        goToPage: widget.goToPage,
                      )
                    else
                      PoolInsufficientButton(
                        width: _elementWdt * 0.95 - 150,
                        height: 40,
                      )
                  else
                    WarningTextButton(
                      warningTitle: () {
                        final failure = state.failure;
                        if (failure is DisconnectedWalletFailure) {
                          return 'Wallet not connected!';
                        }
                        return 'Fetching Pool Info';
                      }(),
                    ),
                ],
              ),
            );
          }

          List<Widget> allLiquidityCardContents(
            double layoutHgt,
            double layoutWdt,
            double allLiquidityCardHgt,
            {required bool isAdvDetails,}
          ) {
            final elementWdt = isWeb ? layoutWdt / 2 : layoutWdt;
            final tokensSectionHgt = isWeb ? 280.0 : allLiquidityCardHgt * 0.55;
            return [
              SizedBox(
                height: tokensSectionHgt,
                width: elementWdt,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Top Token container
                    createTokenButton(1, elementWdt, _tokenAmountOneController),
                    Text(
                      '+',
                      style: textStyle(Colors.grey[600]!, 35, isBold: true),
                    ),
                    // Bottom Token container
                    createTokenButton(2, elementWdt, _tokenAmountTwoController),
                    if (state.status == BlocStatus.noData) ...[
                      const Text(
                        'Not Created - Please input both token amounts',
                      ),
                    ] else ...[
                      const Text(
                        'Please input an amount of liquidity for both tokens',
                      ),
                    ]
                  ],
                ),
              ),
              pricePoolShareDetails(elementWdt, isAdvDetails: isAdvDetails),
            ];
          }

          Widget allLiquidityLayout(double layoutHgt, double layoutWdt) {
            const isAdvDetails = true;
            final allLiquidityCardHgt = isWeb ? 300.0 : layoutHgt * 0.76;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: layoutWdt,
                  height: allLiquidityCardHgt,
                  decoration: boxDecoration(
                    Colors.grey[800]!.withOpacity(0.25),
                    30,
                    1.5,
                    Colors.grey[400]!,
                  ),
                  child: isWeb
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: allLiquidityCardContents(
                            layoutHgt,
                            layoutWdt,
                            allLiquidityCardHgt,
                            isAdvDetails: isAdvDetails,
                          ),
                        )
                      : Column(
                          children: allLiquidityCardContents(
                            layoutHgt,
                            layoutWdt,
                            allLiquidityCardHgt,
                            isAdvDetails: isAdvDetails,
                          ),
                        ),
                ),
              ],
            );
          }

          //Bloc builder return
          return allLiquidityLayout(layoutHgt, layoutWdt);
        },
      ),
    );
  }
}
