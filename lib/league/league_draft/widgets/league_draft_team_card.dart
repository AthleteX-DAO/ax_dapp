import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/models/draft_apt.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTeamCard extends StatelessWidget {
  const MyTeamCard({
    super.key,
    required this.apt,
  });

  final DraftApt apt;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeagueDraftBloc, LeagueDraftState>(
      builder: (context, state) {
        final bloc = context.read<LeagueDraftBloc>();

        const sportIconSize = 30.0;
        const statusIconSize = 30.0;
        const statusIconColor = Colors.white;

        return Container(
          height: 90,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF646464),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                getSportIcon(apt.sport),
                color: Colors.grey[400],
                size: sportIconSize,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(apt.name),
                  Text(apt.team),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline_outlined,
                  color: statusIconColor,
                  size: statusIconSize,
                ),
                onPressed: () {
                  bloc.add(RemoveAptFromTeam(apt: apt));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
