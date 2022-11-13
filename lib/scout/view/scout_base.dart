// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/buy_dialog.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/view/desktop_scout.dart';
import 'package:ax_dapp/scout/view/mobile_scout.dart';
import 'package:ax_dapp/scout/widgets/buy_text.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class Scout extends StatefulWidget {
  const Scout({
    super.key,
  });

  @override
  State<Scout> createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
  Global global = Global();
  final myController = TextEditingController(text: input);
  static String input = '';
  static bool isLongToken = true;
  static int sportState = 0;
  static SupportedSport _selectedSport = SupportedSport.all;
  String allSportsTitle = 'All Sports';
  String longTitle = 'Long';
  int _widgetIndex = 0;
  int _marketVsBookPriceIndex = 0;
  EthereumChain? _selectedChain;
  String selectedAthlete = '';
  List<AthleteScoutModel> filteredAthletes = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    input = '';
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    const sportFilterIconSz = 14.0;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // breaks the code, will come back to it later(probably)

    return global.buildPage(
      context,
      BlocBuilder<ScoutPageBloc, ScoutPageState>(
        buildWhen: (previous, current) {
          return current.status.name.isNotEmpty ||
              previous.selectedChain.chainId != current.selectedChain.chainId;
        },
        builder: (context, state) {
          final bloc = context.read<ScoutPageBloc>();
          if (global.athleteList.isEmpty) {
            global.athleteList = state.athletes;
          }
          filteredAthletes = state.filteredAthletes;
          if (_selectedChain != state.selectedChain) {
            _selectedChain = state.selectedChain;
            bloc.add(
              FetchScoutInfoRequested(),
            );
          }
          _selectedSport = state.selectedSport;
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              height: _height * 0.85 + 41,
              width: _width * 0.99,
              child: kIsWeb
                  ? DesktopScout(
                      state: state,
                    )
                  : MobileScout(
                      state: state,
                    ),
            ),
          );
        },
      ),
    );
  }
}
