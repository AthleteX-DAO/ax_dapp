import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete/widgets/widgets.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class BuildMobileView extends StatelessWidget {
  const BuildMobileView({super.key, required this.athlete});

  final AthleteScoutModel athlete;

  @override
  Widget build(BuildContext context) {
    const longMarketPrice = '4.18 AX';
    const longMarketPricePercent = '-2%';
    final longBookValue =
        '${athlete.longTokenBookPrice!.toStringAsFixed(2)} AX ';
    const longBookValuePercent = '+4%';

    const shortMarketPrice = '2.18 AX';
    const shortMarketPricePercent = '-1%';
    final shortBookValue =
        '${athlete.shortTokenBookPrice!.toStringAsFixed(2)} AX ';
    const shortBookValuePercent = '+2%';

    return SafeArea(
      child: BlocSelector<AthletePageBloc, AthletePageState, AptType>(
        selector: (state) => state.aptTypeSelection,
        builder: (context, aptTypeSelection) {
          return IndexedStack(
            index: aptTypeSelection.index - 1,
            children: [
              BuildPage(
                marketPrice: longMarketPrice,
                marketPricePercent: longMarketPricePercent,
                bookValue: longBookValue,
                bookValuePercent: longBookValuePercent,
                athlete: athlete,
              ),
              BuildPage(
                marketPrice: shortMarketPrice,
                marketPricePercent: shortMarketPricePercent,
                bookValue: shortBookValue,
                bookValuePercent: shortBookValuePercent,
                athlete: athlete,
              ),
            ],
          );
        },
      ),
    );
  }
}
