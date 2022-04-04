class SupportedMLBAthletes {
  static final int joseRamirezId = 10000352;
  static final int marcusSemienId = 10000908;
  static final int starlingMarteId = 10001009;
  static final int bryceHarperId = 10001365;
  static final int carlosCorreaId = 10001918;
  static final int aaronJudgeId = 10002087;
  static final int treaTurnerId = 10002094;
  static final int juanSotoId = 10006794;
  static final int fernandoTatisId = 10007217;
  static final int vladimirGuerreroId = 10007501;

  static final Map<String, List<int>> _athleteIdDict = {
    "ids": [
      joseRamirezId,
      marcusSemienId,
      starlingMarteId,
      bryceHarperId,
      carlosCorreaId,
      aaronJudgeId,
      treaTurnerId,
      juanSotoId,
      fernandoTatisId,
      vladimirGuerreroId
    ],
  };

  Map<String, List<int>> getSupportedAthletesList(){
    return _athleteIdDict;
  }
}