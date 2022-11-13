// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/buy_dialog.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/widgets/buy_text.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class DesktopScout extends StatefulWidget {
  const DesktopScout({
    super.key,
  });

  @override
  State<DesktopScout> createState() => _DesktopScoutState();
}

class _DesktopScoutState extends State<DesktopScout> {
  Global global = Global();
  final myController = TextEditingController(text: input);
  static String input = '';
  //bool athletePage = false;
  static bool isLongToken = true;
  static SupportedSport _selectedSport = SupportedSport.all;
  String allSportsTitle = 'All Sports';
  String longTitle = 'Long';
  EthereumChain? _selectedChain;
  String selectedAthlete = '';
  List<AthleteScoutModel> filteredAthletes = [];

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
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // breaks the code, will come back to it later(probably)

    return global.buildPage(
      context,
      BlocBuilder<ScoutPageBloc, ScoutPageState>(
        buildWhen: (previous, current) {
          return current.status.name.isNotEmpty ||
              previous.selectedChain.chainId != current.selectedChain.chainId;
        },
        builder: (context, state) {
          final bloc = context.read<ScoutPageBloc>();
          if (global.athleteList.isEmpty) {
            global.athleteList = state.athletes;
          }
          filteredAthletes = state.filteredAthletes;
          if (_selectedChain != state.selectedChain) {
            _selectedChain = state.selectedChain;
            bloc.add(
              FetchScoutInfoRequested(),
            );
          }
          _selectedSport = state.selectedSport;
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
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    width: _width * 1,
                    height: 40,
                    child: Row(
                      children: [
                        Text(
                          'APT List',
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
                            myController.clear();
                            setState(
                              () {
                                _selectedSport = SupportedSport.all;
                              },
                            );
                            context.read<ScoutPageBloc>().add(
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
                            myController.clear();
                            setState(
                              () {
                                _selectedSport = SupportedSport.MLB;
                              },
                            );
                            context.read<ScoutPageBloc>().add(
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
                            myController.clear();
                            setState(
                              () {
                                _selectedSport = SupportedSport.NFL;
                              },
                            );
                            context.read<ScoutPageBloc>().add(
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
                            myController.clear();
                            setState(
                              () {
                                _selectedSport = SupportedSport.NBA;
                              },
                            );
                            context.read<ScoutPageBloc>().add(
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
                        const Spacer(),
                        Container(
                          width: 250,
                          height: 30,
                          decoration: boxDecoration(
                            Colors.grey[900]!,
                            100,
                            1,
                            Colors.grey[400]!,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: 115,
                                height: 20,
                                decoration: isLongToken
                                    ? boxDecoration(
                                        Colors.grey[600]!,
                                        100,
                                        0,
                                        Colors.transparent,
                                      )
                                    : boxDecoration(
                                        Colors.transparent,
                                        100,
                                        0,
                                        Colors.transparent,
                                      ),
                                child: TextButton(
                                  onPressed: () {
                                    if (!isLongToken) {
                                      setState(
                                        () {
                                          isLongToken = true;
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Long Token',
                                    style: textStyle(
                                      Colors.white,
                                      14,
                                      isBold: true,
                                      isUline: false,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 115,
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
                                      setState(
                                        () {
                                          isLongToken = false;
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Short Token',
                                    style: textStyle(
                                      Colors.white,
                                      14,
                                      isBold: true,
                                      isUline: false,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(width: 10),
                        // Search Bar
                        Container(
                          width: _width * 0.26,
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
                                    setState(
                                      () {
                                        input = value;
                                      },
                                    );
                                    context.read<ScoutPageBloc>().add(
                                          AthleteSearchChanged(
                                            searchedName: value,
                                            selectedSport: _selectedSport,
                                          ),
                                        );
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(bottom: 8.5),
                                    hintText: 'Search an athlete',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(
                                        235,
                                        235,
                                        245,
                                        0.6,
                                      ),
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
                      ],
                    ),
                  ),
                  // List Headers
                  // BuildListViewHeader
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(width: 66),
                        SizedBox(
                          width: (_width < 685) ? 107 : _width * 0.15,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Athlete (Seasonal APT)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        if (_width >= 684)
                          SizedBox(
                            width: _width * 0.12,
                            child: Text(
                              'Team',
                              style: textStyle(
                                Colors.grey[400]!,
                                12,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: _width * 0.18,
                          child: Text(
                            'Market Price / Change',
                            style: textStyle(
                              Colors.grey[400]!,
                              10,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: _width * 0.12,
                          child: Text(
                            'Book Value / Change',
                            style: textStyle(
                              Colors.grey[400]!,
                              10,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //BuildScoutView
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.status == BlocStatus.loading) const Loader(),
                      if (state.status == BlocStatus.error)
                        const ScoutLoadingError(),
                      if (state.status == BlocStatus.noData)
                        FilterMenuError(
                          selectedChain: _selectedChain,
                        ),
                      if (state.status == BlocStatus.success &&
                          filteredAthletes.isEmpty)
                        const NoResultFound(),
                      SizedBox(
                        height: _height * 0.8 - 120,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredAthletes.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 70,
                              child: OutlinedButton(
                                onPressed: () {
                                  final walletAddress = context
                                      .read<WalletBloc>()
                                      .state
                                      .formattedWalletAddress;
                                  context
                                      .read<TrackingCubit>()
                                      .trackAthleteView(
                                        athleteName:
                                            filteredAthletes[index].name,
                                        walletId: walletAddress,
                                      );
                                  setState(
                                    () {
                                      global.athleteList = filteredAthletes;
                                      selectedAthlete = filteredAthletes[index]
                                              .id
                                              .toString() +
                                          filteredAthletes[index].name;
                                      context.goNamed(
                                        'athlete',
                                        params: {'id': selectedAthlete},
                                      );
                                      //athletePage = true;
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        AthleteDetailsWidget(
                                          filteredAthletes[index],
                                        ).athleteDetailsCardsForWeb(
                                          _width >= 689,
                                          _width,
                                          _width >= 685 ? _width * 0.15 : 107,
                                        ),
                                        // Market Price / Change
                                        SizedBox(
                                          width: _width * 0.18,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    isLongToken
                                                        ? '${filteredAthletes[index].longTokenPrice!.toStringAsFixed(4)} AX'
                                                        : '${filteredAthletes[index].shortTokenPrice!.toStringAsFixed(4)} AX',
                                                    style: textStyle(
                                                      Colors.white,
                                                      16,
                                                      isBold: false,
                                                      isUline: false,
                                                    ),
                                                  ),
                                                  Container(width: 10),
                                                  Text(
                                                    isLongToken
                                                        ? getPercentageDesc(
                                                            filteredAthletes[
                                                                    index]
                                                                .longTokenPercentage!,
                                                          )
                                                        : getPercentageDesc(
                                                            filteredAthletes[
                                                                    index]
                                                                .shortTokenPercentage!,
                                                          ),
                                                    style: isLongToken
                                                        ? textStyle(
                                                            getPercentageColor(
                                                              filteredAthletes[
                                                                      index]
                                                                  .longTokenPercentage!,
                                                            ),
                                                            12,
                                                            isBold: false,
                                                            isUline: false,
                                                          )
                                                        : textStyle(
                                                            getPercentageColor(
                                                              filteredAthletes[
                                                                      index]
                                                                  .shortTokenPercentage!,
                                                            ),
                                                            12,
                                                            isBold: false,
                                                            isUline: false,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                isLongToken
                                                    ? r'$' +
                                                        filteredAthletes[index]
                                                            .longTokenPriceUsd!
                                                            .toStringAsFixed(
                                                              4,
                                                            )
                                                    : '\$${filteredAthletes[index].shortTokenPriceUsd!.toStringAsFixed(4)}',
                                                style: textStyle(
                                                  Colors.amberAccent,
                                                  14,
                                                  isBold: false,
                                                  isUline: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  isLongToken
                                                      ? '${filteredAthletes[index].longTokenBookPrice!.toStringAsFixed(4)} AX'
                                                      : '${filteredAthletes[index].shortTokenBookPrice!.toStringAsFixed(4)}AX',
                                                  style: textStyle(
                                                    Colors.white,
                                                    16,
                                                    isBold: false,
                                                    isUline: false,
                                                  ),
                                                ),
                                                Container(width: 10),
                                                Text(
                                                  isLongToken
                                                      ? getPercentageDesc(
                                                          filteredAthletes[
                                                                  index]
                                                              .longTokenBookPricePercent!,
                                                        )
                                                      : getPercentageDesc(
                                                          filteredAthletes[
                                                                  index]
                                                              .shortTokenBookPricePercent!,
                                                        ),
                                                  style: isLongToken
                                                      ? textStyle(
                                                          getPercentageColor(
                                                            filteredAthletes[
                                                                    index]
                                                                .longTokenBookPricePercent!,
                                                          ),
                                                          12,
                                                          isBold: false,
                                                          isUline: false,
                                                        )
                                                      : textStyle(
                                                          getPercentageColor(
                                                            filteredAthletes[
                                                                    index]
                                                                .shortTokenBookPricePercent!,
                                                          ),
                                                          12,
                                                          isBold: false,
                                                          isUline: false,
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              isLongToken
                                                  ? '\$${filteredAthletes[index].longTokenBookPriceUsd!.toStringAsFixed(4)}'
                                                  : '\$${filteredAthletes[index].shortTokenBookPriceUsd!.toStringAsFixed(4)}',
                                              style: textStyle(
                                                Colors.amberAccent,
                                                14,
                                                isBold: false,
                                                isUline: false,
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
                                            const Color.fromRGBO(
                                              254,
                                              197,
                                              0,
                                              0.2,
                                            ),
                                            100,
                                            0,
                                            const Color.fromRGBO(
                                              254,
                                              197,
                                              0,
                                              0.2,
                                            ),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              final isWalletDisconnected =
                                                  context
                                                      .read<WalletBloc>()
                                                      .state
                                                      .isWalletDisconnected;
                                              if (isWalletDisconnected) {
                                                context
                                                    .showWalletWarningToast();
                                                return;
                                              }
                                              showDialog<void>(
                                                context: context,
                                                builder: (
                                                  BuildContext context,
                                                ) =>
                                                    BlocProvider(
                                                  create: (
                                                    BuildContext context,
                                                  ) =>
                                                      BuyDialogBloc(
                                                    walletRepository:
                                                        context.read<
                                                            WalletRepository>(),
                                                    streamAppDataChanges:
                                                        context.read<
                                                            StreamAppDataChangesUseCase>(),
                                                    tokensRepository:
                                                        context.read<
                                                            TokensRepository>(),
                                                    repo: RepositoryProvider.of<
                                                        GetBuyInfoUseCase>(
                                                      context,
                                                    ),
                                                    wallet:
                                                        GetTotalTokenBalanceUseCase(
                                                      walletRepository:
                                                          context.read<
                                                              WalletRepository>(),
                                                      tokensRepository:
                                                          context.read<
                                                              TokensRepository>(),
                                                    ),
                                                    swapController: Get.find(),
                                                    athleteId:
                                                        filteredAthletes[index]
                                                            .id,
                                                  ),
                                                  child: BuyDialog(
                                                    athlete:
                                                        filteredAthletes[index],
                                                    athleteName:
                                                        filteredAthletes[index]
                                                            .name,
                                                    aptPrice: filteredAthletes[
                                                            index]
                                                        .longTokenBookPrice!,
                                                    athleteId:
                                                        filteredAthletes[index]
                                                            .id,
                                                    isLongApt: isLongToken,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const BuyText(),
                                          ),
                                        ),
                                        if (_width >= 910) ...[
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
                                                final walletAddress = context
                                                    .read<WalletBloc>()
                                                    .state
                                                    .formattedWalletAddress;
                                                context
                                                    .read<TrackingCubit>()
                                                    .trackAthleteView(
                                                      athleteName:
                                                          filteredAthletes[
                                                                  index]
                                                              .name,
                                                      walletId: walletAddress,
                                                    );
                                                setState(
                                                  () {
                                                    global.athleteList =
                                                        filteredAthletes;
                                                    selectedAthlete =
                                                        filteredAthletes[index]
                                                                .id
                                                                .toString() +
                                                            filteredAthletes[
                                                                    index]
                                                                .name;
                                                    context.goNamed(
                                                      'athlete',
                                                      params: {
                                                        'id': selectedAthlete
                                                      },
                                                    );
                                                    //athletePage = true;
                                                  },
                                                );
                                              },
                                              child: SizedBox(
                                                width: 60,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Text(
                                                      'View',
                                                      style: textStyle(
                                                        Colors.white,
                                                        16,
                                                        isBold: false,
                                                        isUline: false,
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
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
