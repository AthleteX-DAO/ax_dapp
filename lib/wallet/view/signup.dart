import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({
    super.key,
  });

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.hasFailure) {
          context.showWarningToast(
            title: 'Error',
            description: state.errorMessage ?? 'Authentication Error',
          );
          context
              .read<WalletBloc>()
              .add(const AuthFailed(walletViewStatus: WalletViewStatus.signup));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => context.read<WalletBloc>().add(
                    const LoginSignUpViewRequested(),
                  ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              textAlign: TextAlign.center,
              onChanged: (value) =>
                  context.read<WalletBloc>().add(EmailChanged(email: value)),
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) => context
                  .read<WalletBloc>()
                  .add(PassWordChanged(password: value)),
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your Password',
                labelText: 'Password',
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
              onPressed: () async {
                context.read<WalletBloc>().add(
                      const ProfileViewRequestedFromSignUp(),
                    );
              },
              child: FittedBox(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.amber[400],
                    fontSize: 40,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
