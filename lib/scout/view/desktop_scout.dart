// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'package:ax_dapp/athlete/athlete.dart';
import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/buy_dialog.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class DesktopScout extends StatefulWidget {
  const DesktopScout({
    super.key,
    required this.goToTradePage,
    required this.goToPage,
  });

  final void Function() goToTradePage;
  final void Function(int page) goToPage;

  @override
  State<DesktopScout> createState() => _DesktopScoutState();
}

class _DesktopScoutState extends State<DesktopScout> {
  final myController = TextEditingController(text: input);
  static String input = '';
  bool athletePage = false;
  static bool isLongToken = true;
  static int sportState = 0;
  static SupportedSport _selectedSport = SupportedSport.all;
  String allSportsTitle = 'All Sports';
  String longTitle = 'Long';
  AthleteScoutModel? curAthlete;
  int _widgetIndex = 0;
  int _marketVsBookPriceIndex = 0;
  EthereumChain? _selectedChain;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    input = '';
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    const sportFilterIconSz = 14.0;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // breaks the code, will come back to it later(probably)

    return BlocBuilder<ScoutPageBloc, ScoutPageState>(
      buildWhen: (previous, current) {
        return current.status.name.isNotEmpty ||
            previous.selectedChain.chainId != current.selectedChain.chainId;
      },
      builder: (context, state) {
        final bloc = context.read<ScoutPageBloc>();
        final filteredAthletes = state.filteredAthletes;
        if (_selectedChain != state.selectedChain) {
          _selectedChain = state.selectedChain;
          bloc.add(FetchScoutInfoRequested());
        }
        _selectedSport = state.selectedSport;
        if (athletePage && curAthlete != null) {
          return BlocProvider(
            create: (context) => AthletePageBloc(
                walletRepository: context.read<WalletRepository>(),
                tokensRepository: context.read<TokensRepository>(),
                mlbRepo: RepositoryProvider.of<MLBRepo>(context),
                nflRepo: RepositoryProvider.of<NFLRepo>(context),
                athlete: curAthlete!,
                getScoutAthletesDataUseCase: GetScoutAthletesDataUseCase(
                  tokensRepository: context.read<TokensRepository>(),
                  graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                  sportsRepos: [
                    RepositoryProvider.of<MLBRepo>(context),
                    RepositoryProvider.of<NFLRepo>(context),
                  ],
                )),
            child: AthletePage(
              athlete: curAthlete!,
              goToTradePage: widget.goToTradePage,
              goToPage: widget.goToPage,
            ),
          );
        }
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            height: _height * 0.85 + 41,
            width: _width * 0.99,
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
                // APT Title & Sport Filter
                Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  width: _width * 1,
                  height: 40,
                  child: kIsWeb
                      ? buildFilterMenuWeb(
                          state,
                          bloc,
                          sportFilterTxSz,
                          _width,
                        )
                      : buildFilterMenu(
                          state,
                          bloc,
                          sportFilterTxSz,
                          sportFilterIconSz,
                        ),
                ),
                // List Headers
                buildListviewHeaders(),
                buildScoutView(state, filteredAthletes),
              ],
            ),
          ),
        );
      },
    );
  }

  Stack buildScoutView(
    ScoutPageState state,
    List<AthleteScoutModel> filteredAthletes,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (state.status == BlocStatus.loading) const Loader(),
        if (state.status == BlocStatus.error) const ScoutLoadingError(),
        if (state.status == BlocStatus.noData)
          FilterMenuError(
            selectedChain: _selectedChain,
          ),
        buildListview(state, filteredAthletes)
      ],
    );
  }

  Row buildFilterMenuWeb(
    ScoutPageState state,
    ScoutPageBloc bloc,
    double sportFilterTxSz,
    double _width,
  ) {
    return Row(
      children: [
        Text('APT List', style: textStyle(Colors.white, 18, false, false)),
        Text('|', style: textStyle(Colors.white, 18, false, false)),
        TextButton(
          onPressed: () {
            myController.clear();
            setState(() {
              _selectedSport = SupportedSport.all;
            });
            bloc.add(
              const SelectedSportChanged(selectedSport: SupportedSport.all),
            );
          },
          child: Text(
            'ALL',
            style: textSwapState(
              _selectedSport == SupportedSport.all,
              textStyle(Colors.white, sportFilterTxSz, false, false),
              textStyle(Colors.amber[400]!, sportFilterTxSz, false, true),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            myController.clear();
            setState(() {
              _selectedSport = SupportedSport.MLB;
            });
            bloc.add(
              const SelectedSportChanged(selectedSport: SupportedSport.MLB),
            );
          },
          child: Text(
            'MLB',
            style: textSwapState(
              _selectedSport == SupportedSport.MLB,
              textStyle(Colors.white, sportFilterTxSz, false, false),
              textStyle(Colors.amber[400]!, sportFilterTxSz, false, true),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            myController.clear();
            setState(() {
              _selectedSport = SupportedSport.NFL;
            });
            bloc.add(
              const SelectedSportChanged(selectedSport: SupportedSport.NFL),
            );
          },
          child: Text(
            'NFL',
            style: textSwapState(
              _selectedSport == SupportedSport.NFL,
              textStyle(Colors.white, sportFilterTxSz, false, false),
              textStyle(Colors.amber[400]!, sportFilterTxSz, false, true),
            ),
          ),
        ),
        const Spacer(),
        toggleTokenButton(800, 40),
        Container(width: 10),
        Container(
          child: createSearchBar(bloc, _selectedSport),
        ),
      ],
    );
  }

  IndexedStack buildFilterMenu(
    ScoutPageState state,
    ScoutPageBloc bloc,
    double sportFilterTxSz,
    double sportFilterIconSz,
  ) {
    return IndexedStack(
      index: _widgetIndex,
      children: [
        SizedBox(
          height: 20,
          child: Row(
            children: [
              Text(
                'APT List',
                style: textStyle(Colors.white, 18, false, false),
              ),
              Text('|', style: textStyle(Colors.white, 18, false, false)),
              SizedBox(
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'All Sports',
                              style: textSwapState(
                                sportState == 0,
                                textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  false,
                                  false,
                                ),
                                textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  false,
                                  true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        myController.clear();
                        if (sportState != 0) {
                          setState(() {
                            sportState = 0;
                          });
                        }
                        allSportsTitle = 'All Sports';
                      },
                    ),
                    PopupMenuItem(
                      height: 5,
                      value: 1,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.sports_football,
                                size: sportFilterIconSz,
                              ),
                            ),
                            Text(
                              'MLB',
                              style: textSwapState(
                                sportState == 1,
                                textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  false,
                                  false,
                                ),
                                textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  false,
                                  true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        myController.clear();
                        if (sportState != 1) {
                          setState(() {
                            sportState = 1;
                            allSportsTitle = 'MLB';
                          });
                        }
                      },
                    ),
                    PopupMenuItem(
                      height: 5,
                      value: 2,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.sports_football,
                                size: sportFilterIconSz,
                              ),
                            ),
                            Text(
                              'NFL',
                              style: textSwapState(
                                sportState == 2,
                                textStyle(
                                  Colors.white,
                                  sportFilterTxSz,
                                  false,
                                  false,
                                ),
                                textStyle(
                                  Colors.amber[400]!,
                                  sportFilterTxSz,
                                  false,
                                  true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        myController.clear();
                        if (sportState != 2) {
                          setState(() {
                            sportState = 2;
                            allSportsTitle = 'NFL';
                          });
                        }
                      },
                    ),
                  ],
                  offset: const Offset(0, 45),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        allSportsTitle,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Long'),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        longTitle = 'Long';
                      });
                    },
                  ),
                  PopupMenuItem(
                    height: 5,
                    value: 1,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Short'),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        longTitle = 'Short';
                      });
                    },
                  ),
                ],
                offset: const Offset(0, 45),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Text(
                      longTitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Align(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _widgetIndex = 1;
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    createSearchBar(bloc, _selectedSport),
                    const Spacer(),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _widgetIndex = 0;
                  });
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromRGBO(254, 197, 0, 1),
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildListviewHeaders() {
    final _width = MediaQuery.of(context).size.width;

    var team = true;
    if (_width < 684) team = false;

    var athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Container(
      child: kIsWeb
          ? Row(
              children: <Widget>[
                Container(width: 66),
                SizedBox(
                  width: athNameBx,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Athlete (Seasonal APT)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                if (team)
                  SizedBox(
                    width: _width * 0.12,
                    child: Text(
                      'Team',
                      style: textStyle(
                        Colors.grey[400]!,
                        12,
                        false,
                        false,
                      ),
                    ),
                  ),
                SizedBox(
                  width: _width * 0.18,
                  child: Text(
                    'Market Price / Change',
                    style: textStyle(Colors.grey[400]!, 10, false, false),
                  ),
                ),
                SizedBox(
                  width: _width * 0.12,
                  child: Text(
                    'Book Value / Change',
                    style: textStyle(Colors.grey[400]!, 10, false, false),
                  ),
                ),
              ],
            )
          : Row(
              children: <Widget>[
                Container(width: 66),
                SizedBox(
                  width: athNameBx,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Athlete',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                if (team)
                  SizedBox(
                    width: _width * 0.15,
                    child: Text(
                      'Team',
                      style: textStyle(
                        Colors.grey[400]!,
                        12,
                        false,
                        false,
                      ),
                    ),
                  ),
                IndexedStack(
                  index: _marketVsBookPriceIndex,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _marketVsBookPriceIndex = 1;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Align(
                            child: Text(
                              'Market Price',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: const Align(
                              child: Icon(
                                Icons.autorenew,
                                size: 10,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _marketVsBookPriceIndex = 0;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Book Value',
                            style: textStyle(
                              Colors.grey[400]!,
                              10,
                              false,
                              false,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: const Align(
                              child: Icon(
                                Icons.autorenew,
                                size: 10,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget buildListview(
    ScoutPageState state,
    List<AthleteScoutModel> filteredAthletes,
  ) {
    final _height = MediaQuery.of(context).size.height;
    final hgt = _height * 0.8 - 120;
    return SizedBox(
      height: hgt,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: filteredAthletes.length,
        itemBuilder: (context, index) {
          return kIsWeb
              ? createListCardsForWeb(filteredAthletes[index])
              : createListCardsForMobile(filteredAthletes[index]);
        },
      ),
    );
  }

  // Athlete Cards
  Widget createListCardsForMobile(AthleteScoutModel athlete) {
    final _width = MediaQuery.of(context).size.width;
    var view = true;
    var team = true;
    if (_width < 910) view = false;
    if (_width < 689) team = false;
    var athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            curAthlete = athlete;
            athletePage = true;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                AthleteDetailsWidget(athlete)
                    .athleteDetailsCardsForMobile(team, _width, athNameBx),
                // Market Price / Change
                IndexedStack(
                  index: _marketVsBookPriceIndex,
                  children: [
                    Row(
                      children: [
                        Text(
                          isLongToken
                              ? '${athlete.longTokenPrice!.toStringAsFixed(4)} AX'
                              : '${athlete.shortTokenPrice!.toStringAsFixed(4)} AX',
                          style: textStyle(Colors.white, 16, false, false),
                        ),
                        Container(width: 10),
                        Text(
                          isLongToken
                              ? getPercentageDesc(
                                  athlete.longTokenPercentage!,
                                )
                              : getPercentageDesc(
                                  athlete.shortTokenPercentage!,
                                ),
                          style: isLongToken
                              ? textStyle(
                                  getPercentageColor(
                                    athlete.longTokenPercentage!,
                                  ),
                                  12,
                                  false,
                                  false,
                                )
                              : textStyle(
                                  getPercentageColor(
                                    athlete.shortTokenPercentage!,
                                  ),
                                  12,
                                  false,
                                  false,
                                ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              isLongToken
                                  ? '${athlete.longTokenBookPrice!.toStringAsFixed(4)} AX'
                                  : '${athlete.shortTokenBookPrice!.toStringAsFixed(4)} AX',
                              style: textStyle(
                                Colors.white,
                                16,
                                false,
                                false,
                              ),
                            ),
                            Container(width: 10),
                            Text(
                              isLongToken
                                  ? getPercentageDesc(
                                      athlete.longTokenBookPricePercent!,
                                    )
                                  : getPercentageDesc(
                                      athlete.shortTokenBookPricePercent!,
                                    ),
                              style: isLongToken
                                  ? textStyle(
                                      getPercentageColor(
                                        athlete.longTokenBookPricePercent!,
                                      ),
                                      12,
                                      false,
                                      false,
                                    )
                                  : textStyle(
                                      getPercentageColor(
                                        athlete.shortTokenBookPricePercent!,
                                      ),
                                      12,
                                      false,
                                      false,
                                    ),
                            ),
                          ],
                        ),
                        Text(
                          isLongToken
                              ? '${athlete.longTokenBookPriceUsd!.toStringAsFixed(4)} AX'
                              : '${athlete.shortTokenPriceUsd!.toStringAsFixed(4)} AX',
                          style: textStyle(
                            Colors.amberAccent,
                            14,
                            false,
                            false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // Buy
                Container(
                  width: _width * 0.20,
                  height: 36,
                  decoration: boxDecoration(
                    const Color.fromRGBO(254, 197, 0, 0.2),
                    100,
                    0,
                    const Color.fromRGBO(254, 197, 0, 0.2),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final isWalletDisconnected =
                          context.read<WalletBloc>().state.isWalletDisconnected;
                      if (isWalletDisconnected) {
                        context.showWalletWarningToast();
                        return;
                      }
                      if (kIsWeb) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) => BuyDialogBloc(
                              walletRepository:
                                  context.read<WalletRepository>(),
                              streamAppDataChanges:
                                  context.read<StreamAppDataChangesUseCase>(),
                              tokensRepository:
                                  context.read<TokensRepository>(),
                              repo: RepositoryProvider.of<GetBuyInfoUseCase>(
                                context,
                              ),
                              wallet: GetTotalTokenBalanceUseCase(
                                walletRepository:
                                    context.read<WalletRepository>(),
                                tokensRepository:
                                    context.read<TokensRepository>(),
                              ),
                              swapController: Get.find(),
                              athleteId: athlete.id,
                            ),
                            child: BuyDialog(
                              athlete: athlete,
                              athleteName: athlete.name,
                              aptPrice: athlete.longTokenBookPrice!,
                              athleteId: athlete.id,
                              isLongApt: isLongToken,
                              goToTradePage: widget.goToTradePage,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          curAthlete = athlete;
                          athletePage = true;
                        });
                      }
                    },
                    child: Center(
                      child: buyText(),
                    ),
                  ),
                ),
                if (view) ...[
                  Container(width: 25),
                  // Mint
                  Container(
                    width: 100,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.transparent,
                      100,
                      2,
                      Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          curAthlete = athlete;
                          athletePage = true;
                        });
                      },
                      child: SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'View',
                              style: textStyle(
                                Colors.white,
                                16,
                                false,
                                false,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_right,
                              size: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget createListCardsForWeb(AthleteScoutModel athlete) {
    final _width = MediaQuery.of(context).size.width;

    var view = true;
    var team = true;
    if (_width < 910) view = false;
    if (_width < 689) team = false;
    var athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            curAthlete = athlete;
            athletePage = true;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                AthleteDetailsWidget(athlete)
                    .athleteDetailsCardsForWeb(team, _width, athNameBx),
                // Market Price / Change
                SizedBox(
                  width: _width * 0.18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Text(
                            isLongToken
                                ? '${athlete.longTokenPrice!.toStringAsFixed(4)} AX'
                                : '${athlete.shortTokenPrice!.toStringAsFixed(4)} AX',
                            style: textStyle(
                              Colors.white,
                              16,
                              false,
                              false,
                            ),
                          ),
                          Container(width: 10),
                          Text(
                            isLongToken
                                ? getPercentageDesc(
                                    athlete.longTokenPercentage!,
                                  )
                                : getPercentageDesc(
                                    athlete.shortTokenPercentage!,
                                  ),
                            style: isLongToken
                                ? textStyle(
                                    getPercentageColor(
                                      athlete.longTokenPercentage!,
                                    ),
                                    12,
                                    false,
                                    false,
                                  )
                                : textStyle(
                                    getPercentageColor(
                                      athlete.shortTokenPercentage!,
                                    ),
                                    12,
                                    false,
                                    false,
                                  ),
                          ),
                        ],
                      ),
                      Text(
                        isLongToken
                            ? r'$' +
                                athlete.longTokenPriceUsd!.toStringAsFixed(4)
                            : '\$${athlete.shortTokenPriceUsd!.toStringAsFixed(4)}',
                        style: textStyle(
                          Colors.amberAccent,
                          14,
                          false,
                          false,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          isLongToken
                              ? '${athlete.longTokenBookPrice!.toStringAsFixed(4)} AX'
                              : '${athlete.shortTokenBookPrice!.toStringAsFixed(4)}AX',
                          style: textStyle(
                            Colors.white,
                            16,
                            false,
                            false,
                          ),
                        ),
                        Container(width: 10),
                        Text(
                          isLongToken
                              ? getPercentageDesc(
                                  athlete.longTokenBookPricePercent!,
                                )
                              : getPercentageDesc(
                                  athlete.shortTokenBookPricePercent!,
                                ),
                          style: isLongToken
                              ? textStyle(
                                  getPercentageColor(
                                    athlete.longTokenBookPricePercent!,
                                  ),
                                  12,
                                  false,
                                  false,
                                )
                              : textStyle(
                                  getPercentageColor(
                                    athlete.shortTokenBookPricePercent!,
                                  ),
                                  12,
                                  false,
                                  false,
                                ),
                        ),
                      ],
                    ),
                    Text(
                      isLongToken
                          ? '\$${athlete.longTokenBookPriceUsd!.toStringAsFixed(4)}'
                          : '\$${athlete.shortTokenBookPriceUsd!.toStringAsFixed(4)}',
                      style: textStyle(
                        Colors.amberAccent,
                        14,
                        false,
                        false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                // Buy
                Container(
                  width: _width * 0.20,
                  height: 36,
                  decoration: boxDecoration(
                    const Color.fromRGBO(254, 197, 0, 0.2),
                    100,
                    0,
                    const Color.fromRGBO(254, 197, 0, 0.2),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final isWalletDisconnected =
                          context.read<WalletBloc>().state.isWalletDisconnected;
                      if (isWalletDisconnected) {
                        context.showWalletWarningToast();
                        return;
                      }
                      if (kIsWeb) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) => BuyDialogBloc(
                              walletRepository:
                                  context.read<WalletRepository>(),
                              streamAppDataChanges:
                                  context.read<StreamAppDataChangesUseCase>(),
                              tokensRepository:
                                  context.read<TokensRepository>(),
                              repo: RepositoryProvider.of<GetBuyInfoUseCase>(
                                context,
                              ),
                              wallet: GetTotalTokenBalanceUseCase(
                                walletRepository:
                                    context.read<WalletRepository>(),
                                tokensRepository:
                                    context.read<TokensRepository>(),
                              ),
                              swapController: Get.find(),
                              athleteId: athlete.id,
                            ),
                            child: BuyDialog(
                              athlete: athlete,
                              athleteName: athlete.name,
                              aptPrice: athlete.longTokenBookPrice!,
                              athleteId: athlete.id,
                              isLongApt: isLongToken,
                              goToTradePage: widget.goToTradePage,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          curAthlete = athlete;
                          athletePage = true;
                        });
                      }
                    },
                    child: Center(
                      child: buyText(),
                    ),
                  ),
                ),
                if (view) ...[
                  Container(width: 25),
                  // Mint
                  Container(
                    width: 100,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.transparent,
                      100,
                      2,
                      Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<TrackingCubit>()
                            .trackAthleteView(athleteName: athlete.name);
                        setState(() {
                          curAthlete = athlete;
                          athletePage = true;
                        });
                      },
                      child: SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'View',
                              style: textStyle(
                                Colors.white,
                                16,
                                false,
                                false,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_right,
                              size: 25,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buyText() {
    Widget textWidget;
    if (kIsWeb) {
      textWidget = Text(
        'Buy',
        style:
            textStyle(const Color.fromRGBO(254, 197, 0, 1), 12, false, false),
      );
    } else {
      textWidget = Text(
        'View',
        style:
            textStyle(const Color.fromRGBO(255, 198, 0, 1), 10, false, false),
      );
    }
    return textWidget;
  }

  Widget createSearchBar(ScoutPageBloc bloc, SupportedSport selectedSport) {
    final widthSize = MediaQuery.of(context).size.width;
    return Container(
      width: searchWidth(widthSize),
      height: 160,
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
          Container(width: 35),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                setState(() {
                  input = value;
                });
                bloc.add(
                  AthleteSearchChanged(
                    searchedName: value,
                    selectedSport: selectedSport,
                  ),
                );
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 8.5),
                hintText: 'Search an athlete',
                hintStyle: TextStyle(color: Color.fromRGBO(235, 235, 245, 0.6)),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-z. ]'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  double searchWidth(double widthSize) {
    double _width;
    if (kIsWeb) {
      _width = widthSize * 0.26;
    } else {
      _width = widthSize * 0.66;
    }
    return _width;
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    // ignore: curly_braces_in_flow_control_structures
    if (isBold) if (isUline) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.underline,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    }
    else if (isUline) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        decoration: TextDecoration.underline,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
    }
  }

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }

  BoxDecoration boxDecoration(
    Color col,
    double rad,
    double borWid,
    Color borCol,
  ) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(color: borCol, width: borWid),
    );
  }

  Container toggleTokenButton(double layoutWdt, double layoutHgt) {
    return Container(
      width: kIsWeb ? 250 : layoutWdt,
      height: 30,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: kIsWeb ? 115 : (layoutWdt / 2) - 5,
            height: 20,
            decoration: isLongToken
                ? boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent)
                : boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  ),
            child: TextButton(
              onPressed: () {
                if (!isLongToken) {
                  setState(() {
                    isLongToken = true;
                  });
                }
              },
              child: Text(
                'Long Token',
                style: textStyle(Colors.white, 14, true, false),
              ),
            ),
          ),
          Container(
            width: kIsWeb ? 115 : (layoutWdt / 2) - 5,
            height: 20,
            decoration: isLongToken
                ? boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  )
                : boxDecoration(
                    Colors.grey[600]!,
                    100,
                    0,
                    Colors.transparent,
                  ),
            child: TextButton(
              onPressed: () {
                if (isLongToken) {
                  setState(() {
                    isLongToken = false;
                  });
                }
              },
              child: Text(
                'Short Token',
                style: textStyle(Colors.white, 14, true, false),
              ),
            ),
          )
        ],
      ),
    );
  }
}
