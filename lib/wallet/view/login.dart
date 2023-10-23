import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatelessWidget {
  LoginView({
    super.key,
  });

  final kTextFieldDecoration = InputDecoration(
    hintText: '',
    hintStyle: const TextStyle(color: Colors.white),
    fillColor: secondaryOrangeColor,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryOrangeColor),
      borderRadius: const BorderRadius.all(Radius.circular(32)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryOrangeColor, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(32)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    String email;
    String password;
    var showSpinner = false;
    final _auth = FirebaseAuth.instance;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password.',
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  primaryOrangeColor.withOpacity(0.15),
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
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () async {
                context.read<WalletBloc>().add(const ProfileViewRequested());

                // TODO: Sign up with email & password
                // try {
                //   final user = await _auth.signInWithEmailAndPassword(
                //       email: email, password: password);
                // } catch (e) {
                //   print(e);
                // }

                showSpinner = false;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Connect',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context
                            .read<WalletBloc>()
                            .add(const ConnectWalletRequested());
                      },
                  ),
                  TextSpan(
                    text: 'with Metamask or other 3rd party wallets',
                    style: TextStyle(
                      color: Colors.amber[400],
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
