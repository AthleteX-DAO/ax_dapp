import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_draft/widgets/league_draft_apt_card.dart';
import 'package:ax_dapp/league/league_draft/widgets/league_draft_team_card.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:league_repository/league_repository.dart';

class DesktopLeagueDraft extends StatelessWidget {
  const DesktopLeagueDraft({
    super.key,
    required this.league,
    required this.existingTeam,
  });

  final League league;
  final LeagueTeam existingTeam;

  @override
  Widget build(BuildContext context) {
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final isWalletConnected =
        context.read<WalletBloc>().state.isWalletConnected;
    final ownedApts =
        context.select((LeagueDraftBloc bloc) => bloc.state.ownedApts);
    final myAptTeam =
        context.select((LeagueDraftBloc bloc) => bloc.state.myAptTeam);
    final global = Global();
    var textSize = 16.0;
    var leagueHeaderTextSize = 36.0;
    var verticalView = true;
    var athleteColumnTitle = 'Athlete (Seasonal APT)';
    var bookValueTitle = 'Book Value / Change';
    const athleteHeadingWR = 0.22;
    const bookValueHeadingWR = 0.1;
    const myTeamHeadingWR = 0.35;
    const athleteCountHeadingWR = 0.153;
    return global.buildPage(
      context,
      BlocBuilder<LeagueDraftBloc, LeagueDraftState>(
        builder: (context, state) {
          final bloc = context.read<LeagueDraftBloc>();
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              if (width <= 768) {
                textSize = 12.0;
                leagueHeaderTextSize = 18.0;
                verticalView = false;
                athleteColumnTitle = 'Athlete';
                bookValueTitle = 'Book Value';
              }
              return Align(
                child: Container(
                  height: height * 0.75,
                  width: width * 0.90,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 70,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            league.name,
                            style: TextStyle(
                              color: const Color(0xFFFEC500),
                              fontFamily: 'OpenSans',
                              fontSize: leagueHeaderTextSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(color: Colors.amber[400]!),
                                  ),
                                ),
                              ),
                              onPressed: () => {context.goNamed('scout')},
                              child: Text(
                                'Go Buy APTs',
                                style: TextStyle(
                                  color: const Color(0xFFFEC500),
                                  fontFamily: 'OpenSans',
                                  fontSize: textSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: verticalView
                            ? const EdgeInsets.symmetric(horizontal: 30)
                            : EdgeInsets.zero,
                        child: Row(
                          children: [
                            FittedBox(
                              child: SizedBox(
                                width: width * athleteHeadingWR,
                                child: Text(
                                  athleteColumnTitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: textSize),
                                ),
                              ),
                            ),
                            FittedBox(
                              child: SizedBox(
                                width: width * bookValueHeadingWR,
                                child: Text(
                                  bookValueTitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: textSize),
                                ),
                              ),
                            ),
                            FittedBox(
                              child: SizedBox(
                                width: width * myTeamHeadingWR,
                                child: Text(
                                  'My Team',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: textSize),
                                ),
                              ),
                            ),
                            FittedBox(
                              child: SizedBox(
                                width: width * athleteCountHeadingWR,
                                child: Text(
                                  '${state.athleteCount} / ${league.teamSize}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: textSize),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFF646464),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Flex(
                            direction:
                                verticalView ? Axis.horizontal : Axis.vertical,
                            children: [
                              Expanded(
                                child: Material(
                                  child: state.status == BlocStatus.loading
                                      ? const Loader()
                                      : Align(
                                          alignment: Alignment.topCenter,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            itemCount: ownedApts.length,
                                            itemBuilder: (context, index) {
                                              return APTCard(
                                                apt: ownedApts[index],
                                                teamSize: league.teamSize,
                                                height: height,
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                              if (verticalView)
                                const VerticalDivider()
                              else
                                const Divider(
                                  thickness: 3,
                                ),
                              Expanded(
                                child: Material(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: myAptTeam.length,
                                      itemBuilder: (context, index) {
                                        return MyTeamCard(
                                          apt: myAptTeam[index],
                                          height: height,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: verticalView
                            ? Alignment.centerRight
                            : Alignment.center,
                        child: Padding(
                          padding: verticalView
                              ? EdgeInsets.only(right: width / 5)
                              : EdgeInsets.zero,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3C3009),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextButton(
                                onPressed: () {
                                  if (isWalletConnected &&
                                      myAptTeam.isNotEmpty) {
                                    bloc.add(
                                      ConfirmTeam(
                                        walletAddress: walletAddress,
                                        leagueID: league.leagueID,
                                        myTeam: myAptTeam,
                                        existingTeam: existingTeam,
                                        prizePoolAddress:
                                            league.prizePoolAddress,
                                        entryFee: league.entryFee,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (myAptTeam.isEmpty) {
                                    context.showWarningToast(
                                      title: 'No Athletes Selected!',
                                      description:
                                          'Please Add Athletes Before Entering A League!',
                                    );
                                  } else {
                                    context.showWalletWarningToast();
                                  }
                                },
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: const Color(0xFFFEC500),
                                    fontFamily: 'OpenSans',
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
