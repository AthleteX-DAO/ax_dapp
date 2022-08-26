enum BuildConfig { staging, release }

final buildConfig = BuildConfig.values.firstWhere(
  (BuildConfig buildConfig) =>
      buildConfig.name ==
      const String.fromEnvironment(
        'BUILD_TYPE',
        defaultValue: 'staging',
      ),
);
