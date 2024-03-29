enum BuildConfig { staging, release }

const buildConfig = String.fromEnvironment(
          'BUILD_TYPE',
          defaultValue: 'staging',
        ) ==
        'staging'
    ? BuildConfig.staging
    : BuildConfig.release;

const baseApiUrl = (String.fromEnvironment(
          'BUILD_TYPE',
          defaultValue: 'staging',
        ) ==
        'staging')
    ? 'https://api-stage.athletex.io'
    : 'https://api.athletex.io';

const baseUrl = (String.fromEnvironment(
          'BUILD_TYPE',
          defaultValue: 'staging',
        ) ==
        'staging')
    ? 'https://stage.athletex.io/#/'
    : 'https://app.athletex.io/#/';

const kCollateralizationMultiplier = 1000;
