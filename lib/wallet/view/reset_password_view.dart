import 'package:ax_dapp/service/gold_theme.dart';
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
  final emailController = TextEditingController();
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Back button row ──
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () => context.read<WalletBloc>().add(
                      const LoginSignUpViewRequested(),
                    ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Title ──
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [GoldTheme.gold, Color(0xFFFFF1B0)],
              ).createShader(bounds),
              child: const Text(
                'Reset Password',
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
              'Enter your email to receive recovery instructions',
              textAlign: TextAlign.center,
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
                  context.read<WalletBloc>().add(EmailChanged(email: value)),
            ),
            const SizedBox(height: 32),

            // ── Reset Button ──
            MouseRegion(
              onEnter: (_) => setState(() => _hovering = true),
              onExit: (_) => setState(() => _hovering = false),
              child: GestureDetector(
                onTap: () => context.read<WalletBloc>().add(const ResetPassword()),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _hovering
                          ? [const Color(0xFFFFC600), const Color(0xFFE0A800)]
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
                      Icon(Icons.mail_outline_rounded, color: Colors.black, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Send Reset Link',
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
    super.dispose();
  }
}
