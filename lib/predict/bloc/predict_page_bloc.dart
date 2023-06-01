// ignore_for_file: cast_nullable_to_non_nullable

import 'dart:convert';

import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:http/http.dart' as http;

part 'predict_page_event.dart';
part 'predict_page_state.dart';

class PredictPageBloc extends Bloc<PredictPageEvent, PredictPageState> {
  PredictPageBloc({
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
  })  : _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChangesUseCase,
        super(const PredictPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<LoadPredictionsEvent>(_onLoadPredictions);
    add(const WatchAppDataChangesStarted());
  }

  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  // final List<PredictionModel> questions = [
  //   const PredictionModel(
  //     prompt: 'Celtics vs 76ers: Game 6',
  //     details:
  //         'This market will resolve to “Red Sox” if Boston Red Sox win the game against Baltimore Orioles on April 26, 2023. If the Baltimore Orioles win the game the market will resolve to “Orioles”. The resolution source for this market will be MLB or a consensus of credible reporting will also suffice. If the fight is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
  //     address: '0x990898a024ecE7E1CA39FbDed9244001d4ec0c6d',
  //     yesTokenAddress: '0x9e193Dce9F58262EE8f9090E3346Fc24F28e5fEF',
  //     noTokenAddress: '0x208AD891f67E229306a3202bf5d77d7712aA0b8d',
  //   ),
  //   const PredictionModel(
  //     prompt: 'Nuggets vs Suns: Game 6',
  //     details:
  //         'This market will resolve to “Nuggets” if Denver Nuggets win the game against Phoenix Suns on May 11, 2023. If the Phoenix Suns win the game the market will resolve to “Suns”. The resolution source for this market will be NBA or a consensus of credible reporting will also suffice. If the game is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
  //     address: '0x98E944F4e4205afEb936f56e39Ae469De8DFbE3d',
  //     yesTokenAddress: '0x300aE756362A1f60528e4FB4729da5CD9b6CF3a1',
  //     noTokenAddress: '0x36E3554522f6F3a94f1616bC9A0c11E7E6a8d229',
  //   ),
  //   const PredictionModel(
  //     prompt: 'Devils vs Hurricanes: Game 5',
  //     details:
  //         'This market will resolve to “Hurricanes” if Carolina Hurricanes win the game against the New Jersey Devils on May 11, 2023. If the New Jersey Devils win the game the market will resolve to “Devils”. The resolution source for this market will be NHL or a consensus of credible reporting will also suffice. If the game is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
  //     address: '0x0FA810C2E8C3A50938afcD057eDA4364b19372F9',
  //     yesTokenAddress: '0x59B395B954F6A175646823453C8C5a7eDf8e0887',
  //     noTokenAddress: '0x839F330F636f2a98Ae6bEE5aC8bCCA03D2572314',
  //   ),
  //   const PredictionModel(
  //     prompt: 'Kraken vs Stars: Game 5',
  //     details:
  //         'This market will resolve to “Kraken” if Seattle Kraken win the game against the Dallas Stars on May 11, 2023. If the Dallas Stars win the game the market will resolve to “Stars”. The resolution source for this market will be NHL or a consensus of credible reporting will also suffice. If the game is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
  //     address: '0xC45085e3e9F3fE86BFBc10D0eEBa28a1359b5A54',
  //     yesTokenAddress: '0xa3529A89f34519B37EDC84d6e106eB718A4CE02e',
  //     noTokenAddress: '0xD356CFF6F58Fd037C8cAFD02f3179fB95A08655c',
  //   ),
  // ];

  Future<void> fetchProposals() async {
    final url = Uri.parse('https://hub.snapshot.org/graphql');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'query': '''
        query Proposals {
          proposals(where: {space_in: ["athletex.eth"]}) {
            id
            title
            body
          }
        }
      '''
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      return;
    }

    final result = jsonDecode(response.body);

    final proposalsData = result['data']['proposals'];
    final proposalList =
        List<Map<String, dynamic>>.from(proposalsData as Iterable<dynamic>);

    final proposalMap = proposalList
        .map(
          (proposal) => {
            'id': proposal['id'] as String,
            'title': proposal['title'] as String,
            'body': proposal['body'] as String,
          },
        )
        .toList();

    // Print the title and body pairs
    questions.clear();
    for (final proposal in proposalMap) {
      final id = proposal['id'] as String;
      final title = proposal['title'] as String;
      final body = proposal['body'] as String;
      questions.add(
        PredictionModel(
          id: id,
          prompt: title,
          details: body,
          address: '',
          yesTokenAddress: '',
          noTokenAddress: '',
        ),
      );
    }
  }

  final List<PredictionModel> questions = [
    // const PredictionModel(
    //   prompt: 'Los Angeles Lakers vs. Denver Nuggets: Game 4',
    //   details:
    //       'In the upcoming NBA game, scheduled for May 22 at 8:30 PM ET: If the Los An es Lakers win, the market will resolve to “Lakers”.  If the Denver Nuggets win, the market will resolve to “Nuggets”.  If the game is not completed by May 26, 2023 (11:59:59 PM ET), the market will resolve 50-50.',
    //   address: '0xC29F9Db3C4A771fC266431bb0D70308B762F8770',
    //   yesTokenAddress: '',
    //   noTokenAddress: '',
    // ),
  ];

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<PredictPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        emit(
          state.copyWith(
            status: BlocStatus.loading,
          ),
        );

        final appConfig = appData.appConfig;
      },
    );
  }

  Future<void> _onLoadPredictions(
    LoadPredictionsEvent _,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(predictions: [], status: BlocStatus.loading),
    );

    if (questions.isEmpty) {
      await fetchProposals();
    }

    if (questions.isNotEmpty) {
      emit(
        state.copyWith(
          predictions: questions,
          status: BlocStatus.success,
        ),
      );
    }
  }

  Future<void> _onYesButtonTapped() async {
    emit(
      state.copyWith(),
    );
  }

  Future<void> _onNoButtonTapped() async {
    emit(
      state.copyWith(),
    );
  }
}
