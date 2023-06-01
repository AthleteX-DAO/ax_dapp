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
