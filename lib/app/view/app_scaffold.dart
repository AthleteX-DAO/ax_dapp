import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const textSize = 20.0;
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
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: child,
      ),
      endDrawer: Drawer(
        width: width / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.amber[200]!.withOpacity(0.15),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(width / 4, height * 0.09),
                ),
                maximumSize: MaterialStateProperty.all<Size>(
                  Size(width / 2, height * 0.10),
                ),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.amber[400],
                  fontSize: 40,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                //Change State ( honestly this is why we need BLoC)
              },
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      color: Colors.amber[400],
                      fontSize: textSize,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: textSize,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //Important logic goes here, but will be empty for now
                        })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
