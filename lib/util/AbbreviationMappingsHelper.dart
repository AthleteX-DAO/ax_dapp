Map<String, String> position = {'RF' : 'Right Fielder', 'SS' : 'Short Stop', '1B' : 'First Baseman', '3B' : 'Third Baseman', 'CF' : 'Center Fielder', 'LF' : 'Left Fielder'};

String getFullAthletePosition(String currentAthletePositon) {
  if(position.containsKey(currentAthletePositon)) {
    return position[currentAthletePositon]!;
  }
  return "No Position Found";
}