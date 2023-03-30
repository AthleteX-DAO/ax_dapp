import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
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
    final athleteList = context.watch<ScoutPageBloc>().state.athletes;
    final global = Global();
    return global.buildPage(
      context,
      BlocBuilder<LeagueGameBloc, LeagueGameState>(
        builder: (context, state) {
          final bloc = context.read<LeagueGameBloc>();
          if (state.status == BlocStatus.initial) {
            bloc.add(
              CalculateAppreciationEvent(
                rosters: league.rosters,
                athletes: athleteList,
              ),
            );
          }
          final userTeams = state.userTeams;
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
                            onPressed: () {},
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
                            child: Text(
                              league.name,
                              style: textStyle(
                                Colors.amber[400]!,
                                18,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.amber[400]!),
                          ),
                          child: TextButton(
                            onPressed: () {},
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
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: userTeams.length,
                        itemBuilder: (BuildContext context, int index) {
                          final userTeam = userTeams[index];
                          return Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(userTeam.address),
                                Text('${userTeam.teamPerformance} %'),
                              ],
                            ),
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
