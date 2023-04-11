import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_draft/widgets/league_draft_apt_card.dart';
import 'package:ax_dapp/league/league_draft/widgets/league_draft_team_card.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DesktopLeagueDraft extends StatelessWidget {
  const DesktopLeagueDraft({
    super.key,
    required this.league,
  });

  final League league;

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
    return global.buildPage(
      context,
      BlocBuilder<LeagueDraftBloc, LeagueDraftState>(
        builder: (context, state) {
          final bloc = context.read<LeagueDraftBloc>();
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              const textColor = Color(0xFFFEC500);
              const buttonColorBG = Color(0xFF3C3009);

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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            league.name,
                            style: const TextStyle(
                              color: textColor,
                              fontFamily: 'OpenSans',
                              fontSize: 36,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: buttonColorBG,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextButton(
                                onPressed: () => {context.goNamed('scout')},
                                child: const Text(
                                  'Go Buy APTs',
                                  style: TextStyle(
                                    color: textColor,
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
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Athlete (Seasonal APT)'),
                            const Text('Book Value / Change'),
                            const Text('My Team'),
                            Text(
                              '${state.athleteCount} / ${league.teamSize}',
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  child: state.status == BlocStatus.loading
                                      ? const Loader()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: ownedApts.length,
                                          itemBuilder: (context, index) {
                                            return APTCard(
                                              apt: ownedApts[index],
                                              teamSize: league.teamSize,
                                            );
                                          },
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: myAptTeam.length,
                                    itemBuilder: (context, index) {
                                      return MyTeamCard(
                                        apt: myAptTeam[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: width / 5),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: buttonColorBG,
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
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'OpenSans',
                                    fontSize: 16,
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
