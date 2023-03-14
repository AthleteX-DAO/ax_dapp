import 'package:ax_dapp/pages/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/pages/league/league_search/widgets/dialogs/rules_dialog.dart';
import 'package:ax_dapp/pages/league/league_search/widgets/league_card.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class DesktopLeague extends StatefulWidget {
  const DesktopLeague({super.key});

  @override
  State<DesktopLeague> createState() => _DesktopLeagueState();
}

class _DesktopLeagueState extends State<DesktopLeague> {
  final leagueSearchController = TextEditingController();
  var _selectedSport = SupportedSport.all;
  final sportFilterTxSz = 14.0;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: (constraints.maxWidth > 800)
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth - 610,
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-z. ]'),
                              )
                            ],
                            controller: leagueSearchController,
                            decoration: InputDecoration(
                              focusColor: Colors.grey[400],
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[400]!,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 20,
                                  color: Colors.grey[400]!,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              hintText: 'Search a League',
                            ),
                            onChanged: (value) {
                              bloc.add(
                                SearchLeague(
                                  input: value,
                                  selectedSport: _selectedSport,
                                ),
                              );
                            },
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
                              final isWalletDisconnected = context
                                  .read<WalletBloc>()
                                  .state
                                  .isWalletDisconnected;
                              if (isWalletDisconnected) {
                                context.showWalletWarningToast();
                                return;
                              }
                              showDialog<void>(
                                context: context,
                                builder: (context) => const LeagueDialog(),
                              );
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
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                      ),
                      height: 40,
                      child: Row(
                        children: [
                          Text(
                            'League List',
                            style: textStyle(
                              Colors.white,
                              18,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                          Text(
                            '|',
                            style: textStyle(
                              Colors.white,
                              18,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              leagueSearchController.clear();
                              setState(
                                () {
                                  _selectedSport = SupportedSport.all;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.all,
                                ),
                              );
                            },
                            child: Text(
                              'ALL',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.all,
                                tabNotSelected: textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: false,
                                ),
                                tabSelected: textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: true,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              leagueSearchController.clear();
                              setState(
                                () {
                                  _selectedSport = SupportedSport.MLB;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.MLB,
                                ),
                              );
                            },
                            child: Text(
                              'MLB',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.MLB,
                                tabNotSelected: textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: false,
                                ),
                                tabSelected: textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: true,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              leagueSearchController.clear();
                              setState(
                                () {
                                  _selectedSport = SupportedSport.NFL;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.NFL,
                                ),
                              );
                            },
                            child: Text(
                              'NFL',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.NFL,
                                tabNotSelected: textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: false,
                                ),
                                tabSelected: textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: true,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              leagueSearchController.clear();
                              setState(
                                () {
                                  _selectedSport = SupportedSport.NBA;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.NBA,
                                ),
                              );
                            },
                            child: Text(
                              'NBA',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.NBA,
                                tabNotSelected: textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: false,
                                ),
                                tabSelected: textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  isBold: false,
                                  isUline: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'League Name',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Start/End Date',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Entry Fee',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Prize Pool',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Info',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
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
