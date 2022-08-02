import 'package:ax_dapp/debug/debug_helper_cubit.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebugHelper extends StatelessWidget {
  const DebugHelper({super.key});

  double get _size => 45;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => DebugHelperCubit(expanded: false),
        child: BlocBuilder<DebugHelperCubit, bool>(
          builder: (context, expanded) {
            return Positioned(
              right: 10,
              bottom: 10,
              width: expanded ? 400 : _size,
              height: expanded ? 700 : _size,
              child: Stack(
                children: [
                  const _TrackEvents(),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    width: _size,
                    height: _size,
                    child: Center(
                      child: Material(
                        child: IconButton(
                          onPressed: () =>
                              context.read<DebugHelperCubit>().toggleExpanded(),
                          icon: expanded
                              ? const Icon(Icons.compress_sharp)
                              : const Icon(Icons.expand_sharp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class _TrackEvents extends StatelessWidget {
  // ignore: use_super_parameters
  const _TrackEvents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TrackingCubit, TrackingState>(
        key: const Key('TrackEvents'),
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: ListView.separated(
              itemBuilder: (_, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Text(state.loggedEvents[index].name),
                      )
                    ] +
                    state.loggedEvents[index].params.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  child: Text(
                                    '${entry.key}: ',
                                  ),
                                ),
                                DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  child: Text(
                                    entry.value.toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemCount: state.loggedEvents.length,
            ),
          );
        },
      );
}
