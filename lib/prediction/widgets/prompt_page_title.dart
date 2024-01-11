import 'package:ax_dapp/service/custom_styles.dart';
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
        return SizedBox(
          width: wid,
          height: 100,
          child: Row(
            children: [
              // Back Button
              SizedBox(
                width: 70,
                child: TextButton(
                  onPressed: () {
                    context.goNamed('predict');
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              // Prompt Title
              Expanded(
                child: SizedBox(
                  width: constraints.maxWidth / 2.5,
                  child: Text(
                    prompt,
                    style: textStyle(
                      Colors.white,
                      23,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ),
              ),
              // Share Button
              SizedBox(
                width: 50,
                child: TextButton(
                  onPressed: () {
                    final path = Uri.base.toString();

                    Clipboard.setData(
                      ClipboardData(
                        text: path,
                      ),
                    );
                  },
                  child: const Tooltip(
                    message: 'Share a link to this market',
                    child: Icon(
                      Icons.share,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
