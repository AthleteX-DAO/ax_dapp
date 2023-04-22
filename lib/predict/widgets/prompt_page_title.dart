import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PromptPageTitle extends StatelessWidget {
  const PromptPageTitle({
    super.key,
    required this.wid,
    required this.prompt,
    required double width,
    required double height,
  })  : _width = width,
        _height = height;

  final double wid;
  final String prompt;
  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: wid,
          height: 100,
          child: Row(
            children: [
              // Player Name
              Text(
                prompt,
                style: textStyle(
                  Colors.white,
                  23,
                  isBold: false,
                  isUline: false,
                ),
              ),
              // '|' Symbol
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
