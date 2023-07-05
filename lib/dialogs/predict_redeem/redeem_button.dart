import 'package:ax_dapp/dialogs/predict_redeem/bloc/redeem_button_bloc.dart';
import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericRedeemButton extends StatelessWidget {
  const GenericRedeemButton({
    super.key,
    required this.containerWdt,
    required this.isPortraitMode,
    required this.prompt,
  });

  final double containerWdt;
  final PredictionModel prompt;
  final bool isPortraitMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RedeemButtonBloc(
        eventMarketRepository: context.read<EventMarketRepository>(),
      ),
      child: BlocConsumer<RedeemButtonBloc, RedeemButtonState>(
        builder: (context, state) {
          final bloc = context.read<RedeemButtonBloc>();
          return Container(
            width: isPortraitMode ? containerWdt / 3 : 175,
            height: 50,
            decoration: boxDecoration(Colors.black, 100, 0, Colors.white),
            child: TextButton(
              onPressed: () {
                bloc.add(
                  RedeemButtonPressed(
                    eventMarketAddress: prompt.address,
                  ),
                );
              },
              child: Text(
                'Redeem',
                style: textStyle(Colors.white, 20, false, false),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
