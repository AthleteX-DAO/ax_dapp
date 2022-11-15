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
  final farmTextController = TextEditingController();
  bool isWeb = true;
  bool isAllFarms = true;

  @override
  void dispose() {
    farmTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return global.buildPage(
      context,
      LayoutBuilder(
        builder: (context, constraints) {
          final _width = constraints.maxWidth;
          final _height = constraints.maxHeight;
          var layoutHeight = _height * 0.8;
          final layoutWidth = _width * 0.95;
          if (_height < 445) layoutHeight = _height;
          var listHeight = (isWeb && isAllFarms) ? 225.0 : layoutHeight * 0.80;
          if (isWeb && !isAllFarms) listHeight = 500.0;
          return Container(
            width: _width,
            height: _height - AppBar().preferredSize.height,
            margin: isWeb
                ? EdgeInsets.zero
                : EdgeInsets.only(top: AppBar().preferredSize.height + 10),
            alignment: Alignment.center,
            child: SizedBox(
              width: layoutWidth,
              height: layoutHeight,
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
                    if (!state.isAllFarms &&
                        state.status == BlocStatus.noWallet) {
                      widget = const NoWallet();
                    }
                    if (state.status == BlocStatus.unsupportedChain) {
                      widget = UnsupportedChain(chain: state.chain);
                    }
                    final Widget toggle = ToggleFarmButton(
                      layoutWidth: layoutWidth,
                      layoutHeight: layoutHeight,
                      myController: farmTextController,
                    );
                    return Wrap(
                      runSpacing: layoutHeight * 0.02,
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
                            if (!isWeb)
                              CreateSearchBar(
                                layoutWidth: layoutWidth,
                                layoutHeight: layoutHeight,
                                farmTextController: farmTextController,
                              ),
                          ],
                        ),
                        if (isWeb)
                          Row(
                            children: [
                              CreateSearchBar(
                                layoutWidth: layoutWidth,
                                layoutHeight: layoutHeight,
                                farmTextController: farmTextController,
                              ),
                              const SizedBox(width: 50),
                              toggle
                            ],
                          ),
                        if (!isWeb) toggle,
                        SizedBox(
                          //contains list of allfarms cards
                          width: layoutWidth,
                          height: layoutHeight - 120,
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
                                                    farm: state
                                                        .filteredFarms[index],
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
                                                  layoutWdt: layoutWidth,
                                                )
                                              : MyFarmItem(
                                                  farm: FarmController(
                                                    farm: state
                                                            .filteredStakedFarms[
                                                        index],
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
                                                  layoutWidth: layoutWidth,
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
          );
        },
      ),
    );
  }
}

class CreateSearchBar extends StatelessWidget {
  const CreateSearchBar({
    super.key,
    required this.layoutWidth,
    required this.layoutHeight,
    required TextEditingController farmTextController,
  }) : _farmTextController = farmTextController;

  final double layoutWidth;
  final double layoutHeight;
  final TextEditingController _farmTextController;

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    if (isWebMobile) {
      return MobileSearchBar(
        isWeb: isWeb,
        myController: _farmTextController,
        layoutHgt: layoutHeight,
        layoutWdt: layoutWidth,
      );
    } else {
      return WebSearchBar(
        isWeb: isWeb,
        myController: _farmTextController,
        layoutHgt: layoutHeight,
        layoutWdt: layoutWidth,
      );
    }
  }
}
