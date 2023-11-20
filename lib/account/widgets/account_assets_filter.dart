import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/models.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountAssetsFilter extends StatefulWidget {
  const AccountAssetsFilter({
    super.key,
  });

  @override
  State<AccountAssetsFilter> createState() => _WalletsAssetsFilterState();
}

class _WalletsAssetsFilterState extends State<AccountAssetsFilter> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AccountBloc>();
    const assetsFilterTxSz = 14.0;
    const edge = 40.0;
    final selectedWalletAsset =
        context.select((AccountBloc bloc) => bloc.state.selectedAssets);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          height: 25,
          width: constraints.maxWidth - edge,
          child: Row(
            children: [
              Text(
                'Your Assets',
                style: textStyle(
                  Colors.white,
                  16,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Text(
                '|',
                style: textStyle(
                  Colors.white,
                  16,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          bloc.add(
                            const SelectedAccountAssetsChanged(
                              selectedAssets: AccountAssets.all,
                            ),
                          );
                        },
                        child: Text(
                          'All',
                          style: textSwapState(
                            condition: selectedWalletAsset == AccountAssets.all,
                            tabNotSelected: textStyle(
                              Colors.white,
                              18,
                              isBold: false,
                              isUline: false,
                            ),
                            tabSelected: textStyle(
                              Colors.amber[400]!,
                              18,
                              isBold: false,
                              isUline: true,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          bloc.add(
                            const SelectedAccountAssetsChanged(
                              selectedAssets: AccountAssets.crypto,
                            ),
                          );
                        },
                        child: Text(
                          'Crypto',
                          style: textSwapState(
                            condition:
                                selectedWalletAsset == AccountAssets.crypto,
                            tabNotSelected: textStyle(
                              Colors.white,
                              assetsFilterTxSz,
                              isBold: false,
                              isUline: false,
                            ),
                            tabSelected: textStyle(
                              Colors.amber[400]!,
                              assetsFilterTxSz,
                              isBold: false,
                              isUline: true,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          bloc.add(
                            const SelectedAccountAssetsChanged(
                              selectedAssets: AccountAssets.apts,
                            ),
                          );
                        },
                        child: Text(
                          'APTs',
                          style: textSwapState(
                            condition:
                                selectedWalletAsset == AccountAssets.apts,
                            tabNotSelected: textStyle(
                              Colors.white,
                              assetsFilterTxSz,
                              isBold: false,
                              isUline: false,
                            ),
                            tabSelected: textStyle(
                              Colors.amber[400]!,
                              assetsFilterTxSz,
                              isBold: false,
                              isUline: true,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          bloc.add(
                            const SelectedAccountAssetsChanged(
                              selectedAssets: AccountAssets.nfts,
                            ),
                          );
                        },
                        child: Text(
                          'NFTs',
                          style: textSwapState(
                            condition:
                                selectedWalletAsset == AccountAssets.nfts,
                            tabNotSelected: textStyle(
                              Colors.white,
                              assetsFilterTxSz,
                              isBold: false,
                              isUline: false,
                            ),
                            tabSelected: textStyle(
                              Colors.amber[400]!,
                              assetsFilterTxSz,
                              isBold: false,
                              isUline: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
