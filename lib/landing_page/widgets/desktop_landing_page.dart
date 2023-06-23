import 'package:ax_dapp/landing_page/widgets/landing_page_widgets.dart';
import 'package:flutter/material.dart';

class DesktopLandingPage extends StatelessWidget {
  const DesktopLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AthleteXLogo(),
        LandingPageMessage(),
        Spacer(),
        StartTradingButton(),
        Spacer(flex: 2),
        TermsAndConditions(),
      ],
    );
  }
}
