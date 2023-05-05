import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_draft/views/desktop_league_draft.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/league/models/user_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/calculate_team_performance_usecase.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class LeagueTeamCards extends StatelessWidget {
  const LeagueTeamCards({
    super.key,
    required this.userTeam,
    required this.rosters,
    required this.league,
  });

  final UserTeam userTeam;
  final List<MapEntry<int, List<String>>> rosters;
  final League league;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final athletes =
        context.select((LeagueGameBloc bloc) => bloc.state.athletes);
    final leagueTeams =
        context.select((LeagueGameBloc bloc) => bloc.state.leagueTeams);
    final timerStatus =
        context.select((LeagueGameBloc bloc) => bloc.state.timerStatus);
    var formattedWalletAddress = '';
    var iconSize = 16.0;
    var textSize = 16.0;
    var percentageStatusIcon = 50.0;
    if (userTeam.address.isNotEmpty) {
      final walletAddressPrefix = userTeam.address.substring(0, 7);
      final walletAddressSuffix = userTeam.address.substring(
        userTeam.address.length - 5,
        userTeam.address.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }
    if (_width < 800) {
      iconSize = 12.0;
      textSize = 12.0;
      percentageStatusIcon = 25.0;
    }
    return ExpansionTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _width <= 800 ? formattedWalletAddress : userTeam.address,
            style: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'OpenSans',
              fontSize: textSize,
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
                  fontSize: textSize,
                  color: getPercentageColor(
                    userTeam.teamPerformance,
                  ),
                ),
              ),
              Icon(
                getPercentStatusIcon(
                  userTeam.teamPerformance,
                ),
                size: percentageStatusIcon,
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
                border: Border.all(color: Colors.amber[400]!),
              ),
              child: TextButton(
                onPressed: league.isLocked && timerStatus.hasStarted
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.transparent,
                            content: Text(
                              'Cannot Edit Teams At This Time!',
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
                        final existingTeam = leagueTeams.firstWhere(
                          (team) => team.userWalletID == walletAddress,
                          orElse: () => LeagueTeam.empty,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => BlocProvider(
                              create: (context) => LeagueDraftBloc(
                                athletes: athletes,
                                leagueRepository:
                                    context.read<LeagueRepository>(),
                                getTotalTokenBalanceUseCase:
                                    GetTotalTokenBalanceUseCase(
                                  walletRepository:
                                      context.read<WalletRepository>(),
                                  tokensRepository:
                                      context.read<TokensRepository>(),
                                ),
                                calculateTeamPerformanceUseCase: context
                                    .read<CalculateTeamPerformanceUseCase>(),
                                prizePoolRepository:
                                    context.read<PrizePoolRepository>(),
                                streamAppDataChangesUseCase:
                                    context.read<StreamAppDataChangesUseCase>(),
                                walletRepository:
                                    context.read<WalletRepository>(),
                                isEditing: true,
                                leagueTeam: existingTeam,
                              ),
                              child: DesktopLeagueDraft(
                                league: league,
                                existingTeam: existingTeam,
                              ),
                            ),
                          ),
                        );
                      },
                child: Text(
                  'Edit Teams',
                  style: TextStyle(
                    color: Colors.amber,
                    fontFamily: 'OpenSans',
                    fontSize: textSize,
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
      children: _width <= 800
          ? rosters.map((athleteName) {
              return Row(
                children: [
                  Icon(
                    getSportIcon(
                      athletes.getAthleteSport(
                        athleteName.key,
                      ),
                    ),
                    size: iconSize,
                  ),
                  const Spacer(),
                  Text(
                    athleteName.value[0],
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    athletes.getAthleteTeam(
                      athleteName.key,
                    ),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'OpenSans',
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList()
          : [
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
                          size: iconSize,
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
                                fontSize: textSize,
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
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
    );
  }
}
