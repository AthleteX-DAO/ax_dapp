import 'package:ax_dapp/landing_page/widgets/athletex_logo.dart';
import 'package:ax_dapp/landing_page/widgets/landing_page_widgets.dart';
import 'package:flutter/material.dart';

class MobileLandingPage extends StatelessWidget {
  const MobileLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        AthleteXLogo(),
        StartTradingButton(),
        TermsAndConditions()
      ],
    );
  }
}
