import 'package:ax_dapp/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/league/league_search/widgets/dialogs/rules_dialog.dart';

import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class myLeague extends StatefulWidget {
  const myLeague({super.key});

  @override
  State<myLeague> createState() => _myLeagueState();
}

class _myLeagueState extends State<myLeague> {
  final leagueSearchController = TextEditingController();

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
                            onPressed: () {},
                            child: const Text(
                              'Join a League',
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
                      height: constraints.maxHeight * 0.15 - 41,
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
