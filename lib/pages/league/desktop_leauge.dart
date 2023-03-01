import 'package:ax_dapp/pages/league/widgets/dialogs/rules_dialog.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter/material.dart';

class DesktopLeague extends StatelessWidget {
  const DesktopLeague({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Global();
    return global.buildPage(
      context,
      Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.amber[400]!),
          ),
          child: TextButton(
            onPressed: () => {
              showDialog<void>(
                context: context,
                builder: (context) => const LeagueDialog(),
              ),
            },
            child: const Text(
              'Create a League',
              style: TextStyle(
                color: Colors.amber,
                fontFamily: 'OpenSans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
