import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Landing page shown before login or sign up.
/// Premium glassmorphism design consistent with AthleteX brand.
class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Logo ──
          Image.asset(
            'assets/images/AthleteX_Logo_Vector.png',
            height: 56,
          ),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [GoldTheme.gold, Color(0xFFFFF1B0)],
            ).createShader(bounds),
            child: const Text(
              'AthleteX',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'OpenSans',
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Decentralized Sports Prediction Protocol',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 44),

          // ── Sign Up Button (primary) ──
          _GoldGradientButton(
            label: 'Create Account',
            icon: Icons.person_add_alt_1_rounded,
            onPressed: () {
              context.read<WalletBloc>().add(const SignUpViewRequested());
            },
          ),
          const SizedBox(height: 16),

          // ── Login Button (secondary / outline) ──
          _OutlineButton(
            label: 'Log In',
            icon: Icons.login_rounded,
            onPressed: () {
              context.read<WalletBloc>().add(const LoginViewRequested());
            },
          ),
          const SizedBox(height: 28),

          // ── Divider ──
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[700], thickness: 0.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontFamily: 'OpenSans',
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[700], thickness: 0.5)),
            ],
          ),
          const SizedBox(height: 28),

          // ── Connect Wallet ──
          _OutlineButton(
            label: 'Connect External Wallet',
            icon: Icons.account_balance_wallet_rounded,
            borderColor: GoldTheme.gold.withValues(alpha: 0.4),
            textColor: GoldTheme.gold,
            onPressed: () {
              context.read<WalletBloc>().add(const ConnectWalletRequested());
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Shared Buttons
// ─────────────────────────────────────────────────────────────────────

class _GoldGradientButton extends StatefulWidget {
  const _GoldGradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  State<_GoldGradientButton> createState() => _GoldGradientButtonState();
}

class _GoldGradientButtonState extends State<_GoldGradientButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
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
                color: GoldTheme.gold.withValues(alpha: _hovering ? 0.35 : 0.18),
                blurRadius: _hovering ? 18 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.black, size: 20),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: const TextStyle(
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
    );
  }
}

class _OutlineButton extends StatefulWidget {
  const _OutlineButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? Colors.white.withValues(alpha: 0.25);
    final textColor = widget.textColor ?? Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _hovering
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovering ? textColor.withValues(alpha: 0.6) : borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: textColor, size: 20),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
