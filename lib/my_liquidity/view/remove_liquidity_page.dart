import 'package:ax_dapp/my_liquidity/my_liquidity.dart';
import 'package:ax_dapp/my_liquidity/widgets/pool_remove_approve_button.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_repository/wallet_repository.dart';

class RemoveLiquidityPage extends StatefulWidget {
  const RemoveLiquidityPage({
    super.key,
    required this.infoOfSelectedCard,
    required this.token0Icon,
    required this.token1Icon,
    required TabController tabController,
    required this.poolController,
  }) : _tabController = tabController;

  final LiquidityPositionInfo infoOfSelectedCard;
  final AssetImage? token0Icon;
  final AssetImage? token1Icon;
  final TabController _tabController;
  final PoolController poolController;

  @override
  State<RemoveLiquidityPage> createState() => _RemoveLiquidityPageState();
}

class _RemoveLiquidityPageState extends State<RemoveLiquidityPage> {
  LiquidityPositionInfo infoOfSelectedCard = LiquidityPositionInfo.empty();
  double value = 0;

  @override
  void initState() {
    infoOfSelectedCard = widget.infoOfSelectedCard;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final tokenOneRemoveAmount =
        double.parse(infoOfSelectedCard.token0LpAmount) * (value / 100);
    final tokenTwoRemoveAmount =
        double.parse(infoOfSelectedCard.token1LpAmount) * (value / 100);
    return SizedBox(
      width: _width * 0.7,
      height: _height * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: _width * 0.5,
            padding: const EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 30,
            ),
            decoration: boxDecoration(
              Colors.grey[900]!,
              30,
              0,
              Colors.black,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remove Liquidity',
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Amount'),
                      Row(
                        children: [
                          Text(
                            '$value%',
                            style: textStyle(
                              Colors.white,
                              36,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                          const Spacer(),
                          DecoratedBox(
                            decoration: boxDecoration(
                              Colors.grey[600]!,
                              4,
                              0.5,
                              Colors.grey[600]!,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  value = 25;
                                  widget.poolController.removePercentage =
                                      value;
                                });
                              },
                              child: Text(
                                '25%',
                                style: textStyle(
                                  Colors.white,
                                  12,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            decoration: boxDecoration(
                              Colors.grey[600]!,
                              4,
                              0.5,
                              Colors.grey[600]!,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  value = 50;
                                  widget.poolController.removePercentage =
                                      value;
                                });
                              },
                              child: Text(
                                '50%',
                                style: textStyle(
                                  Colors.white,
                                  12,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            decoration: boxDecoration(
                              Colors.grey[600]!,
                              4,
                              0.5,
                              Colors.grey[600]!,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  value = 75;
                                  widget.poolController.removePercentage =
                                      value;
                                });
                              },
                              child: Text(
                                '75%',
                                style: textStyle(
                                  Colors.white,
                                  12,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            decoration: boxDecoration(
                              Colors.grey[600]!,
                              4,
                              0.5,
                              Colors.grey[600]!,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  value = 100;
                                  widget.poolController.removePercentage =
                                      value;
                                });
                              },
                              child: Text(
                                '100%',
                                style: textStyle(
                                  Colors.white,
                                  12,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        thumbColor: Colors.amber.withOpacity(0.88),
                        inactiveColor: Colors.amber.withOpacity(0.5),
                        activeColor: Colors.amber,
                        value: value,
                        onChanged: (double newValue) {
                          setState(() {
                            value = newValue.roundToDouble();
                            widget.poolController.removePercentage = value;
                          });
                        },
                        max: 100,
                        divisions: 100,
                        label: '$value',
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your position:',
                      style: textStyle(
                        Colors.grey[600]!,
                        16,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ),
                  // ax per apt & share of pool
                  SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.infoOfSelectedCard.token0Symbol}/${widget.infoOfSelectedCard.token1Symbol}'
                              ' LP Tokens:',
                              style: textStyle(
                                Colors.white,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            Text(
                              widget.infoOfSelectedCard.lpTokenPairBalance,
                              style: textStyle(
                                Colors.white,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Share of pool:',
                              style: textStyle(
                                Colors.grey[600]!,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            Text(
                              '${widget.infoOfSelectedCard.shareOfPool}%',
                              style: textStyle(
                                Colors.white,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '''${widget.infoOfSelectedCard.token0Symbol} deposited:''',
                              style: textStyle(
                                Colors.grey[600]!,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            Text(
                              widget.infoOfSelectedCard.token0LpAmount,
                              style: textStyle(
                                Colors.white,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '''${widget.infoOfSelectedCard.token1Symbol} deposited:''',
                              style: textStyle(
                                Colors.grey[600]!,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            Text(
                              widget.infoOfSelectedCard.token1LpAmount,
                              style: textStyle(
                                Colors.white,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey[600]),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Remove:',
                      style: textStyle(
                        Colors.grey[600]!,
                        16,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ),
                  Container(
                    width: _width,
                    height: _height * 0.1,
                    decoration: boxDecoration(
                      Colors.transparent,
                      15,
                      0.5,
                      Colors.grey[600]!,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: _width - 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 30,
                                ),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    scale: 0.25,
                                    image: widget.token0Icon!,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.infoOfSelectedCard.token0Symbol,
                                style: textStyle(
                                  Colors.white,
                                  16,
                                  isBold: false,
                                  isUline: false,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 30,
                                ),
                                width: _width * .20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        tokenOneRemoveAmount.toStringAsFixed(6),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: _width - 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 30,
                                ),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    scale: 0.25,
                                    image: widget.token1Icon!,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.infoOfSelectedCard.token1Symbol,
                                style: textStyle(
                                  Colors.white,
                                  16,
                                  isBold: false,
                                  isUline: false,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 30,
                                ),
                                width: _width * .20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        tokenTwoRemoveAmount.toStringAsFixed(6),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.03),
                  Row(
                    children: [
                      PoolRemoveApproveButton(
                        tabController: widget._tabController,
                        text: 'Approve',
                        approveCallback: () {
                          final handler =
                              context.read<WalletRepository>().getTokenBalance;
                          return widget.poolController.approveRemove(handler);
                        },
                        confirmCallback: () {
                          final handler =
                              context.read<WalletRepository>().getTokenBalance;
                          return widget.poolController.removeLiquidity(handler);
                        },
                        currencyOne: widget.infoOfSelectedCard.token0Symbol,
                        currencyTwo: widget.infoOfSelectedCard.token1Symbol,
                        valueOne: tokenOneRemoveAmount,
                        valueTwo: tokenTwoRemoveAmount,
                        lpTokens: widget.infoOfSelectedCard.lpTokenPairBalance,
                        shareOfPool: widget.infoOfSelectedCard.shareOfPool,
                        percentRemoval: value,
                        lpTokenName:
                            '${widget.infoOfSelectedCard.token0Symbol}/${widget.infoOfSelectedCard.token1Symbol}',
                      ),
                      const Spacer(),
                      Container(
                        width: 175,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              widget._tabController.index = 0;
                              value = 0;
                              widget.poolController.removePercentage = value;
                            });
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.amber,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
