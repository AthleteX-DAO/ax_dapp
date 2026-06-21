import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:ax_dapp/vote/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Community voting section — proposal list + new proposal form.
class MarketProposalSection extends StatefulWidget {
  const MarketProposalSection({super.key});

  @override
  State<MarketProposalSection> createState() => _MarketProposalSectionState();
}

class _MarketProposalSectionState extends State<MarketProposalSection> {
  static const _categories = [
    'Football',
    'Basketball',
    'Soccer',
    'Baseball',
    'Hockey',
    'Crypto',
    'Politics',
    'Entertainment',
    'Other',
  ];

  bool _isFormExpanded = false;
  final _promptController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedCategory = 'Football';

  @override
  void dispose() {
    _promptController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VoteState>(
      builder: (context, state) {
        final isWalletConnected = state.walletAddress.isNotEmpty;

        return Container(
          decoration: GoldTheme.panel(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: GoldTheme.darkPanel(radius: 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.how_to_vote_outlined,
                      color: GoldTheme.gold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Market Proposals',
                        style: textStyle(
                          Colors.white,
                          16,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isFormExpanded = !_isFormExpanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: _isFormExpanded
                            ? BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              )
                            : GoldTheme.goldButton(radius: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isFormExpanded ? Icons.close : Icons.add,
                              color:
                                  _isFormExpanded ? Colors.white70 : Colors.black,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isFormExpanded ? 'Cancel' : 'Propose',
                              style: TextStyle(
                                color: _isFormExpanded
                                    ? Colors.white70
                                    : Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable form
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _isFormExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                secondChild: const SizedBox.shrink(),
                firstChild: _buildForm(context, isWalletConnected),
              ),

              // Proposal list
              if (state.proposals.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: GoldTheme.gold.withOpacity(0.5),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No proposals yet. Be the first!',
                          style: textStyle(
                            GoldTheme.gold,
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: state.proposals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final proposal = state.proposals[index];
                    return _ProposalCard(
                      proposal: proposal,
                      isWalletConnected: isWalletConnected,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, bool isWalletConnected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Propose New Market',
            style: textStyle(
              Colors.white,
              14,
              isBold: true,
              isUline: false,
            ),
          ),
          const SizedBox(height: 12),
          // Prompt field
          TextField(
            controller: _promptController,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 14,
            ),
            decoration: _inputDecoration('Market prompt *'),
          ),
          const SizedBox(height: 10),
          // Category dropdown
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            dropdownColor: const Color(0xFF12122A),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 14,
            ),
            decoration: _inputDecoration('Category'),
            items: _categories
                .map(
                  (c) => DropdownMenuItem(value: c, child: Text(c)),
                )
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          const SizedBox(height: 10),
          // Details field
          TextField(
            controller: _detailsController,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 14,
            ),
            maxLines: 3,
            decoration: _inputDecoration('Details (optional)'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: isWalletConnected &&
                      _promptController.text.trim().isNotEmpty
                  ? () {
                      context.read<VoteBloc>().add(
                            SubmitProposal(
                              prompt: _promptController.text.trim(),
                              category: _selectedCategory,
                              details: _detailsController.text.trim(),
                            ),
                          );
                      _promptController.clear();
                      _detailsController.clear();
                      setState(() => _isFormExpanded = false);
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: isWalletConnected
                    ? GoldTheme.goldButton()
                    : BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                child: Center(
                  child: Text(
                    isWalletConnected ? 'Submit Proposal' : 'Connect Wallet',
                    style: TextStyle(
                      color: isWalletConnected ? Colors.black : Colors.grey,
                      fontFamily: 'OpenSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!isWalletConnected) ...[
            const SizedBox(height: 6),
            Text(
              'Connect your wallet to submit proposals',
              style: textStyle(
                Colors.white54,
                11,
                isBold: false,
                isUline: false,
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white54,
        fontFamily: 'OpenSans',
        fontSize: 13,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: GoldTheme.gold),
      ),
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _ProposalCard extends StatefulWidget {
  const _ProposalCard({
    required this.proposal,
    required this.isWalletConnected,
  });

  final MarketProposal proposal;
  final bool isWalletConnected;

  @override
  State<_ProposalCard> createState() => _ProposalCardState();
}

class _ProposalCardState extends State<_ProposalCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(12),
        decoration: GoldTheme.darkPanel().copyWith(
          border: Border.all(
            color: _hovering
                ? GoldTheme.gold.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Prompt
            Text(
              widget.proposal.prompt,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Category badge + proposer + vote
            Row(
              children: [
                // Category pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: GoldTheme.goldLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.proposal.category,
                    style: TextStyle(
                      color: GoldTheme.gold,
                      fontFamily: 'OpenSans',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.person_outline, color: Colors.white54, size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.proposal.shortProposer,
                  style: textStyle(
                    Colors.white54,
                    11,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                const Spacer(),
                // Vote button
                _VoteButton(
                  voteCount: widget.proposal.voteCount,
                  hasVoted: widget.proposal.hasVoted,
                  onTap: (widget.isWalletConnected && !widget.proposal.hasVoted)
                      ? () {
                          context.read<VoteBloc>().add(
                                CastVote(widget.proposal.id),
                              );
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.voteCount,
    required this.hasVoted,
    this.onTap,
  });

  final int voteCount;
  final bool hasVoted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = hasVoted ? Colors.grey : GoldTheme.gold;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(hasVoted ? 0.08 : 0.15),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasVoted ? Icons.check : Icons.arrow_upward,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '$voteCount',
              style: TextStyle(
                color: color,
                fontFamily: 'OpenSans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
