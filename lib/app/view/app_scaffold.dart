import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/wallet/view/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWebLandscape =
        kIsWeb && (mediaQuery.orientation == Orientation.landscape);
    final navBarHeight =
        isWebLandscape ? kTopNavBarHeightWeb : kTopNavBarHeightMobile;
    final topInset = mediaQuery.padding.top + navBarHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: navBarHeight,
        automaticallyImplyLeading: false,
        actions: [
          Container(),
        ],
        title: kIsWeb &&
                (mediaQuery.orientation == Orientation.landscape)
            ? const TopNavigationBarWeb()
            : const TopNavigationBarMobile(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: kIsWeb &&
              (mediaQuery.orientation == Orientation.landscape)
          ? const BottomNavigationBarWeb()
          : const BottomNavigationBarMobile(),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: topInset),
          child: child,
        ),
      ),
      endDrawer: const DrawerView(),
    );
  }
}
