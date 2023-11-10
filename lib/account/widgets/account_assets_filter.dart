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
                _selectedWalletAsset = AccountAssets.Crypto;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.Crypto,
                ),
              );
            },
            child: Text(
              'Crypto',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.Crypto,
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
                _selectedWalletAsset = AccountAssets.APTs;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.APTs,
                ),
              );
            },
            child: Text(
              'APTs',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.APTs,
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
                _selectedWalletAsset = AccountAssets.NFTs;
              });

              bloc.add(
                const SelectedAccountAssetsChanged(
                  selectedAssets: AccountAssets.NFTs,
                ),
              );
            },
            child: Text(
              'NFTs',
              style: textSwapState(
                condition: _selectedWalletAsset == AccountAssets.NFTs,
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
