// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfl_athlete_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _NFLAthleteAPI implements NFLAthleteAPI {
  _NFLAthleteAPI(this._dio, {this.baseUrl}) {
    baseUrl ??= '$baseApiUrl/nfl';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<NFLAthlete>> getAllPlayers() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<NFLAthlete>> getPlayersById(playerIds) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playerIds.toJson());
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<NFLAthlete> getPlayer(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NFLAthlete>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NFLAthlete.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<NFLAthlete>> getPlayersByTeam(team) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'team': team};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<NFLAthlete>> getPlayersByPosition(position) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'position': position};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<NFLAthlete>> getPlayersByTeamAtPosition(team, position) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'team': team,
      r'position': position
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthlete>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthlete.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<NFLAthleteStats> getPlayerHistory(id, from, until) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'from': from, r'until': until};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NFLAthleteStats>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players/${id}/history',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NFLAthleteStats.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<NFLAthleteStats>> getPlayersHistory(
      playerIds, from, until) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'from': from, r'until': until};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(playerIds.toJson());
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<NFLAthleteStats>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/players/history',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => NFLAthleteStats.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
