import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/models.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountAssetsFilter extends StatefulWidget {
  const AccountAssetsFilter({
    super.key,
    required BoxConstraints boxConstraints,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;
  @override
  State<AccountAssetsFilter> createState() => _WalletsAssetsFilterState();
}

class _WalletsAssetsFilterState extends State<AccountAssetsFilter> {
  @override
  Container build(BuildContext context) {
    final bloc = context.read<AccountBloc>();
    const assetsFilterTxSz = 14.0;
    var _selectedWalletAsset = context.read<AccountBloc>().state.selectedAssets;

    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      height: 25,
      width: widget.constraints.maxWidth,
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
                _selectedWalletAsset = AccountAssets.all;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.all,
                ),
              );
            },
            child: Text(
              'All',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.all,
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
                _selectedWalletAsset = AccountAssets.crypto;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.crypto,
                ),
              );
            },
            child: Text(
              'Crypto',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.crypto,
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
                _selectedWalletAsset = AccountAssets.apts;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.apts,
                ),
              );
            },
            child: Text(
              'APTs',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.apts,
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
                _selectedWalletAsset = AccountAssets.nfts;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.nfts,
                ),
              );
            },
            child: Text(
              'NFTs',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.nfts,
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
