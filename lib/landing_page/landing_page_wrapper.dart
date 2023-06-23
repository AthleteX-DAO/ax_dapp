import 'package:ax_dapp/landing_page/widgets/landing_page_widgets.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPageWrapper extends StatelessWidget {
  const LandingPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    context.read<TrackingCubit>().onLandingPageView();
    if (_width >= 768) {
      return const DesktopLandingPage();
    } else {
      return const MobileLandingPage();
    }
  }
}
