import 'package:ax_dapp/pages/league/bloc/league_bloc.dart';
import 'package:ax_dapp/pages/league/widgets/dialogs/rules_dialog.dart';
import 'package:ax_dapp/pages/league/widgets/league_card.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopLeague extends StatefulWidget {
  const DesktopLeague({super.key});

  @override
  State<DesktopLeague> createState() => _DesktopLeagueState();
}

class _DesktopLeagueState extends State<DesktopLeague> {
  final leagueSearchController = TextEditingController();

  @override
  void dispose() {
    leagueSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final global = Global();
    return global.buildPage(
      context,
      BlocBuilder<LeagueBloc, LeagueState>(
        builder: (context, state) {
          final bloc = context.read<LeagueBloc>();
          final filteredLeagues = state.filteredLeagues;
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
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: (constraints.maxWidth > 800)
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth - 610,
                          height: 50,
                          decoration: boxDecoration(
                            const Color.fromRGBO(118, 118, 128, 0.24),
                            20,
                            1,
                            const Color.fromRGBO(118, 118, 128, 0.24),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(width: 6),
                              const Icon(
                                Icons.search,
                                color: Color.fromRGBO(235, 235, 245, 0.6),
                                size: 20,
                              ),
                              const SizedBox(width: 35),
                              Expanded(
                                child: TextFormField(
                                  controller: leagueSearchController,
                                  onChanged: (value) {
                                    bloc.add(
                                      SearchLeague(
                                        input: value,
                                      ),
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(bottom: 8.5),
                                    hintText: 'Search a League',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(
                                        235,
                                        235,
                                        245,
                                        0.6,
                                      ),
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp('[a-zA-z. ]'),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.amber[400]!),
                          ),
                          child: TextButton(
                            onPressed: () => {
                              showDialog<void>(
                                context: context,
                                builder: (context) => const LeagueDialog(),
                              ),
                            },
                            child: const Text(
                              'Create a League',
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
                    SizedBox(
                      height: constraints.maxHeight * 0.8 - 120,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredLeagues.length,
                        itemBuilder: (context, index) {
                          return LeagueCard(
                            league: filteredLeagues[index],
                          );
                        },
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
