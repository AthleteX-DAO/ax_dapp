import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PromptPageTitle extends StatelessWidget {
  const PromptPageTitle({
    super.key,
    required this.wid,
    required this.prompt,
  });

  final double wid;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: wid,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryOrangeColor.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryOrangeColor.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back Button
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    context.goNamed('predict');
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Colors.white,
                  ),
                  tooltip: 'Back to markets',
                ),
              ),
              const SizedBox(width: 16),
              // Prompt Title
              Expanded(
                child: Text(
                  prompt,
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: true,
                    isUline: false,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              // Share Button
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    final path = Uri.base.toString();
                    Clipboard.setData(ClipboardData(text: path));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.share,
                    size: 24,
                    color: Colors.white,
                  ),
                  tooltip: 'Share a link to this market',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
