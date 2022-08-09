import 'package:ax_dapp/pages/farm/components/unstake_approve_button.dart';
import 'package:ax_dapp/pages/farm/dialogs/unstake_confirmed_dialog.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/dialog_text_style.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
    final selectedFarm = FarmController.fromFarm(widget.farm);
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
                  style: textStyle(Colors.white, 20, false),
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
                          style: textStyle(Colors.white, 15, false),
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
                            unStakeAxInput.text =
                                selectedFarm.stakedInfo.value.viewAmount;
                            selectedFarm.strUnStakeInput.value =
                                unStakeAxInput.text;
                            totalStakedBalance.value = double.parse(
                                  selectedFarm.stakedInfo.value.viewAmount,
                                ) -
                                double.parse(
                                  selectedFarm.strUnStakeInput.value,
                                );
                          },
                          child: Text(
                            'Max',
                            style: textStyle(Colors.grey[400]!, 9, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          controller: unStakeAxInput,
                          onChanged: (value) {
                            if (value.isEmpty) totalStakedBalance.value = 0.0;
                            selectedFarm.strUnStakeInput.value = value;
                            totalStakedBalance.value = double.parse(
                                  selectedFarm.stakedInfo.value.viewAmount,
                                ) -
                                double.parse(
                                  selectedFarm.strUnStakeInput.value,
                                );
                            isValid.value = !totalStakedBalance.isNegative;
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
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
                Obx(
                  () => Text(
                    '''${selectedFarm.stakedInfo.value.viewAmount} ${selectedFarm.strStakedSymbol}''',
                    style: textStyle(Colors.grey[400]!, 14, false),
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
                    style: textStyle(Colors.grey[400]!, 14, false),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Funds Removed',
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
                Obx(
                  () => Text(
                    '''${selectedFarm.strUnStakeInput.value} ${selectedFarm.strStakedSymbol}''',
                    style: textStyle(Colors.grey[400]!, 14, false),
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
                ),
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
                      text: 'Approve',
                      confirmDialog: unstakeConfirmedDialog,
                      selectedFarm: selectedFarm,
                    ),
                  ] else ...[
                    const Text('Insufficient Input'),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
