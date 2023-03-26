import 'package:ax_dapp/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/league/league_search/widgets/dialogs/rules_dialog.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeagueGame extends StatefulWidget {
  const LeagueGame({
    super.key,
  });

  @override
  State<LeagueGame> createState() => _LeagueGameState();
}

class _LeagueGameState extends State<LeagueGame> {
  final leagueSearchController = TextEditingController();
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> appreciation = <int>[12, 4, -3];
  //final leagueIndex = state.allLeagues;
  //final WalletiD = state.allLeagues;

  @override
  Widget build(BuildContext context) {
    final global = Global();
    return global.buildPage(
      context,
      BlocBuilder<LeagueBloc, LeagueState>(
        builder: (context, state) {
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
                              'MY FIRST LEAGUE',
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
                            onPressed: () {
                              // context.goNamed('Name of class');
                            }, //Steven
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
                        itemCount: entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  SizedBox(width: 25),
                                  Text(
                                    'User ${entries[index]}',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 800),
                                  Text(
                                    '\n Appereciation ${appreciation[index]}%\n',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
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
