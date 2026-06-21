import 'package:equatable/equatable.dart';

/// A community-submitted market proposal.
class MarketProposal extends Equatable {
  const MarketProposal({
    required this.id,
    required this.prompt,
    required this.category,
    required this.details,
    required this.proposerAddress,
    required this.createdAt,
    required this.voteCount,
    required this.status,
    this.hasVoted = false,
  });

  final String id;
  final String prompt;
  final String category;
  final String details;
  final String proposerAddress;
  final DateTime createdAt;
  final int voteCount;

  /// `'open'`, `'approved'`, or `'rejected'`
  final String status;

  /// Whether the current user has already voted on this proposal.
  final bool hasVoted;

  /// Truncated proposer address: `0x1234…abcd`
  String get shortProposer {
    if (proposerAddress.length <= 10) return proposerAddress;
    return '${proposerAddress.substring(0, 6)}…${proposerAddress.substring(proposerAddress.length - 4)}';
  }

  @override
  List<Object?> get props => [
        id,
        prompt,
        category,
        details,
        proposerAddress,
        createdAt,
        voteCount,
        status,
        hasVoted,
      ];
}
