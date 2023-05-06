import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/league_game/widgets/widgets.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/league/models/user_team.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final _width = MediaQuery.of(context).size.width;
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final formattedWalletAddress =
        context.select((WalletBloc bloc) => bloc.state.formattedWalletAddress);
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
          final timerStatus = state.timerStatus;
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
                    if (_width <= 768)
                      Column(
                        children: [
                          SizedBox(
                            child: LeagueTimerStatus(
                              league: league,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Invite(),
                              LeaveLeague(
                                league: league,
                                leagueID: leagueID,
                              ),
                              JoinLeague(league: league),
                              if (league.adminWallet == formattedWalletAddress)
                                EditLeague(league: league),
                            ],
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Invite(),
                              const SizedBox(
                                width: 5,
                              ),
                              LeaveLeague(
                                league: league,
                                leagueID: leagueID,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: (constraints.maxWidth > 768)
                                ? constraints.maxWidth * 0.5
                                : constraints.maxWidth * 0.4,
                            child: LeagueTimerStatus(
                              league: league,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              JoinLeague(league: league),
                              const SizedBox(
                                width: 5,
                              ),
                              if (league.adminWallet == formattedWalletAddress)
                                EditLeague(league: league),
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
                          final rosters = userTeam.rosters;
                          return LeagueTeamCards(
                            userTeam: userTeam,
                            rosters: rosters,
                            league: league,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ),
                    if (league.winner == walletAddress && timerStatus.hasEnded)
                      ClaimPrize(league: league),
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
