import 'package:ax_dapp/league/league_draft/bloc/league_draft_bloc.dart';
import 'package:ax_dapp/league/models/draft_apt.dart';
import 'package:ax_dapp/util/get_sports_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class APTCard extends StatelessWidget {
  const APTCard({
    super.key,
    required this.apt,
    required this.teamSize,
  });

  final DraftApt apt;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    const sportIconSize = 30.0;
    const statusIconSize = 30.0;
    const statusIcon = Icons.add_box_outlined;
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
              Text(
                apt.name
                    .split(' ')
                    .sublist(0, apt.name.split(' ').length - 1)
                    .join(' '),
              ),
              Text(apt.team),
            ],
          ),
          Text('${apt.bookPrice?.toStringAsFixed(2)} AX'),
          Text('${apt.bookPricePercent?.toStringAsFixed(2)}%'),
          IconButton(
            icon: const Icon(
              statusIcon,
              color: statusIconColor,
              size: statusIconSize,
            ),
            onPressed: () {
              context.read<LeagueDraftBloc>().add(
                    AddAptToTeam(
                      apt: apt,
                      teamSize: teamSize,
                    ),
                  );
            },
          )
        ],
      ),
    );
  }
}
