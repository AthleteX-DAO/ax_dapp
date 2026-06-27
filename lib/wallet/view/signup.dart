import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/models/status.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasDispatchedAuthFailed = false;
  bool _obscurePassword = true;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listenWhen: (previous, current) =>
          previous.walletViewStatus != current.walletViewStatus &&
          current.walletViewStatus == WalletViewStatus.profile,
      listener: (context, state) {
        context.read<TrackingCubit>().trackSignUpSuccess(
              walletId: state.walletAddress,
            );
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final bloc = context.read<WalletBloc>();
        final errorMessage = state.errorMessage;
        final walletViewStatus = state.walletViewStatus;

        // ── Error / Info Toast Handling ──
        if (state.hasFailure && !_hasDispatchedAuthFailed) {
          _hasDispatchedAuthFailed = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.showWarningToast(
              title: 'Error',
              description: errorMessage ?? 'Authentication Error',
            );
          });
          bloc.add(AuthFailed(walletViewStatus: walletViewStatus));
        } else if (!state.hasFailure) {
          _hasDispatchedAuthFailed = false;
        }
        if (state.infoMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.showWarningToast(
              title: 'Heads up',
              description: state.infoMessage!,
            );
          });
          bloc.add(const InfoMessageCleared());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Back button ──
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => bloc.add(const LoginSignUpViewRequested()),
                ),
              ),
              const SizedBox(height: 12),

              // ── Title ──
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [GoldTheme.gold, Color(0xFFFFF1B0)],
                ).createShader(bounds),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Create your AthleteX account',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 36),

              // ── Email field ──
              _buildTextField(
                controller: emailController,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) =>
                    bloc.add(EmailChanged(email: value)),
              ),
              const SizedBox(height: 16),

              // ── Password field ──
              _buildTextField(
                controller: passwordController,
                label: 'Password',
                hint: 'Create a password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (value) =>
                    bloc.add(PassWordChanged(password: value)),
              ),
              const SizedBox(height: 12),

              // ── Password requirements hint ──
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Password must be at least 6 characters',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Sign Up Button ──
              MouseRegion(
                onEnter: (_) => setState(() => _hovering = true),
                onExit: (_) => setState(() => _hovering = false),
                child: GestureDetector(
                  onTap: () {
                      context.read<TrackingCubit>().trackSignUpPressed();
                      bloc.add(const ProfileViewRequestedFromSignUp());
                    },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _hovering
                            ? [
                                const Color(0xFFFFC600),
                                const Color(0xFFE0A800),
                              ]
                            : [GoldTheme.gold, GoldTheme.goldDark],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: GoldTheme.gold
                              .withValues(alpha: _hovering ? 0.35 : 0.18),
                          blurRadius: _hovering ? 18 : 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Already have account? ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => bloc.add(const LoginViewRequested()),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 13,
                        color: GoldTheme.gold,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'OpenSans',
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        labelStyle: TextStyle(
          color: GoldTheme.gold.withValues(alpha: 0.7),
          fontFamily: 'OpenSans',
        ),
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: GoldTheme.gold, width: 1.5),
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
