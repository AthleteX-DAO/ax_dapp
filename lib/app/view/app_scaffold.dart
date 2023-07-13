import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: kIsWeb &&
                (MediaQuery.of(context).orientation == Orientation.landscape)
            ? const TopNavigationBarWeb()
            : const TopNavigationBarMobile(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // TODO(Ryan): Render the bottom navigation bar for mobile
      bottomNavigationBar: const BottomNavigationBarWeb(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: child,
      ),
    );
  }
}
