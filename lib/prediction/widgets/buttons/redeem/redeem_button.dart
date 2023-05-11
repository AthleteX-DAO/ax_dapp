import 'package:ax_dapp/prediction/widgets/buttons/redeem/bloc/redeem_button_bloc.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericRedeemButton extends StatelessWidget {
  const GenericRedeemButton(
      {super.key, required this.containerWdt, required this.isPortraitMode});

  final double containerWdt;
  final bool isPortraitMode;

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    const paddingHorizontal = 40.0;
    const hgt = 450.0;
    const newAmount = 0;
    final wid = isWeb ? 400.0 : 355.0;
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
            decoration:
                boxDecoration(Colors.greenAccent, 100, 0, Colors.white10),
            child: TextButton(
              onPressed: () {
                bloc.add(const RedeemButtonPressed());
              },
              child: Text(
                'Redeem',
                style: textStyle(Colors.black, 20, false, false),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
