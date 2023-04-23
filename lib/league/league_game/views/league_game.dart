import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_draft/views/desktop_league_draft.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/calculate_team_performance_usecase.dart';
import 'package:ax_dapp/league/widgets/dialogs/edit_rules_dialog.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class LeagueGame extends StatelessWidget {
  const LeagueGame({
    super.key,
    required this.league,
    required this.leagueID,
  });

  final League league;
  final String leagueID;

  @override
  Widget build(BuildContext context) {
    final global = Global();
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final isWalletConnected =
        context.read<WalletBloc>().state.isWalletConnected;
    return global.buildPage(
      context,
      BlocBuilder<LeagueGameBloc, LeagueGameState>(
        buildWhen: (previous, current) {
          return current.status.name.isNotEmpty ||
              previous.selectedChain.chainId != current.selectedChain.chainId;
        },
        builder: (context, state) {
          final bloc = context.read<LeagueGameBloc>();
          final filteredAthletes = state.filteredAthletes;
          final userTeams = state.userTeams;
          final differenceInDays = state.differenceInDays;
          final differenceInHours = state.differenceInHours;
          final differenceInMinutes = state.differenceInMinutes;
          final differenceInSeconds = state.differenceInSeconds;
          final timerStatus = state.timerStatus;
          final athletes = state.athletes;
          final leagueTeams = state.leagueTeams;
          if (state.status == BlocStatus.scoutsLoaded) {
            bloc.add(FetchLeagueTeamsEvent(leagueID: leagueID));
          }
          if (state.status == BlocStatus.leaguesLoaded) {
            bloc.add(
              CalculateAppreciationEvent(
                leagueTeams: state.leagueTeams,
                athletes: filteredAthletes,
              ),
            );
            if (timerStatus.hasEnded && league.winner.isEmpty) {
              bloc.add(
                ProcessLeagueWinnerEvent(
                  leagueID: leagueID,
                  leagueTeams: leagueTeams,
                  athletes: filteredAthletes,
                ),
              );
            }
          }
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                margin: const EdgeInsets.only(top: 20),
                height: constraints.maxHeight * 0.85 + 41,
                width: constraints.maxWidth * 0.99,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.amber[400]!),
                          ),
                          child: TextButton(
                            onPressed: timerStatus.hasEnded
                                ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.transparent,
                                        content: Text(
                                          'The League Has Ended And Invite Links Are No Longer Available!',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontFamily: 'OpenSans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                : () {
                                    final gamePageLocation =
                                        GoRouter.of(context)
                                            .location
                                            .substring(1);
                                    final gamePageUrl =
                                        '$baseUrl$gamePageLocation';
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: gamePageUrl,
                                      ),
                                    ).then(
                                      (_) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.transparent,
                                          content: Text(
                                            'Copied Invite Link!',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontFamily: 'OpenSans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      ),
                                    );
                                  },
                            child: const Text(
                              'Invite',
                              style: TextStyle(
                                color: Colors.amber,
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (constraints.maxWidth > 800)
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  league.name,
                                  style: textStyle(
                                    Colors.amber[400]!,
                                    18,
                                    isBold: false,
                                    isUline: false,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${league.dateStart} - ${league.dateEnd}',
                                  style: textStyle(
                                    Colors.grey[400]!,
                                    14,
                                    isBold: false,
                                    isUline: false,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (timerStatus.isPending) ...[
                                  Text(
                                    '$differenceInDays Days $differenceInHours Hours $differenceInMinutes Minutes $differenceInSeconds Seconds Until ${league.name} Begins!',
                                    style: textStyle(
                                      Colors.grey[400]!,
                                      14,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                  ),
                                ] else if (timerStatus.hasStarted) ...[
                                  Text(
                                    '$differenceInDays Days $differenceInHours Hours $differenceInMinutes Minutes $differenceInSeconds Seconds Remaining',
                                    style: textStyle(
                                      Colors.grey[400]!,
                                      14,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    '${league.name} Has Ended!',
                                    style: textStyle(
                                      Colors.grey[400]!,
                                      14,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.amber[400]!),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (isWalletConnected) {
                                    var existingTeam = LeagueTeam.empty;
                                    for (final team in state.leagueTeams) {
                                      if (team.userWalletID == walletAddress) {
                                        existingTeam = team;
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (context) => BlocProvider(
                                          create: (context) => LeagueDraftBloc(
                                            athletes: athletes,
                                            leagueRepository: context
                                                .read<LeagueRepository>(),
                                            getTotalTokenBalanceUseCase:
                                                GetTotalTokenBalanceUseCase(
                                              walletRepository: context
                                                  .read<WalletRepository>(),
                                              tokensRepository: context
                                                  .read<TokensRepository>(),
                                            ),
                                            calculateTeamPerformanceUseCase:
                                                context.read<
                                                    CalculateTeamPerformanceUseCase>(),
                                            prizePoolRepository: context
                                                .read<PrizePoolRepository>(),
                                            streamAppDataChangesUseCase:
                                                context.read<
                                                    StreamAppDataChangesUseCase>(),
                                            walletRepository: context
                                                .read<WalletRepository>(),
                                          ),
                                          child: DesktopLeagueDraft(
                                            league: league,
                                            existingTeam: existingTeam,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    context.showWalletWarningToast();
                                  }
                                },
                                child: const Text(
                                  'Join League',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (league.adminWallet == "'$walletAddress'")
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.amber[400]!),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    if (timerStatus.hasStarted ||
                                        timerStatus.hasEnded) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.transparent,
                                          content: Text(
                                            'Cannot Edit League At This Time Because Either The League Has Started Or Ended',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontFamily: 'OpenSans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      showDialog<void>(
                                        context: context,
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: bloc,
                                          child: EditRulesDialog(
                                            league: league,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Edit League',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                    if (state.status == BlocStatus.loading) const Loader(),
                    SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: userTeams.length,
                        itemBuilder: (BuildContext context, int index) {
                          final userTeam = userTeams[index];
                          final rosters = userTeam.roster.entries.toList();
                          return ExpansionTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userTeam.address,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      getPercentageDesc(
                                        userTeam.teamPerformance,
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 16,
                                        color: getPercentageColor(
                                          userTeam.teamPerformance,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      getPercentStatusIcon(
                                        userTeam.teamPerformance,
                                      ),
                                      size: 50,
                                      color: getPercentageColor(
                                        userTeam.teamPerformance,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: userTeam.address == walletAddress,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      border:
                                          Border.all(color: Colors.amber[400]!),
                                    ),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Edit Teams',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontFamily: 'OpenSans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            expandedAlignment: Alignment.center,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            childrenPadding: const EdgeInsets.all(10),
                            children: [
                              Row(
                                children: rosters.map((athleteName) {
                                  return Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          getSportIcon(
                                            athletes.getAthleteSport(
                                              athleteName.key,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              athleteName.value[0],
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontFamily: 'OpenSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              athletes.getAthleteTeam(
                                                athleteName.key,
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontFamily: 'OpenSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ),
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.amber[400]!),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'CLAIM PRIZE',
                            style: TextStyle(
                              color: Colors.amber,
                              fontFamily: 'OpenSans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
