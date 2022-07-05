import 'package:ax_dapp/dialogs/buy/BuyDialog.dart';
import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/dialogs/sell/SellDialog.dart';
import 'package:ax_dapp/dialogs/sell/bloc/SellDialogBloc.dart';
import 'package:ax_dapp/pages/scout/dialogs/AthletePageDialogs.dart';
import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetBuyInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetSellInfoUseCase.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:ax_dapp/util/AthletePageFormatHelper.dart';
import 'package:ax_dapp/util/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

  Container buyButton(BuildContext context, AthleteScoutModel athlete, Function() goToTradePage) {
    return Container(
      width: 175,
      height: 50,
      decoration: boxDecoration(
          primaryOrangeColor,
          100,
          0,
          primaryOrangeColor),
      child: TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                  create: (BuildContext context) => BuyDialogBloc(
                      repo: RepositoryProvider
                          .of<GetBuyInfoUseCase>(
                              context),
                      wallet:
                          GetTotalTokenBalanceUseCase(Get.find()),
                      swapController: Get.find()),
                  child: BuyDialog(athlete.name, athlete.longTokenBookPrice!, athlete.id, goToTradePage))),
          child: Text("Buy", style: textStyle(Colors.black, 20, false, false))));
  }

  Container sellButton(BuildContext context, AthleteScoutModel athlete) {
    return Container(
      width: 175,
      height: 50,
      decoration: boxDecoration(
          Colors.white,
          100,
          0,
          Colors.white),
      child: TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                  create: (BuildContext context) => SellDialogBloc(
                      repo: RepositoryProvider
                          .of<GetSellInfoUseCase>(
                              context),
                      wallet: GetTotalTokenBalanceUseCase(
                          Get.find()),
                      swapController:
                          Get.find()),
                  child: SellDialog(
                      athlete.name,
                      athlete.longTokenBookPrice!,
                      athlete.id))),
          child: Text("Sell", style: textStyle(Colors.black, 20, false, false))));
  }

  Container mintButton(BuildContext context, AthleteScoutModel athlete) {
    return Container(
      width: 175,
      height: 50,
      decoration: boxDecoration(
          Colors.transparent,
          100,
          2,
          Colors.white),
      child: TextButton(
          onPressed: () => showDialog(
              context: context,
              builder:
                  (BuildContext context) =>
                      MintDialog(athlete)),
          child: Text("Mint",
              style: textStyle(Colors.white,
                  20, false, false))));
  }

  Container redeemButton(BuildContext context, AthleteScoutModel athlete) {
    return Container(
      width: 175,
      height: 50,
      decoration: boxDecoration(
          Colors.transparent,
          100,
          2,
          Colors.white),
      child: TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext
                      context) =>
                  RedeemDialog(athlete)),
          child: Text("Redeem",
              style: textStyle(Colors.white,
                  20, false, false))));
  }