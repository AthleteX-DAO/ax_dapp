import 'package:flutter/foundation.dart';

enum BuildConfig { staging, release }

const buildConfig = String.fromEnvironment(
          'BUILD_TYPE',
          defaultValue: 'staging',
        ) ==
        'staging'
    ? BuildConfig.staging
    : BuildConfig.release;

String get baseApiUrl {
  if (kIsWeb) {
    final host = Uri.base.host;
    if (host == 'localhost' || host == '127.0.0.1' || host.isEmpty) {
      return 'http://localhost:8000';
    }
  }
  if (kDebugMode) {
    return 'http://localhost:8000';
  }
  return const String.fromEnvironment(
            'BUILD_TYPE',
            defaultValue: 'staging',
          ) ==
          'staging'
      ? 'http://74.208.213.94:8000'
      : 'https://api.athletex.io';
}

const baseUrl = (String.fromEnvironment(
          'BUILD_TYPE',
          defaultValue: 'staging',
        ) ==
        'staging')
    ? 'https://stage.athletex.io/#/'
    : 'https://app.athletex.io/#/';

const kCollateralizationMultiplier = 1000;
