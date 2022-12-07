import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AthletePageTitle extends StatelessWidget {
  const AthletePageTitle({
    super.key,
    required this.wid,
    required this.athleteName,
    required double width,
    required double height,
    required this.indexUnselectedStackBackgroundColor,
  })  : _width = width,
        _height = height;

  final double wid;
  final String athleteName;
  final double _width;
  final double _height;
  final Color indexUnselectedStackBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return SizedBox(
            width: wid,
            height: 100,
            child: Row(
              children: [
                // APT Icon
                BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                  selector: (state) => state.aptTypeSelection,
                  builder: (context, aptTypeSelection) {
                    return Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: aptTypeSelection.isLong
                              ? const AssetImage(
                                  'assets/images/apt_noninverted.png',
                                )
                              : const AssetImage(
                                  'assets/images/apt_inverted.png',
                                ),
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        athleteName,
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1.5),
                      width: _width * .25,
                      height: _height * .04,
                      decoration: boxDecoration(
                        Colors.transparent,
                        10,
                        1,
                        secondaryGreyColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocSelector<AthletePageBloc,
                                AthletePageState, AptType>(
                              selector: (state) => state.aptTypeSelection,
                              builder: (context, aptTypeSelection) {
                                return DecoratedBox(
                                  decoration: boxDecoration(
                                    aptTypeSelection.isLong
                                        ? secondaryGreyColor
                                        : indexUnselectedStackBackgroundColor,
                                    8,
                                    0,
                                    Colors.transparent,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(15, 30),
                                    ),
                                    onPressed: () =>
                                        context.read<AthletePageBloc>().add(
                                              const AptTypeSelectionChanged(
                                                AptType.long,
                                              ),
                                            ),
                                    child: FittedBox(
                                      child: SizedBox(
                                        child: Text(
                                          'Long',
                                          style: TextStyle(
                                            color: aptTypeSelection.isLong
                                                ? primaryWhiteColor
                                                : const Color.fromRGBO(
                                                    154,
                                                    154,
                                                    154,
                                                    1,
                                                  ),
                                            fontSize: 10,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: BlocSelector<AthletePageBloc,
                                AthletePageState, AptType>(
                              selector: (state) {
                                return state.aptTypeSelection;
                              },
                              builder: (context, aptTypeSelection) {
                                return DecoratedBox(
                                  decoration: boxDecoration(
                                    aptTypeSelection.isLong
                                        ? indexUnselectedStackBackgroundColor
                                        : secondaryGreyColor,
                                    8,
                                    0,
                                    Colors.transparent,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    onPressed: () =>
                                        context.read<AthletePageBloc>().add(
                                              const AptTypeSelectionChanged(
                                                AptType.short,
                                              ),
                                            ),
                                    child: FittedBox(
                                      child: SizedBox(
                                        child: Text(
                                          'Short',
                                          style: TextStyle(
                                            color: aptTypeSelection.isLong
                                                ? const Color.fromRGBO(
                                                    154,
                                                    154,
                                                    154,
                                                    1,
                                                  )
                                                : primaryWhiteColor,
                                            fontSize: 10,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    '|',
                    style: textStyle(
                      const Color.fromRGBO(100, 100, 100, 1),
                      24,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  decoration: boxDecoration(
                    Colors.amber[500]!.withOpacity(0.20),
                    500,
                    1,
                    Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<AthletePageBloc>()
                          .add(const AddTokenToWalletRequested());
                      final formattedWalletAddress = context
                          .read<WalletBloc>()
                          .state
                          .formattedWalletAddress;
                      context.read<TrackingCubit>().trackAddToWallet(
                            athleteName: athleteName,
                            walletId: formattedWalletAddress,
                          );
                    },
                    child: Text(
                      '+ Add to Wallet',
                      style: TextStyle(
                        color: Colors.amber[500],
                        fontSize: 10,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: wid,
            height: 100,
            child: Row(
              children: [
                // Back button
                SizedBox(
                  width: 70,
                  child: TextButton(
                    onPressed: () {
                      context.goNamed('scout');
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                // APT Icon
                BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                  selector: (state) => state.aptTypeSelection,
                  builder: (context, aptTypeSelection) {
                    return Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: aptTypeSelection.isLong
                              ? const AssetImage(
                                  'assets/images/apt_noninverted.png',
                                )
                              : const AssetImage(
                                  'assets/images/apt_inverted.png',
                                ),
                        ),
                      ),
                    );
                  },
                ),
                // Player Name
                Text(
                  athleteName,
                  style: textStyle(
                    Colors.white,
                    26,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                // '|' Symbol
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    '|',
                    style: textStyle(
                      const Color.fromRGBO(100, 100, 100, 1),
                      24,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Seasonal APT',
                      style: textStyle(
                        const Color.fromRGBO(154, 154, 154, 1),
                        24,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1.5),
                      width: _width * .10,
                      height: _height * .02,
                      decoration: boxDecoration(
                        Colors.transparent,
                        10,
                        1,
                        secondaryGreyColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocSelector<AthletePageBloc,
                                AthletePageState, AptType>(
                              selector: (state) => state.aptTypeSelection,
                              builder: (context, aptTypeSelection) {
                                return DecoratedBox(
                                  decoration: boxDecoration(
                                    aptTypeSelection.isLong
                                        ? secondaryGreyColor
                                        : indexUnselectedStackBackgroundColor,
                                    8,
                                    0,
                                    Colors.transparent,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(15, 8),
                                    ),
                                    onPressed: () =>
                                        context.read<AthletePageBloc>().add(
                                              const AptTypeSelectionChanged(
                                                AptType.long,
                                              ),
                                            ),
                                    child: Text(
                                      'Long',
                                      style: TextStyle(
                                        color: aptTypeSelection.isLong
                                            ? primaryWhiteColor
                                            : const Color.fromRGBO(
                                                154,
                                                154,
                                                154,
                                                1,
                                              ),
                                        fontSize: 10,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: BlocSelector<AthletePageBloc,
                                AthletePageState, AptType>(
                              selector: (state) {
                                return state.aptTypeSelection;
                              },
                              builder: (context, aptTypeSelection) {
                                return DecoratedBox(
                                  decoration: boxDecoration(
                                    aptTypeSelection.isLong
                                        ? indexUnselectedStackBackgroundColor
                                        : secondaryGreyColor,
                                    8,
                                    0,
                                    Colors.transparent,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    onPressed: () =>
                                        context.read<AthletePageBloc>().add(
                                              const AptTypeSelectionChanged(
                                                AptType.short,
                                              ),
                                            ),
                                    child: Text(
                                      'Short',
                                      style: TextStyle(
                                        color: aptTypeSelection.isLong
                                            ? const Color.fromRGBO(
                                                154,
                                                154,
                                                154,
                                                1,
                                              )
                                            : primaryWhiteColor,
                                        fontSize: 10,
                                        fontFamily: 'OpenSans',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 4,
                  runSpacing: 64,
                  children: [
                    Container(
                      height: 20,
                      decoration: boxDecoration(
                        Colors.amber[500]!.withOpacity(0.20),
                        500,
                        1,
                        Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<AthletePageBloc>()
                              .add(const AddTokenToWalletRequested());
                          final formattedWalletAddress = context
                              .read<WalletBloc>()
                              .state
                              .formattedWalletAddress;
                          context.read<TrackingCubit>().trackAddToWallet(
                                athleteName: athleteName,
                                walletId: formattedWalletAddress,
                              );
                        },
                        child: Text(
                          '+ Add to Wallet',
                          style: textStyle(
                            Colors.amber[500]!,
                            10,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
