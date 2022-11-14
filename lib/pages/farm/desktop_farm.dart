import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/pages/farm/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopFarm extends StatefulWidget {
  const DesktopFarm({super.key});

  @override
  State<DesktopFarm> createState() => _DesktopFarmState();
}

class _DesktopFarmState extends State<DesktopFarm> {
  Global global = Global();
  final myController = TextEditingController();
  bool isWeb = true;
  bool isAllFarms = true;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var layoutHgt = _height * 0.8;
    final layoutWdt = _width * 0.95;
    if (_height < 445) layoutHgt = _height;
    var listHeight = (isWeb && isAllFarms) ? 225.0 : layoutHgt * 0.80;
    //If web and in MyFarms list height 500
    if (isWeb && !isAllFarms) listHeight = 500.0;

    return global.buildPage(
      context,
      Container(
        width: _width,
        height: _height - AppBar().preferredSize.height,
        margin: isWeb
            ? EdgeInsets.zero
            : EdgeInsets.only(top: AppBar().preferredSize.height + 10),
        alignment: Alignment.center,
        child: SizedBox(
          //outermost dimensions for farm section
          width: layoutWdt,
          height: layoutHgt,
          // child:  FarmLayout(layoutHgt, layoutWdt),
          child: BlocListener<WalletBloc, WalletState>(
            listener: (context, state) {
              if (state.isWalletConnected || state.isWalletDisconnected) {
                context.read<FarmBloc>().add(WatchAppDataChangesStarted());
              }
              if (state.isWalletUnavailable) {
                debugPrint(
                  'Wallet is unavailable -> ${state.isWalletUnavailable}',
                );
              }
              if (state.isWalletUnsupported) {
                debugPrint(
                  'wallet is not supported -> ${state.isWalletUnsupported}',
                );
              }
            },
            child: BlocBuilder<FarmBloc, FarmState>(
              buildWhen: (previous, current) {
                debugPrint(
                  'Farm Bloc Builder buildWhen current status: ${current.status}, previous status: ${previous.status}',
                );
                return previous != current;
              },
              builder: (context, state) {
                final bloc = context.read<FarmBloc>();
                Widget widget = const Loader();
                if (state.status == BlocStatus.error) {
                  context.showWarningToast(
                    title: 'Action Error',
                    description: 'Something went wrong',
                  );
                }
                if (state.status == BlocStatus.error ||
                    state.status == BlocStatus.noData) {
                  widget = const NoData();
                }
                if (!state.isAllFarms && state.status == BlocStatus.noWallet) {
                  widget = const NoWallet();
                }
                if (state.status == BlocStatus.unsupportedChain) {
                  widget = UnsupportedChain(chain: state.chain);
                }
                final Widget toggle = ToggleFarmButton(
                  layoutWidth: layoutWdt,
                  layoutHeight: layoutHgt,
                  myController: myController,
                );
                return Wrap(
                  runSpacing: layoutHgt * 0.02,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Row(
                      mainAxisAlignment: isWeb
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Text(
                            isAllFarms ? 'Participating Farms' : 'My Farms',
                            style: isWeb
                                ? textStyle(
                                    Colors.white,
                                    24,
                                    isBold: true,
                                    isUline: false,
                                  )
                                : textStyle(
                                    Colors.white,
                                    20,
                                    isBold: true,
                                    isUline: false,
                                  ),
                          ),
                        ),
                        if (!isWeb) createSearchBar(bloc, layoutWdt, layoutHgt),
                      ],
                    ),
                    if (isWeb)
                      Row(
                        children: [
                          createSearchBar(bloc, layoutWdt, layoutHgt),
                          const SizedBox(width: 50),
                          toggle
                        ],
                      ),
                    if (!isWeb) toggle,
                    SizedBox(
                      //contains list of allfarms cards
                      width: layoutWdt,
                      height: layoutHgt - 120,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.touch,
                          },
                        ),
                        child: state.status != BlocStatus.success
                            ? widget
                            : (state.isAllFarms
                                    ? state.filteredFarms.isEmpty
                                    : state.filteredStakedFarms.isEmpty)
                                ? const NoData()
                                : GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isWeb && _width > 1700
                                          ? 4
                                          : isWeb
                                              ? 3
                                              : 1,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio:
                                          state.isAllFarms ? 1.75 : 1,
                                    ),
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: isAllFarms
                                        ? state.filteredFarms.length
                                        : state.filteredStakedFarms.length,
                                    itemBuilder: (context, index) {
                                      return isAllFarms
                                          ? FarmItem(
                                              farm: FarmController(
                                                farm:
                                                    state.filteredFarms[index],
                                                walletRepository: context
                                                    .read<FarmBloc>()
                                                    .walletRepository,
                                                tokensRepository: context
                                                    .read<FarmBloc>()
                                                    .tokensRepository,
                                                configRepository: context
                                                    .read<FarmBloc>()
                                                    .configRepository,
                                                streamAppDataChanges: context
                                                    .read<FarmBloc>()
                                                    .streamAppDataChanges,
                                              ),
                                              listHeight: listHeight,
                                              layoutWdt: layoutWdt,
                                            )
                                          : MyFarmItem(
                                              farm: FarmController(
                                                farm: state
                                                    .filteredStakedFarms[index],
                                                walletRepository: context
                                                    .read<FarmBloc>()
                                                    .walletRepository,
                                                tokensRepository: context
                                                    .read<FarmBloc>()
                                                    .tokensRepository,
                                                configRepository: context
                                                    .read<FarmBloc>()
                                                    .configRepository,
                                                streamAppDataChanges: context
                                                    .read<FarmBloc>()
                                                    .streamAppDataChanges,
                                              ),
                                              listHeight: listHeight,
                                              layoutWidth: layoutWdt,
                                            );
                                    },
                                  ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget createSearchBar(FarmBloc bloc, double layoutWdt, double layoutHgt) {
    final isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    if (isWebMobile) {
      return MobileSearchBar(
        isWeb: isWeb,
        myController: myController,
        layoutHgt: layoutHgt,
        layoutWdt: layoutWdt,
        bloc: bloc,
      );
    } else {
      return WebSearchBar(
        isWeb: isWeb,
        myController: myController,
        layoutHgt: layoutHgt,
        layoutWdt: layoutWdt,
        bloc: bloc,
      );
    }
  }
}

class ToggleFarmButton extends StatelessWidget {
  const ToggleFarmButton({
    super.key,
    required this.layoutWidth,
    required this.layoutHeight,
    required TextEditingController myController,
  }) : _farmTextController = myController;

  final double layoutWidth;
  final double layoutHeight;
  final TextEditingController _farmTextController;

  @override
  Widget build(BuildContext context) {
    final isAllFarmsSelection =
        context.select((FarmBloc bloc) => bloc.state.isAllFarms);
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return Container(
      width: isWeb ? 200 : layoutWidth,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: isWeb ? 90 : (layoutWidth / 2) - 5,
            decoration: isAllFarmsSelection
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
                if (!isAllFarmsSelection) {
                  _farmTextController.clear();
                  context
                      .read<FarmBloc>()
                      .add(OnChangeFarmTab(isAllFarms: true));
                }
              },
              child: Text(
                'All Farms',
                style: textStyle(
                  Colors.white,
                  16,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ),
          ),
          Container(
            width: isWeb ? 90 : (layoutWidth / 2) - 5,
            decoration: isAllFarmsSelection
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
                final isWalletConnected =
                    context.read<WalletBloc>().state.isWalletConnected;
                if (isWalletConnected) {
                  if (isAllFarmsSelection) {
                    _farmTextController.clear();
                    context
                        .read<FarmBloc>()
                        .add(OnChangeFarmTab(isAllFarms: false));
                  }
                } else {
                  context.showWalletWarningToast();
                }
              },
              child: Text(
                'My Farms',
                style:
                    textStyle(Colors.white, 16, isBold: true, isUline: false),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({
    super.key,
    required this.isWeb,
    required this.myController,
    required this.layoutWdt,
    required this.layoutHgt,
    required this.bloc,
  });

  final bool isWeb;
  final TextEditingController myController;
  final double layoutWdt;
  final double layoutHgt;
  final FarmBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? 250 : layoutWdt / 2,
      height: isWeb ? 40 : layoutHgt * 0.05,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                bloc.add(OnSearchFarms(searchedName: value));
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 8.5),
                hintText: 'Search a farm',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileSearchBar extends StatelessWidget {
  const MobileSearchBar({
    super.key,
    required this.isWeb,
    required this.myController,
    required this.layoutWdt,
    required this.layoutHgt,
    required this.bloc,
  });

  final bool isWeb;
  final TextEditingController myController;
  final double layoutWdt;
  final double layoutHgt;
  final FarmBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb ? 250 : layoutWdt / 2,
      height: isWeb ? 40 : layoutHgt * 0.05,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                bloc.add(OnSearchFarms(searchedName: value));
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: layoutHgt * 0.022),
                hintText: 'Search a farm',
                hintStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
