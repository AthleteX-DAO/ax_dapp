import 'package:ax_dapp/pages/farm/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/warning_text_button.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:wallet_repository/wallet_repository.dart';

class UnstakeDialog extends StatefulWidget {
  const UnstakeDialog({
    required this.context,
    required this.farm,
    required this.layoutWdt,
    required this.isWeb,
    super.key,
  });

  final BuildContext context;
  final FarmController farm;
  final double layoutWdt;
  final bool isWeb;

  @override
  State<StatefulWidget> createState() => _UnstakeDialogState();
}

class _UnstakeDialogState extends State<UnstakeDialog> {
  final unStakeAxInput = TextEditingController();
  RxBool isValid = true.obs;
  @override
  void dispose() {
    unStakeAxInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final wid = widget.isWeb ? 390.0 : widget.layoutWdt;
    final hgt = _height < 455.0 ? _height : 450.0;
    const dialogHorPadding = 30.0;
    final selectedFarm = FarmController.fromFarm(
      farm: widget.farm,
      walletRepository: context.read<WalletRepository>(),
    );
    final totalStakedBalance = 0.0.obs;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: hgt,
        width: wid,
        padding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: dialogHorPadding,
        ),
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unstake Liquidity',
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Amount Box
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  width: wid - dialogHorPadding - 30,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 5),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            scale: 2,
                            image: AssetImage('assets/images/x.jpg'),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          '''${selectedFarm.strStakedAlias.value.isNotEmpty ? selectedFarm.strStakedAlias : selectedFarm.strStakedSymbol}''',
                          style: textStyle(
                            Colors.white,
                            15,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 48,
                        decoration: boxDecoration(
                          Colors.transparent,
                          100,
                          0.5,
                          Colors.grey[400]!,
                        ),
                        child: TextButton(
                          onPressed: () {
                            getMaxBalanceInput(
                              selectedFarm,
                              totalStakedBalance,
                            );
                          },
                          child: Text(
                            'Max',
                            style: textStyle(
                              Colors.grey[400]!,
                              9,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          controller: unStakeAxInput,
                          onChanged: (value) {
                            unstakeInput(
                              value,
                              totalStakedBalance,
                              selectedFarm,
                            );
                          },
                          style: textStyle(
                            Colors.grey[400]!,
                            22,
                            isBold: false,
                            isUline: false,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
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
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,6}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current ${selectedFarm.strStakedSymbol} Staked',
                  style: textStyle(
                    Colors.grey[400]!,
                    14,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Obx(
                  () => Text(
                    '''${selectedFarm.stakedInfo.value.viewAmount} ${selectedFarm.strStakedSymbol}''',
                    style: textStyle(
                      Colors.grey[400]!,
                      14,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 55),
                  child: Text(
                    '-',
                    style: textStyle(
                      Colors.grey[400]!,
                      14,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Funds Removed',
                  style: textStyle(
                    Colors.grey[400]!,
                    14,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Obx(
                  () => Text(
                    '''${selectedFarm.strUnStakeInput.value} ${selectedFarm.strStakedSymbol}''',
                    style: textStyle(
                      Colors.grey[400]!,
                      14,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                thickness: 0.35,
                color: Colors.grey[400],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('New Staked Balance'),
                Obx(
                  () => Text(
                    '''${totalStakedBalance.value.toString()} ${selectedFarm.strStakedSymbol}''',
                  ),
                )
              ],
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isValid.value) ...[
                    UnStakeApproveButton(
                      width: 175,
                      height: 45,
                      text: 'Confirm',
                      selectedFarm: selectedFarm,
                      walletAddress: context
                          .read<WalletBloc>()
                          .state
                          .formattedWalletAddress,
                    ),
                  ] else ...[
                    const WarningTextButton(
                      warningTitle: 'Insufficient Balance',
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void unstakeInput(
    String value,
    RxDouble totalStakedBalance,
    FarmController selectedFarm,
  ) {
    if (value.isEmpty) {
      totalStakedBalance.value = 0.0;
      isValid.value = true;
    }
    selectedFarm.strUnStakeInput.value = value;
    totalStakedBalance.value = double.parse(
          selectedFarm.stakedInfo.value.viewAmount,
        ) -
        double.parse(
          selectedFarm.strUnStakeInput.value,
        );
    isValid.value = !totalStakedBalance.isNegative;
  }

  void getMaxBalanceInput(
    FarmController selectedFarm,
    RxDouble totalStakedBalance,
  ) {
    unStakeAxInput.text = selectedFarm.stakedInfo.value.viewAmount;
    selectedFarm.strUnStakeInput.value = unStakeAxInput.text;
    totalStakedBalance.value = double.parse(
          selectedFarm.stakedInfo.value.viewAmount,
        ) -
        double.parse(
          selectedFarm.strUnStakeInput.value,
        );
    isValid.value = !totalStakedBalance.isNegative;
  }
}
