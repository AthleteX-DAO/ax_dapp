import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LeagueGame extends StatefulWidget {
  const LeagueGame({
    super.key,
    required this.league,
    required this.leagueID,
  });

  final League league;
  final String leagueID;

  @override
  State<LeagueGame> createState() => _LeagueGameState();
}

class _LeagueGameState extends State<LeagueGame> {
  EthereumChain? _selectedChain;

  @override
  Widget build(BuildContext context) {
    final global = Global();
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    return global.buildPage(
      context,
      BlocBuilder<LeagueGameBloc, LeagueGameState>(
        builder: (context, state) {
          final bloc = context.read<LeagueGameBloc>();
          if (_selectedChain != state.selectedChain) {
            _selectedChain = state.selectedChain;
            bloc.add(
              FetchScoutInfoRequested(),
            );
          }
          final userTeams = state.userTeams;
          final differenceInDays = state.differenceInDays;
          final differenceInHours = state.differenceInHours;
          final differenceInMinutes = state.differenceInMinutes;
          final differenceInSeconds = state.differenceInSeconds;
          final timerStatus = state.timerStatus;
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
                                  widget.league.name,
                                  style: textStyle(
                                    Colors.amber[400]!,
                                    18,
                                    isBold: false,
                                    isUline: false,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${widget.league.dateStart} - ${widget.league.dateEnd}',
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
                                    '$differenceInDays Days Until ${widget.league.name} Begins!',
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
                                    '${widget.league.name} Has Ended!',
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
                    if (state.status == BlocStatus.loading) const Loader(),
                    SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: userTeams.length,
                        itemBuilder: (BuildContext context, int index) {
                          final userTeam = userTeams[index];
                          final rosters = userTeam.roster.keys.toList();
                          return ExpansionTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(userTeam.address),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:
                                    rosters.map<Widget>(Text.new).toList(),
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
