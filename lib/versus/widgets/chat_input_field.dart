import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Input field for sending chat messages
class ChatInputField extends StatefulWidget {
  const ChatInputField({
    required this.onSend,
    this.enabled = true,
    super.key,
  });

  final void Function(String message) onSend;
  final bool enabled;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      context.read<TrackingCubit>().trackVersusChatSent(
            marketName: '',
            walletId: '',
          );
      widget.onSend(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              maxLength: 280,
              maxLines: null,
              style: textStyle(
                Colors.white,
                14,
                isBold: false,
                isUline: false,
              ),
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                hintStyle: textStyle(
                  greyTextColor,
                  14,
                  isBold: false,
                  isUline: false,
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryOrangeColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                counterText: '',
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send button
          GestureDetector(
            onTap: _hasText && widget.enabled ? _sendMessage : null,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: _hasText && widget.enabled
                    ? LinearGradient(
                        colors: [
                          primaryOrangeColor,
                          primaryOrangeColor.withOpacity(0.8),
                        ],
                      )
                    : null,
                color: _hasText && widget.enabled
                    ? null
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                boxShadow: _hasText && widget.enabled
                    ? [
                        BoxShadow(
                          color: primaryOrangeColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.send,
                color: _hasText && widget.enabled
                    ? Colors.black
                    : greyTextColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
