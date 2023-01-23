import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete/widgets/widgets.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/scout/scout.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class AthletePage extends StatefulWidget {
  const AthletePage({
    super.key,
    required this.athlete,
  });

  final AthleteScoutModel? athlete;

  @override
  State<AthletePage> createState() => _AthletePageState();
}

class _AthletePageState extends State<AthletePage> {
  Global global = Global();
  late AthleteScoutModel athlete;

  Color indexUnselectedStackBackgroundColor = Colors.transparent;
  Controller controller = Get.find();

  @override
  void initState() {
    super.initState();
    athlete = widget.athlete!;
    final aptPair = context.read<TokensRepository>().currentAptPair(athlete.id);
    Get.find<LSPController>().updateAptAddress(aptPair.address);
  }

  @override
  Widget build(BuildContext context) {
    if (global.pageName != 'athlete') {
      context.goNamed(global.pageName);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: kIsWeb &&
                (MediaQuery.of(context).orientation == Orientation.landscape)
            ? TopNavigationBarWeb(page: global.pageName)
            : const TopNavigationBarMobile(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: kIsWeb &&
              (MediaQuery.of(context).orientation == Orientation.landscape)
          ? const BottomNavigationBarWeb()
          : BottomNavigationBarMobile(selectedIndex: global.selectedIndex),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocProvider(
          create: (context) => AthletePageBloc(
            walletRepository: context.read<WalletRepository>(),
            tokensRepository: context.read<TokensRepository>(),
            mlbRepo: RepositoryProvider.of<MLBRepo>(context),
            nflRepo: RepositoryProvider.of<NFLRepo>(context),
            athlete: athlete,
            getScoutAthletesDataUseCase: GetScoutAthletesDataUseCase(
              tokensRepository: context.read<TokensRepository>(),
              graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
              sportsRepos: [
                RepositoryProvider.of<MLBRepo>(context),
                RepositoryProvider.of<NFLRepo>(context),
              ],
            ),
          ),
          child: BlocListener<AthletePageBloc, AthletePageState>(
            listener: (context, state) {
              if (state.failure is DisconnectedWalletFailure) {
                context.showWalletWarningToast();
              }
              if (state.failure is InvalidAthleteFailure) {
                context.showWarningToast(
                  title: 'Error',
                  description: 'Cannot add athlete to wallet',
                );
              }
            },
            child: BlocBuilder<AthletePageBloc, AthletePageState>(
              buildWhen: (previous, current) => previous.stats != current.stats,
              builder: (_, state) {
                final chartStats = state.stats;
                return AthletePageWebView(
                  athlete: athlete,
                  chartStats: chartStats,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
