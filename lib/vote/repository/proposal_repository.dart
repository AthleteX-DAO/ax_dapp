import 'package:ax_dapp/vote/models/market_proposal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore CRUD repository for market proposals and votes.
class ProposalRepository {
  const ProposalRepository({
    required FirebaseFirestore fireStore,
  }) : _firestore = fireStore;

  final FirebaseFirestore _firestore;

  static const _proposalsCollection = 'market_proposals';
  static const _votesCollection = 'market_proposal_votes';

  /// Stream of all proposals, ordered by vote count descending.
  Stream<List<MarketProposal>> getProposals() {
    return _firestore
        .collection(_proposalsCollection)
        .orderBy('voteCount', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_docToProposal).toList());
  }

  /// Creates a new market proposal document.
  Future<void> submitProposal({
    required String prompt,
    required String category,
    required String details,
    required String proposerAddress,
  }) async {
    await _firestore.collection(_proposalsCollection).add({
      'prompt': prompt,
      'category': category,
      'details': details,
      'proposerAddress': proposerAddress,
      'createdAt': FieldValue.serverTimestamp(),
      'voteCount': 0,
      'status': 'open',
    });
  }

  /// Casts a vote on a proposal. Checks for duplicate votes and increments
  /// the vote counter atomically.
  Future<void> castVote({
    required String proposalId,
    required String walletAddress,
  }) async {
    final alreadyVoted = await hasVoted(
      proposalId: proposalId,
      walletAddress: walletAddress,
    );
    if (alreadyVoted) return;

    final batch = _firestore.batch();

    // Record the vote
    final voteRef = _firestore.collection(_votesCollection).doc();
    batch.set(voteRef, {
      'proposalId': proposalId,
      'walletAddress': walletAddress,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Increment vote count on the proposal
    final proposalRef =
        _firestore.collection(_proposalsCollection).doc(proposalId);
    batch.update(proposalRef, {
      'voteCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// Returns `true` if [walletAddress] has already voted on [proposalId].
  Future<bool> hasVoted({
    required String proposalId,
    required String walletAddress,
  }) async {
    final query = await _firestore
        .collection(_votesCollection)
        .where('proposalId', isEqualTo: proposalId)
        .where('walletAddress', isEqualTo: walletAddress)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────

  MarketProposal _docToProposal(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return MarketProposal(
      id: doc.id,
      prompt: data['prompt'] as String? ?? '',
      category: data['category'] as String? ?? '',
      details: data['details'] as String? ?? '',
      proposerAddress: data['proposerAddress'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      voteCount: data['voteCount'] as int? ?? 0,
      status: data['status'] as String? ?? 'open',
    );
  }
}
