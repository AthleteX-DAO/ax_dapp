const Map<String, String> _mlbAthleteMappingPosition = {
  'RF': 'Right Fielder',
  'SS': 'Short Stop',
  '1B': 'First Baseman',
  '2B': 'Second Baseman',
  '3B': 'Third Baseman',
  'CF': 'Center Fielder',
  'LF': 'Left Fielder',
  'RP': 'Relief Pitcher',
  'SP': 'Starting Pitcher',
  'C': 'Catcher',
  'DH': 'Designated Hitter',
};

const Map<String, String> _nflAthleteMappingPosition = {
  'C': 'Center',
  'RB': 'Running Back',
  'QB': 'Quarterback',
  'HB': 'Halfback',
  'WR': 'Wide Receiver',
  'DE': 'Defensive End',
  'FB': 'Fullback',
  'TE': 'Tight End',
  'OL': 'Offensive Lineman',
  'OT': 'Offensive Tackle',
  'G': 'Guard',
  'LG': 'Left Guard',
  'RG': 'Right Guard',
  'T': 'Tackle',
  'LS': 'Long Snapper',
  'LT': 'Left Tackle',
  'RT': 'Right Tackle',
  'K': 'Kicker',
  'KR': 'Kick Returner',
  'DL': 'Defensive Lineman',
  'DT': 'Defensive Tackle',
  'NT': 'Nose Tackle',
  'LB': 'Linebacker',
  'ILB': 'Inside Linebacker',
  'OLB': 'Outside Linebacker',
  'MLB': 'Middle Linebacker',
  'DB': 'Defensive Back',
  'CB': 'Corner Back',
  'FS': 'Free Safety',
  'SS': 'Strong Safety',
  'S': 'Safety',
  'P': 'Punter',
  'PR': 'Punt Returner',
};

const Map<String, String> _mlbAthleteMappingTeamNickname = {
  'ARI': 'Diamondbacks',
  'ATL': 'Braves',
  'BAL': 'Orioles',
  'BOS': 'Red Sox',
  'CHC': 'Cubs',
  'CHW': 'White Sox',
  'CIN': 'Reds',
  'CLE': 'Guardians',
  'COL': 'Rockies',
  'DET': 'Tigers',
  'HOU': 'Astros',
  'KC': 'Royals',
  'LAA': 'Angels',
  'LAD': 'Dodgers',
  'MIA': 'Marlins',
  'MIL': 'Brewers',
  'MIN': 'Twins',
  'NYM': 'Mets',
  'NYY': 'Yankees',
  'OAK': 'Athletics',
  'PHI': 'Phillies',
  'PIT': 'Pirates',
  'SD': 'Padres',
  'SEA': 'Mariners',
  'SF': 'Giants',
  'STL': 'Cardinals',
  'TB': 'Rays',
  'TEX': 'Rangers',
  'TOR': 'Blue Jays',
  'WSH': 'Nationals',
};

const Map<String, String> _mlbAthleteMappingTeamCity = {
  'ARI': 'Arizona',
  'ATL': 'Atlanta',
  'BAL': 'Baltimore',
  'BOS': 'Boston',
  'CHC': 'Chicago',
  'CHW': 'Chicago',
  'CIN': 'Cincinnati',
  'CLE': 'Cleveland',
  'COL': 'Colorado',
  'DET': 'Detroit',
  'HOU': 'Houston',
  'KC': 'Kansas City',
  'LAA': 'Los Angeles',
  'LAD': 'Los Angeles',
  'MIA': 'Miami',
  'MIL': 'Milwaukee',
  'MIN': 'Minnesota',
  'NYM': 'New York',
  'NYY': 'New York',
  'OAK': 'Oakland',
  'PHI': 'Philadelphia',
  'PIT': 'Pittsburgh',
  'SD': 'San Diego',
  'SEA': 'Seattle',
  'SF': 'St. Louis',
  'STL': 'Seattle',
  'TB': 'Tampa Bay',
  'TEX': 'Texas',
  'TOR': 'Toronto',
  'WSH': 'Washington',
};

