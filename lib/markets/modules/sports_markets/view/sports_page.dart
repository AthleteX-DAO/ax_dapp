import 'package:ax_dapp/markets/markets.dart';
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
        getSportsMarketsDataUseCase: context.read<GetSportsMarketsDataUseCase>(),
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
