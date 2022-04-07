import 'package:ax_dapp/pages/scout/usecases/GetScoutAthletesDataUseCase.dart';
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/service/athleteModels/SportAthlete.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBAthlete.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'scout_athlete_data_use_case_test.mocks.dart';

@GenerateMocks([SportsRepo, MLBAthlete])
void main() {

  test('Fetch Athletes from All Repo Sources', () async {
    final SportsRepo<MLBAthlete> mlbRepo = MockSportsRepo();
    when(mlbRepo.sport).thenReturn(SupportedSport.MLB);
    final SportsRepo<SportAthlete> nflRepo = MockSportsRepo();
    when(nflRepo.sport).thenReturn(SupportedSport.NFL);

    final MLBAthlete athlete1 = MockMLBAthlete();
    when(athlete1.id).thenReturn(0);
    when(athlete1.name).thenReturn("Athlete 1");
    when(athlete1.team).thenReturn("Team 1");
    when(athlete1.position).thenReturn("Position 1");
    when(athlete1.price).thenReturn(0.01);
    when(athlete1.timeStamp).thenReturn("sample time");

    final MLBAthlete athlete2 = MockMLBAthlete();
    when(athlete2.id).thenReturn(0);
    when(athlete2.name).thenReturn("Athlete 2");
    when(athlete2.team).thenReturn("Team 2");
    when(athlete2.position).thenReturn("Position 2");
    when(athlete2.price).thenReturn(0.01);
    when(athlete2.timeStamp).thenReturn("sample time");

    final MLBAthlete athlete3 = MockMLBAthlete();
    when(athlete3.id).thenReturn(0);
    when(athlete3.name).thenReturn("Athlete 3");
    when(athlete3.team).thenReturn("Team 3");
    when(athlete3.position).thenReturn("Position 3");
    when(athlete3.price).thenReturn(0.01);
    when(athlete3.timeStamp).thenReturn("sample time");

    final MLBAthlete athlete4 = MockMLBAthlete();
    when(athlete4.id).thenReturn(0);
    when(athlete4.name).thenReturn("Athlete 4");
    when(athlete4.team).thenReturn("Team 4");
    when(athlete4.position).thenReturn("Position 4");
    when(athlete4.price).thenReturn(0.01);
    when(athlete4.timeStamp).thenReturn("sample time");


    when(mlbRepo.getSupportedPlayers())
        .thenAnswer((realInvocation) => Future.delayed(Duration(milliseconds: 800), (){
      return Future.value([athlete1, athlete2, athlete3]);
    }));

    when(nflRepo.getSupportedPlayers())
        .thenAnswer((realInvocation) => Future.delayed(Duration(milliseconds: 500), (){
          return Future.value([athlete4]);
    }));

    final useCase = GetScoutAthletesDataUseCase([mlbRepo, nflRepo]);
    final result = await useCase.fetchSupportedAthletes(SupportedSport.ALL);

    assert(result.length == 4);
    result.forEach((athlete) { print("${athlete.name}"); });
  });
}