const Map<String, String> _nflAthleteMappingTeamNickName = {
  'TB': 'Buccaneers',
  'KC': 'Chiefs',
  'JAX': 'Jaguars',
  'GB': 'Packers',
  'BUF': 'Bills',
  'ATL': 'Falcons',
  'ARI': 'Cardinals',
  'BAL': 'Ravens',
  'CAR': 'Panthers',
  'CHI': 'Bears',
  'CIN': 'Bengals',
  'CLE': 'Browns',
  'DAL': 'Cowboys',
  'DEN': 'Broncos',
  'DET': 'Lions',
  'HOU': 'Texans',
  'IND': 'Colts',
  'LV': 'Raiders',
  'LAC': 'Chargers',
  'LAR': 'Rams',
  'MIA': 'Dolphins',
  'MIN': 'Vikings',
  'NE': 'Patriots',
  'NO': 'Saints',
  'NYG': 'Giants',
  'NYJ': 'Jets',
  'PHI': 'Eagles',
  'PIT': 'Steelers',
  'SF': '49ers',
  'SEA': 'Seahawks',
  'TEN': 'Titans',
  'WAS': 'Commanders',
};

const Map<String, String> _nflAthleteMappingTeamCity = {
  'ARI': 'Arizona',
  'ATL': 'Atlanta',
  'BAL': 'Baltimore',
  'BUF': 'Buffalo',
  'CAR': 'Carolina',
  'CHI': 'Chicago',
  'CIN': 'Cincinnati',
  'CLE': 'Cleveland',
  'DAL': 'Dallas',
  'DEN': 'Denver',
  'DET': 'Detroit',
  'GB': 'Green Bay',
  'HOU': 'Houston',
  'IND': 'Indianapolis',
  'JAX': 'Jacksonville',
  'KC': 'Kansas City',
  'LV': 'Las Vegas',
  'LAC': 'Los Angeles',
  'LAR': 'Los Angeles',
  'MIA': 'Miami',
  'MIN': 'Minnesota',
  'NE': 'New England',
  'NO': 'New Orleans',
  'NYG': 'New York',
  'NYJ': 'New York',
  'PHI': 'Philadelphia',
  'PIT': 'Pittsburgh',
  'SF': 'San Francisco',
  'SEA': 'Seattle',
  'TB': 'Tampa Bay',
  'TEN': 'Tennessee',
  'WAS': 'Washington',
};

String retrieveFullMLBAthletePosition(String currentMLBAthletePositon) {
  if (_mlbAthleteMappingPosition.containsKey(currentMLBAthletePositon)) {
    return _mlbAthleteMappingPosition[currentMLBAthletePositon]!;
  }
  return 'No Position Found';
}

String retrieveFullNFLAthletePosition(String currentNFLAthletePosition) {
  if (_nflAthleteMappingPosition.containsKey(currentNFLAthletePosition)) {
    return _nflAthleteMappingPosition[currentNFLAthletePosition]!;
  }
  return 'No Position Found';
}

String retrieveNFLTeamNickName(String currentNFLAthleteShortName) {
  if (_nflAthleteMappingTeamNickName.containsKey(currentNFLAthleteShortName)) {
    return _nflAthleteMappingTeamNickName[currentNFLAthleteShortName]!;
  }
  return 'N/A';
}

String retrieveNFLTeamCityName(String currentNFLAthleteTeamShortName) {
  if (_nflAthleteMappingTeamCity.containsKey(currentNFLAthleteTeamShortName)) {
    return _nflAthleteMappingTeamCity[currentNFLAthleteTeamShortName]!;
  }
  return 'N/A';
}

String retrieveTeamNickname(String curMLBAthleteTeamShortname) {
  if (_mlbAthleteMappingTeamNickname.containsKey(curMLBAthleteTeamShortname)) {
    return _mlbAthleteMappingTeamNickname[curMLBAthleteTeamShortname]!;
  } else {
    return 'N/A';
  }
}

String retrieveTeamCityName(String curMLBAthleteTeamShortname) {
  if (_mlbAthleteMappingTeamCity.containsKey(curMLBAthleteTeamShortname)) {
    return _mlbAthleteMappingTeamCity[curMLBAthleteTeamShortname]!;
  } else {
    return 'N/A';
  }
}
