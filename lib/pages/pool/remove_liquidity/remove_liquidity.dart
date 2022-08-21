import 'package:ax_dapp/pages/pool/my_liqudity/components/pool_remove_approve_button.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/my_liquidity.dart';
import 'package:ax_dapp/pages/pool/remove_liquidity/bloc/remove_liquidity_bloc.dart';
import 'package:ax_dapp/pages/pool/remove_liquidity/bloc/remove_liquidity_event.dart';
import 'package:ax_dapp/pages/pool/remove_liquidity/bloc/remove_liquidity_state.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/format_wallet_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RemoveLiquidity extends StatefulWidget {
  const RemoveLiquidity({
    required this.infoOfSelectedCard,
    required this.togglePool,
    required this.token0Icon,
    required this.token1Icon,
    super.key,
  });

  final LiquidityPositionInfo infoOfSelectedCard;
  final Function togglePool;
  final AssetImage token0Icon;
  final AssetImage token1Icon;

  @override
  State<RemoveLiquidity> createState() => _RemoveLiquidityState();
}

class _RemoveLiquidityState extends State<RemoveLiquidity> {
  double _width = 0;
  PoolController poolController = Get.find();
  Controller controller = Get.find();
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final _height = mediaquery.size.height;
    _width = mediaquery.size.width;
    final userWalletAddress = FormatWalletAddress.getWalletAddress(
      controller.publicAddress.toString(),
    );
    if (currentTabIndex == 1) {
      return MyLiquidity(togglePool: widget.togglePool);
    }
    return BlocBuilder<RemoveLiquidityBloc, RemoveLiquidityState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final bloc = context.read<RemoveLiquidityBloc>();
        final tokenOneRemoveAmount = state.tokenOneRemoveAmount;
        final tokenTwoRemoveAmount = state.tokenTwoRemoveAmount;
        final lpTokenPairBalance = state.lpTokenPairBalance;
        final shareOfPool = state.shareOfPool;
        final percentRemoval = state.percentRemoval;
        final lpTokenOneAmount = state.lpTokenOneAmount;
        final lpTokenTwoAmount = state.lpTokenTwoAmount;
        if (state.status == BlocStatus.initial) {
          bloc.add(PageRefreshEvent());
        }
        return Material(
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
                            style: textStyle(Colors.white, 20, false),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Amount'),
                          Row(
                            children: [
                              Text(
                                '$percentRemoval%',
                                style: textStyle(Colors.white, 36, true),
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
                                    bloc.add(const RemoveInput(removeInput: 25));
                                  },
                                  child: Text(
                                    '25%',
                                    style: textStyle(
                                      Colors.white,
                                      12,
                                      true,
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
                                    bloc.add(const RemoveInput(removeInput: 50));
                                  },
                                  child: Text(
                                    '50%',
                                    style: textStyle(
                                      Colors.white,
                                      12,
                                      true,
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
                                    bloc.add(const RemoveInput(removeInput: 75));
                                  },
                                  child: Text(
                                    '75%',
                                    style: textStyle(
                                      Colors.white,
                                      12,
                                      true,
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
                                    bloc.add(const RemoveInput(removeInput: 100));
                                  },
                                  child: Text(
                                    '100%',
                                    style: textStyle(
                                      Colors.white,
                                      12,
                                      true,
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
                            value: percentRemoval,
                            onChanged: (double newValue) {
                              bloc.add(
                                RemoveInput(
                                  removeInput: newValue.roundToDouble(),
                                ),
                              );
                            },
                            max: 100,
                            divisions: 100,
                            label: '$percentRemoval',
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
                            false,
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
                                    false,
                                  ),
                                ),
                                Text(
                                  lpTokenPairBalance,
                                  style: textStyle(
                                    Colors.white,
                                    16,
                                    false,
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
                                    false,
                                  ),
                                ),
                                Text(
                                  '$shareOfPool%',
                                  style: textStyle(
                                    Colors.white,
                                    16,
                                    false,
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
                                    false,
                                  ),
                                ),
                                Text(
                                  lpTokenOneAmount,
                                  style: textStyle(
                                    Colors.white,
                                    16,
                                    false,
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
                                    false,
                                  ),
                                ),
                                Text(
                                  lpTokenTwoAmount,
                                  style: textStyle(
                                    Colors.white,
                                    16,
                                    false,
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
                            false,
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
                                    margin: const EdgeInsets.only(left: 30),
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        scale: 0.25,
                                        image: widget.token0Icon,
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
                                      false,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    margin: const EdgeInsets.only(right: 30),
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
                                    margin: const EdgeInsets.only(left: 30),
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        scale: 0.25,
                                        image: widget.token1Icon,
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
                                      false,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    margin: const EdgeInsets.only(right: 30),
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
                            width: 175,
                            height: 40,
                            text: 'Approve',
                            approveCallback: bloc.poolController.approveRemove,
                            confirmCallback: bloc.poolController.removeLiquidity,
                            confirmDialog: removalConfirmed,
                            currencyOne: widget.infoOfSelectedCard.token0Symbol,
                            currencyTwo: widget.infoOfSelectedCard.token1Symbol,
                            valueOne: tokenOneRemoveAmount,
                            valueTwo: tokenTwoRemoveAmount,
                            lpTokens: lpTokenPairBalance,
                            shareOfPool: shareOfPool,
                            percentRemoval: percentRemoval,
                            walletId: userWalletAddress.walletAddress,
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
                                  currentTabIndex = 1;
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
