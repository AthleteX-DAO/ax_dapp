import 'package:ax_dapp/league/league_game/widgets/dialogs/edit_rules/bloc/edit_rules_bloc.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmEdit extends StatelessWidget {
  const ConfirmEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditRulesBloc, EditRulesState>(
      listener: (context, state) {
        if (state.status == BlocStatus.error) {
          context.showWarningToast(
            title: 'Warning',
            description: state.errorMessage,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: Colors.amber[400]!),
                  ),
                ),
              ),
              onPressed: () => {
                context.read<EditRulesBloc>().add(UpdateLeague()),
                Navigator.pop(context),
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.amber,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
