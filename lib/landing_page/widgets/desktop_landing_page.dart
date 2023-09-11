import 'package:ax_dapp/landing_page/widgets/landing_page_widgets.dart';
import 'package:ax_dapp/landing_page/widgets/login_widget.dart';
import 'package:ax_dapp/landing_page/widgets/sign_up_button.dart';
import 'package:flutter/material.dart';

class DesktopLandingPage extends StatelessWidget {
  const DesktopLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AthleteXLogo(),
        LandingPageMessage(),
        Spacer(),
        SignUpButton(),
        LoginWidget(),
        Spacer(flex: 2),
        TermsAndConditions(),
      ],
    );
  }
}
