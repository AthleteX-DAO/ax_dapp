enum BuildConfig { staging, release }

const buildConfig = String.fromEnvironment(
          'BUILD_TYPE',
          defaultValue: 'staging',
        ) ==
        'staging'
    ? BuildConfig.staging
    : BuildConfig.release;

const kCollateralizationMultiplier = 1000;
