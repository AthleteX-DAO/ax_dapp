class SupportedNFLAthletes {
  //QBs
  static const int _jAllen = 20737;
  static const int _jHerbert = 21681;
  static const int _pMahomes = 18890;
  static const int _lJackson = 22049;

  //RBs
  static const int _jTaylor = 21837;
  static const int _dHenry = 17959;
  static const int _cMcCaffrey = 18877;
  static const int _aEkeler = 19562;

  //WRs
  static const int _cKupp = 18882;
  static const int _jJefferson = 22555;
  static const int _jChase = 22564;

  //TEs
  static const int _tKelce = 15048;
  static const int _mAndrews = 19803;
  static const int _kPitts = 22508;
  static const int _gKittle = 19063;

  static const List<int> _athleteIdsList = [
    //Example below
    //QBs
    _jAllen,
    _jHerbert,
    _pMahomes,
    _lJackson,

    //RBs
    _jTaylor,
    _dHenry,
    _cMcCaffrey,
    _aEkeler,

    //WRs
    _cKupp,
    _jJefferson,
    _jChase,

    //TEs
    _tKelce,
    _mAndrews,
    _kPitts,
    _gKittle,
  ];

  List<int> getSupportedAthletesList() {
    return _athleteIdsList;
  }
}
