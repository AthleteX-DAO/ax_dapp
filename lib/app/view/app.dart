import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/app/view/entry_app.dart';
import 'package:ax_dapp/app/widgets/bottom_navigation_bar/bloc/bottom_navigation_bar_bloc.dart';
import 'package:ax_dapp/app/widgets/top_navigation_bar/bloc/top_navigation_bar_bloc.dart';
import 'package:ax_dapp/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:config_repository/config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:league_repository/league_repository.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:tracking_repository/tracking_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.configRepository,
  });

  final ConfigRepository configRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(
            walletRepository: context.read<WalletRepository>(),
            tokensRepository: context.read<TokensRepository>(),
            configRepository: configRepository,
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => WalletBloc(
            walletRepository: context.read<WalletRepository>(),
            tokensRepository: context.read<TokensRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TrackingCubit(
            context.read<TrackingRepository>(),
          )..setup(),
        ),
        BlocProvider(
          create: (context) => LeagueBloc(
            leagueRepository: context.read<LeagueRepository>(),
            streamAppDataChanges: context.read<StreamAppDataChangesUseCase>(),
            prizePoolRepository: context.read<PrizePoolRepository>(),
            leagueUseCase: context.read<LeagueUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => TopNavigationBarBloc(),
        ),
        BlocProvider(
          create: (context) => BottomNavigationBarBloc(),
        ),
      ],
      child: const EntryApp(),
    );
  }
}
