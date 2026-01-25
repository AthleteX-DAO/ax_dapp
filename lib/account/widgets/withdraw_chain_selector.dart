import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/util/chain_localized_image.dart';
import 'package:ax_dapp/util/chain_localized_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// Silent chain selector for withdraw page—does NOT trigger MetaMask.
class WithdrawChainSelector extends StatelessWidget {
  const WithdrawChainSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    var showChainIcon = true;
    var showIcons = false;
    if (_width < 665) {
      showChainIcon = false;
      showIcons = true;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (showChainIcon)
          const Icon(
            Icons.link,
            color: Colors.grey,
          ),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: BlocSelector<AccountBloc, AccountState, EthereumChain>(
              selector: (state) => state.withdrawTargetChain,
              builder: (context, withdrawChain) {
                return DropdownButton<EthereumChain>(
                  dropdownColor: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  value: withdrawChain,
                  items: [
                    for (final chain in EthereumChain.supportedValues)
                      DropdownMenuItem(
                        value: chain,
                        child: showIcons
                            ? Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(chain.localizedImage),
                              )
                            : Text(chain.localizedName),
                      ),
                  ],
                  onChanged: (chain) {
                    if (chain != null) {
                      context
                          .read<AccountBloc>()
                          .add(WithdrawChainSelected(chain: chain));
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
