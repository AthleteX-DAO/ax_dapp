import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
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
              Text(
                prompt,
                style: textStyle(
                  Colors.white,
                  23,
                  isBold: false,
                  isUline: false,
                ),
              ),
              Container(
                width: 18,
                alignment: Alignment.center,
                child: Text(
                  '|',
                  style: textStyle(
                    const Color.fromRGBO(100, 100, 100, 1),
                    24,
                    isBold: false,
                    isUline: false,
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
