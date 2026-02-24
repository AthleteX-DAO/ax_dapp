import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/bloc/versus_chat_bloc.dart';
import 'package:ax_dapp/versus/widgets/chat_input_field.dart';
import 'package:ax_dapp/versus/widgets/chat_message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Panel displaying chat messages for a versus matchup
class VersusChatPanel extends StatefulWidget {
  const VersusChatPanel({
    required this.matchId,
    required this.walletAddress,
    required this.athlete1Id,
    required this.athlete2Id,
    this.votedFor,
    super.key,
  });

  final String matchId;
  final String walletAddress;
  final int athlete1Id;
  final int athlete2Id;
  final int? votedFor;

  @override
  State<VersusChatPanel> createState() => _VersusChatPanelState();
}

class _VersusChatPanelState extends State<VersusChatPanel> {
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    print('[VersusChatPanel] Initialized (matchId=${widget.matchId}, walletAddress=${widget.walletAddress.isEmpty ? "(not connected)" : widget.walletAddress})');
  }

  @override
  void didUpdateWidget(VersusChatPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.walletAddress != widget.walletAddress) {
      print('[VersusChatPanel] Wallet address changed: ${oldWidget.walletAddress.isEmpty ? "(none)" : oldWidget.walletAddress} -> ${widget.walletAddress.isEmpty ? "(none)" : widget.walletAddress}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: primaryOrangeColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Battle Chat',
                  style: textStyle(
                    Colors.white,
                    16,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const Spacer(),
                BlocBuilder<VersusChatBloc, VersusChatState>(
                  builder: (context, state) {
                    return Text(
                      '${state.messages.length}',
                      style: textStyle(
                        greyTextColor,
                        14,
                        isBold: false,
                        isUline: false,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isExpanded 
                        ? Icons.keyboard_arrow_down 
                        : Icons.keyboard_arrow_up,
                    color: primaryOrangeColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  tooltip: _isExpanded ? 'Collapse chat' : 'Expand chat',
                ),
              ],
            ),
          ),
          
          // Messages list (collapsible)
          if (_isExpanded) ...[
          Expanded(
            child: BlocBuilder<VersusChatBloc, VersusChatState>(
              builder: (context, state) {
                if (state.status == ChatStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryOrangeColor),
                    ),
                  );
                }

                if (state.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 48,
                          color: greyTextColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: textStyle(
                            greyTextColor,
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to share your thoughts!',
                          style: textStyle(
                            greyTextColor,
                            12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return ChatMessageCard(
                      message: message,
                      currentWalletAddress: widget.walletAddress,
                      athlete1Id: widget.athlete1Id,
                      athlete2Id: widget.athlete2Id,
                      onLike: () {
                        context.read<VersusChatBloc>().add(
                              LikeMessageRequested(messageId: message.id),
                            );
                      },
                      onDelete: message.walletAddress == widget.walletAddress
                          ? () {
                              context.read<VersusChatBloc>().add(
                                    DeleteMessageRequested(
                                      messageId: message.id,
                                      walletAddress: widget.walletAddress,
                                    ),
                                  );
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          
          // Error message
          BlocBuilder<VersusChatBloc, VersusChatState>(
            builder: (context, state) {
              if (state.errorMessage != null) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.withOpacity(0.1),
                  child: Text(
                    state.errorMessage!,
                    style: textStyle(
                      Colors.red,
                      12,
                      isBold: false,
                      isUline: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          // Input field (requires wallet connection)
          if (widget.walletAddress.isEmpty)
            _buildLockedChatInput()
          else
            BlocBuilder<VersusChatBloc, VersusChatState>(
              builder: (context, state) {
                return ChatInputField(
                  enabled: state.status != ChatStatus.sending,
                  onSend: (message) {
                    print('[VersusChatPanel] Sending message: wallet=${widget.walletAddress}, msg="$message"');
                    context.read<VersusChatBloc>().add(
                          SendMessageRequested(
                            walletAddress: widget.walletAddress,
                            message: message,
                            votedFor: widget.votedFor,
                          ),
                        );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  /// Locked input shown when no wallet is connected
  Widget _buildLockedChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        color: Colors.white.withOpacity(0.03),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline,
            size: 16,
            color: Colors.white38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Connect wallet to chat',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
