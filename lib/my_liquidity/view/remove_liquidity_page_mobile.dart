import 'package:ax_dapp/my_liquidity/my_liquidity.dart';
import 'package:ax_dapp/my_liquidity/widgets/pool_remove_approve_button.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/limit_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallet_repository/wallet_repository.dart';

class RemoveLiquidityPageMobile extends StatefulWidget {
  const RemoveLiquidityPageMobile({
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
  State<RemoveLiquidityPageMobile> createState() =>
      _RemoveLiquidityPageMobileState();
}

class _RemoveLiquidityPageMobileState extends State<RemoveLiquidityPageMobile> {
  LiquidityPositionInfo infoOfSelectedCard = LiquidityPositionInfo.empty();
  double value = 0;
  final TextEditingController _removeAmountController = TextEditingController();

  @override
  void initState() {
    infoOfSelectedCard = widget.infoOfSelectedCard;
    super.initState();
  }

  @override
  void dispose() {
    _removeAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final tokenOneRemoveAmount =
        double.parse(infoOfSelectedCard.token0LpAmount) * (value / 100);
    final tokenTwoRemoveAmount =
        double.parse(infoOfSelectedCard.token1LpAmount) * (value / 100);
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: _height * 0.7,
      child: Container(
        height: _height * 0.6,
        width: _width * 0.7,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 30,
        ),
        decoration: boxDecoration(
          Colors.grey[900]!,
          30,
          0,
          Colors.black,
        ),
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
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Amount To Remove',
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 500,
                  height: 50,
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: _width,
                            ),
                            child: IntrinsicWidth(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _removeAmountController,
                                onChanged: (removeInput) {
                                  setState(() {
                                    value = removeInput.isEmpty
                                        ? 0
                                        : double.parse(removeInput)
                                            .roundToDouble();
                                    widget.poolController.removePercentage =
                                        value;
                                  });
                                },
                                style: textStyle(
                                  Colors.grey[400]!,
                                  22,
                                  isBold: false,
                                  isUline: false,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: textStyle(
                                    Colors.grey[400]!,
                                    22,
                                    isBold: false,
                                    isUline: false,
                                  ),
                                  contentPadding: const EdgeInsets.all(9),
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                  LimitRange(0, 100),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                  FittedBox(
                    child: SizedBox(
                      width: _width,
                      child: Row(
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
                    ),
                  ),
                  FittedBox(
                    child: SizedBox(
                      width: _width,
                      child: Row(
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
                    ),
                  ),
                  FittedBox(
                    child: SizedBox(
                      width: _width,
                      child: Row(
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
                      ),
                    ),
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
            FittedBox(
              child: Container(
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
            ),
            SizedBox(height: _height * 0.03),
            FittedBox(
              child: SizedBox(
                child: Row(
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
