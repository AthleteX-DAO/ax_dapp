// ignore_for_file: non_constant_identifier_names

Map<String, String> _MLBAthleteMappingPosition = {'RF' : 'Right Fielder', 'SS' : 'Short Stop', '1B' : 'First Baseman', '3B' : 'Third Baseman', 'CF' : 'Center Fielder', 'LF' : 'Left Fielder'};

String retrieveFullMLBAthletePosition(String currentMLBAthletePositon) {
  if(_MLBAthleteMappingPosition.containsKey(currentMLBAthletePositon)) {
    return _MLBAthleteMappingPosition[currentMLBAthletePositon]!;
  }
  return "No Position Found";
}