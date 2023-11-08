import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class WalletAssetsFilter extends StatefulWidget {
  const WalletAssetsFilter({
    super.key,
    required BoxConstraints boxConstraints,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;
  @override
  State<WalletAssetsFilter> createState() => _WalletsAssetsFilterState();
}

class _WalletsAssetsFilterState extends State<WalletAssetsFilter> {
  @override
  Container build(BuildContext context) {
    final bloc = context.read<WalletBloc>();
    const assetsFilterTxSz = 14.0;
    var _selectedWalletAsset = context.read<WalletBloc>().state.selectedAssets;

    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      height: 25,
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
          TextButton(
            onPressed: () {
              setState(() {
                _selectedWalletAsset = WalletAssets.all;
              });

              bloc.add(
                const SelectedWalletAssetsChanged(
                  selectedAssets: WalletAssets.all,
                ),
              );
            },
            child: Text(
              'All',
              style: textSwapState(
                condition: _selectedWalletAsset == WalletAssets.all,
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
              setState(() {
                _selectedWalletAsset = WalletAssets.Crypto;
              });

              bloc.add(
                const SelectedWalletAssetsChanged(
                  selectedAssets: WalletAssets.Crypto,
                ),
              );
            },
            child: Text(
              'Crypto',
              style: textSwapState(
                condition: _selectedWalletAsset == WalletAssets.Crypto,
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
              setState(() {
                _selectedWalletAsset = WalletAssets.APTs;
              });

              bloc.add(
                const SelectedWalletAssetsChanged(
                  selectedAssets: WalletAssets.APTs,
                ),
              );
            },
            child: Text(
              'APTs',
              style: textSwapState(
                condition: _selectedWalletAsset == WalletAssets.APTs,
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
              setState(() {
                _selectedWalletAsset = WalletAssets.NFTs;
              });

              bloc.add(
                const SelectedWalletAssetsChanged(
                  selectedAssets: WalletAssets.NFTs,
                ),
              );
            },
            child: Text(
              'NFTs',
              style: textSwapState(
                condition: _selectedWalletAsset == WalletAssets.NFTs,
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
    );
  }
}
