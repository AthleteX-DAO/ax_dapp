import 'package:ax_dapp/util/chain_localized_image.dart';
import 'package:ax_dapp/util/chain_localized_name.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The two chains exposed in the quick-switcher.
const _switchableChains = [
  EthereumChain.ethereumSepolia,
  EthereumChain.polygonMainnet,
];

class WalletTopBarDetails extends StatelessWidget {
  const WalletTopBarDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showWalletIcon = width >= 650;

    return BlocBuilder<WalletBloc, WalletState>(
      buildWhen: (previous, current) =>
          previous.walletAddress != current.walletAddress ||
          previous.walletBalance != current.walletBalance ||
          previous.chain != current.chain,
      builder: (_, state) {
        final address = state.walletAddress;
        final hasAddress = address.isNotEmpty;
        final shortAddress = hasAddress
            ? '${address.substring(0, 7)}...${address.substring(address.length - 5)}'
            : 'Connect wallet';
        final balanceText = state.walletBalance > 0
            ? '${state.walletBalance.toStringAsFixed(2)} axUSD'
            : 'axUSD 0.00';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Chain switcher ──────────────────────────────────────
              _ChainSwitcherButton(currentChain: state.chain),

              // ── Divider ─────────────────────────────────────────────
              Container(
                height: 16,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white24,
              ),

              // ── Address + balance (tap → drawer) ────────────────────
              GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showWalletIcon)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    Text(
                      shortAddress,
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontFamily: 'OpenSans',
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      balanceText,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                        fontSize: 11,
                      ),
                    ),
                    if (hasAddress)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: address));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address copied')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6, right: 4),
                          child: Icon(
                            Icons.copy,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Chain switcher popup ──────────────────────────────────────────────────────

class _ChainSwitcherButton extends StatelessWidget {
  const _ChainSwitcherButton({required this.currentChain});

  final EthereumChain currentChain;

  Color _dotColor(EthereumChain chain) {
    if (chain == EthereumChain.polygonMainnet) return const Color(0xFF8247E5);
    if (chain == EthereumChain.ethereumSepolia) return const Color(0xFF627EEA);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isUnknown = currentChain == EthereumChain.none ||
        currentChain == EthereumChain.unsupported;
    final chainLabel = isUnknown ? 'Select network' : currentChain.localizedName;

    return PopupMenuButton<EthereumChain>(
      tooltip: 'Switch network',
      color: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 30),
      onSelected: (chain) =>
          context.read<WalletBloc>().add(SwitchChainRequested(chain)),
      itemBuilder: (_) => _switchableChains
          .map(
            (chain) => PopupMenuItem<EthereumChain>(
              value: chain,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: _dotColor(chain),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Image.asset(
                    chain.localizedImage,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    chain.localizedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  if (chain == currentChain) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.greenAccent,
                    ),
                  ],
                ],
              ),
            ),
          )
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: _dotColor(currentChain),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _dotColor(currentChain).withOpacity(0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            if (!isUnknown)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Image.asset(
                  currentChain.localizedImage,
                  width: 14,
                  height: 14,
                ),
              ),
            Text(
              chainLabel,
              style: TextStyle(
                color: Colors.grey[300],
                fontFamily: 'OpenSans',
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.expand_more_rounded,
              size: 14,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}
