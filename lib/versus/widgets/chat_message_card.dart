import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/models/chat_message.dart';
import 'package:flutter/material.dart';

/// Card displaying a single chat message
class ChatMessageCard extends StatelessWidget {
  const ChatMessageCard({
    required this.message,
    required this.currentWalletAddress,
    required this.athlete1Id,
    required this.athlete2Id,
    this.onLike,
    this.onDelete,
    super.key,
  });

  final ChatMessage message;
  final String currentWalletAddress;
  final int athlete1Id;
  final int athlete2Id;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isOwnMessage = message.walletAddress == currentWalletAddress;
    final votedForAthlete1 = message.votedFor == athlete1Id;
    final votedForAthlete2 = message.votedFor == athlete2Id;

    Color borderColor = Colors.white.withOpacity(0.1);
    if (votedForAthlete1) {
      borderColor = primaryOrangeColor.withOpacity(0.4);
    } else if (votedForAthlete2) {
      borderColor = Colors.blue.withOpacity(0.4);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOwnMessage
            ? Colors.white.withOpacity(0.05)
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Position badge
              if (message.votedFor != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: votedForAthlete1
                        ? primaryOrangeColor.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: votedForAthlete1
                          ? primaryOrangeColor
                          : Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    votedForAthlete1 ? 'A' : 'B',
                    style: textStyle(
                      votedForAthlete1 ? primaryOrangeColor : Colors.blue,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              
              // Wallet address
              Text(
                message.truncatedAddress,
                style: textStyle(
                  primaryOrangeColor,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
              
              const Spacer(),
              
              // Timestamp
              Text(
                message.formattedTime,
                style: textStyle(
                  greyTextColor,
                  10,
                  isBold: false,
                  isUline: false,
                ),
              ),
              
              // Delete button for own messages
              if (isOwnMessage && onDelete != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: greyTextColor,
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Message text
          Text(
            message.message,
            style: textStyle(
              Colors.white,
              14,
              isBold: false,
              isUline: false,
            ),
          ),
          
          // Like button
          if (onLike != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onLike,
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 14,
                    color: greyTextColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${message.likes}',
                    style: textStyle(
                      greyTextColor,
                      12,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
