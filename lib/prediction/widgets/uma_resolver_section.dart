import 'package:ax_dapp/prediction/widgets/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UmaResolverSection extends StatefulWidget {
  const UmaResolverSection({
    super.key,
    required this.marketRules,
    required this.resolverAddress,
    required this.createdAt,
    required this.resolutionDeadline,
  });

  final String marketRules;
  final String resolverAddress;
  final String createdAt;
  final String resolutionDeadline;

  @override
  State<UmaResolverSection> createState() => _UmaResolverSectionState();
}

class _UmaResolverSectionState extends State<UmaResolverSection> {
  bool _showFullRules = false;
  String _activeTab = 'Rules';

  @override
  Widget build(BuildContext context) {
    return _buildGlassTile(
      title: 'Market Intel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(),
          const SizedBox(height: 12),
          _buildActiveContent(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    const tabs = ['Rules', 'UMA Resolution', 'AI Insights'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tab in tabs) _buildTabChip(tab),
      ],
    );
  }

  Widget _buildTabChip(String tab) {
    final isActive = _activeTab == tab;
    IconData icon;
    switch (tab) {
      case 'UMA Resolution':
        icon = Icons.verified;
        break;
      case 'AI Insights':
        icon = Icons.auto_awesome;
        break;
      default:
        icon = Icons.rule;
    }

    return GestureDetector(
      onTap: () {
        setState(() => _activeTab = tab);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? primaryOrangeColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isActive ? primaryOrangeColor : Colors.white.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? primaryOrangeColor : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              tab,
              style: textStyle(
                isActive ? primaryOrangeColor : Colors.white70,
                12,
                isBold: true,
                isUline: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveContent() {
    switch (_activeTab) {
      case 'UMA Resolution':
        return _buildUmaContent();
      case 'AI Insights':
        return _buildAiContent();
      default:
        return _buildRulesContent();
    }
  }

  Widget _buildRulesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullRules
              ? widget.marketRules
              : _truncateText(widget.marketRules, 220),
          style: textStyle(
            Colors.white70,
            13,
            isBold: false,
            isUline: false,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _showFullRules = !_showFullRules;
            });
          },
          child: Row(
            children: [
              Icon(
                _showFullRules ? Icons.expand_less : Icons.expand_more,
                color: primaryOrangeColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                _showFullRules ? 'Show less' : 'Show more',
                style: textStyle(
                  primaryOrangeColor,
                  12,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const Icon(
              Icons.security,
              color: Colors.white54,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Resolution powered by UMA oracle with on-chain enforcement.',
                style: textStyle(
                  Colors.white70,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUmaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: primaryOrangeColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryOrangeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.verified,
                  color: Color(0xFFFF6B35),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resolver Address',
                      style: textStyle(
                        greyTextColor,
                        11,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      widget.resolverAddress,
                      style: textStyle(
                        Colors.white,
                        12,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: widget.resolverAddress),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Resolver address copied!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.copy,
                  color: Colors.white54,
                  size: 18,
                ),
                tooltip: 'Copy address',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMiniStat(
                title: 'Created',
                value: widget.createdAt,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniStat(
                title: 'Deadline',
                value: widget.resolutionDeadline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Propose Resolution button
        const SizedBox(
          width: double.infinity,
          child: ProposeButton(),
        ),
      ],
    );
  }

  Widget _buildAiContent() {
    final summary = _truncateText(widget.marketRules, 160);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryOrangeColor.withOpacity(0.15),
                Colors.white.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: primaryOrangeColor.withOpacity(0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insights,
                    color: primaryOrangeColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI Contextual Insights',
                    style: textStyle(
                      Colors.white,
                      13,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                summary,
                style: textStyle(
                  Colors.white70,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInsightPill('Sentiment: neutral'),
                  _buildInsightPill('Watch resolution deadline'),
                  _buildInsightPill('Verify oracle response on-chain'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle(
              greyTextColor,
              11,
              isBold: false,
              isUline: false,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textStyle(
              Colors.white,
              12,
              isBold: true,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Text(
        text,
        style: textStyle(
          Colors.white70,
          11,
          isBold: false,
          isUline: false,
        ),
      ),
    );
  }

  Widget _buildGlassTile({
    required String title,
    required Widget child,
    bool compact = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryOrangeColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryOrangeColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle(
              Colors.white,
              compact ? 12 : 16,
              isBold: true,
              isUline: false,
            ),
          ),
          if (!compact) const SizedBox(height: 12),
          if (compact) const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
