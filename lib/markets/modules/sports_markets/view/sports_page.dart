import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_repository/wallet_repository.dart';

import 'sports_page_web_view.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({
    super.key,
    required this.sport,
  });

  final SportsMarketsModel sport;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => SportsPageBloc(
        walletRepository: context.read<WalletRepository>(),
        sportsMarketsRepository: context.read<SportsMarketsRepository>(),
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
