import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopLeagueDraft extends StatefulWidget {
  const DesktopLeagueDraft({
    super.key,
    required this.league,
    required this.athletes,
    // required this.leagueID,
  });

  final League league;
  final List<AthleteScoutModel> athletes;
  // final String leagueID;

  @override
  State<DesktopLeagueDraft> createState() => _DesktopLeagueDraftState();
}

class _DesktopLeagueDraftState extends State<DesktopLeagueDraft> {
  @override
  Widget build(BuildContext context) {
    final global = Global();
    //debugPrint(widget.athletes.toString());
    return global.buildPage(
      context,
      BlocBuilder<LeagueDraftBloc, LeagueDraftState>(
        builder: (context, state) {
          final bloc = context.read<LeagueDraftBloc>();
          final ownedApts = state.ownedApts;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              const textColor = Color(0xFFFEC500);
              const buttonColorBG = Color(0xFF3C3009);

              return Align(
                child: Container(
                  height: height * 0.85,
                  width: width * 0.90,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.league.name,
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
                                onPressed: () => {},
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
                              '${state.athleteCount} / ${widget.league.teamSize}',
                            ),
                          ],
                        ),
                      ),
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFF646464), width: 4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: const Placeholder(),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: const Placeholder(),
                              ),
                            ),
                          ],
                        ),
                      )
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
