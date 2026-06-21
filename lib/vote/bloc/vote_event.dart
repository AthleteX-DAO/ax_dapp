part of 'vote_bloc.dart';

/// Base class for vote events.
sealed class VoteEvent extends Equatable {
  const VoteEvent();

  @override
  List<Object?> get props => [];
}

/// Load the full dashboard: all sectors + proposals.
final class LoadDashboard extends VoteEvent {
  const LoadDashboard();
}

/// Switch the currently visible exchange tab.
final class SwitchTab extends VoteEvent {
  const SwitchTab({required this.tab});

  final ExchangeTab tab;

  @override
  List<Object?> get props => [tab];
}

/// Refresh data for the currently selected sector.
final class RefreshSectorData extends VoteEvent {
  const RefreshSectorData();
}

/// Submit a new market proposal.
final class SubmitProposal extends VoteEvent {
  const SubmitProposal({
    required this.prompt,
    required this.category,
    required this.details,
  });

  final String prompt;
  final String category;
  final String details;

  @override
  List<Object?> get props => [prompt, category, details];
}

/// Cast a vote on an existing proposal.
final class CastVote extends VoteEvent {
  const CastVote(this.proposalId);

  final String proposalId;

  @override
  List<Object?> get props => [proposalId];
}
