// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

enum OnrampProvider { kado, paypal, achTransfer }

class AccountBuyAndSell extends StatefulWidget {
  const AccountBuyAndSell({super.key});

  @override
  State<AccountBuyAndSell> createState() => _AccountBuyAndSellState();
}

class _AccountBuyAndSellState extends State<AccountBuyAndSell> {
  OnrampProvider _selectedProvider = OnrampProvider.kado;
  late Widget _kadoMoney;
  late html.IFrameElement _iframeElement;

  @override
  void initState() {
    super.initState();
    _initializeKadoIframe();
  }

  void _initializeKadoIframe() {
    _iframeElement = html.IFrameElement()
      ..height = '500'
      ..width = '450'
      ..src =
          'https://app.kado.money/?apiKey=137cd949-ab0f-429f-93b8-187ef3a93862';
    _iframeElement.style.borderRadius = '14px';
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _kadoMoney = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }

  @override
  Widget build(BuildContext context) {
    const edge = 40.0;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(edge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back button
            Row(
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => context.read<AccountBloc>().add(
                        const AccountDetailsViewRequested(),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buy or Sell USDC',
                    style: textStyle(
                      Colors.white,
                      20,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your preferred payment method',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WalletBalance(),
                      WalletAddress(),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Onramp provider selector
            Text(
              'Payment Method',
              style: textStyle(
                Colors.white,
                16,
                isBold: true,
                isUline: false,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProviderCard(
                  provider: OnrampProvider.kado,
                  title: 'Kado',
                  subtitle: 'Card, Apple Pay, Google Pay',
                  icon: Icons.credit_card_rounded,
                ),
                const SizedBox(width: 12),
                _buildProviderCard(
                  provider: OnrampProvider.paypal,
                  title: 'PayPal',
                  subtitle: 'PayPal balance or card',
                  icon: Icons.paypal_rounded,
                ),
                const SizedBox(width: 12),
                _buildProviderCard(
                  provider: OnrampProvider.achTransfer,
                  title: 'Bank Transfer',
                  subtitle: 'ACH (2-3 days)',
                  icon: Icons.account_balance_rounded,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Content area
            Container(
              height: 550,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildProviderContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard({
    required OnrampProvider provider,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedProvider == provider;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedProvider = provider;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [
                      primaryOrangeColor.withOpacity(0.2),
                      primaryOrangeColor.withOpacity(0.1),
                    ]
                  : [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.06),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? primaryOrangeColor.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? primaryOrangeColor : Colors.white70,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? primaryOrangeColor : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderContent() {
    switch (_selectedProvider) {
      case OnrampProvider.kado:
        return _kadoMoney;
      case OnrampProvider.paypal:
        return _buildComingSoonContent(
          'PayPal Integration',
          'Connect your PayPal account to buy USDC instantly',
          Icons.paypal_rounded,
        );
      case OnrampProvider.achTransfer:
        return _buildComingSoonContent(
          'ACH Bank Transfer',
          'Link your bank account for low-fee transfers',
          Icons.account_balance_rounded,
        );
    }
  }

  Widget _buildComingSoonContent(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: Colors.white30,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textStyle(
                Colors.white,
                20,
                isBold: true,
                isUline: false,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
