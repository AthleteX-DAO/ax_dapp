import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final kTextFieldDecoration = InputDecoration(
    hintText: '',
    labelText: '',
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

  final emailController = TextEditingController();

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
          context.read<WalletBloc>().add(
                const AuthFailed(
                  walletViewStatus: WalletViewStatus.initial,
                ),
              );
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
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 12,
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
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () async {
                context.read<WalletBloc>().add(
                      ResetPassword(
                        email: emailController.text,
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
