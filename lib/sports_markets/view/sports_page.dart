import 'package:ax_dapp/sports_markets/bloc/sports_page_bloc.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/usecases/get_sports_markets_data_use_case.dart';
import 'package:ax_dapp/sports_markets/view/sports_page_web_view.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_repository/wallet_repository.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({
    super.key,
    required this.sport,
  });

  final SportsMarketsModel sport;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SportsPageBloc(
        walletRepository: context.read<WalletRepository>(),
        getSportsMarketsDataUseCase:
            context.read<GetSportsMarketsDataUseCase>(),
      ),
      child: BlocListener<SportsPageBloc, SportsPageState>(
        listener: (context, state) {
          if (state.failure is DisconnectedWalletFailure) {
            context.showWalletWarningToast();
          }
        },
        child: SportsPageWebView(
          sportsMarketsModel: sport,
        ),
      ),
    );
  }
}
