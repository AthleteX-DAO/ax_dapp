# AthleteX dApp UI

[![Deploy Staging](https://github.com/SportsToken/ax_dapp/actions/workflows/deploy_staging.yml/badge.svg?branch=develop)](https://github.com/SportsToken/ax_dapp/actions/workflows/deploy_staging.yml)
[![Deploy Release](https://github.com/SportsToken/ax_dapp/actions/workflows/release_deploy.yml/badge.svg?branch=main)](https://github.com/SportsToken/ax_dapp/actions/workflows/release_deploy.yml)
[![Linter](https://github.com/SportsToken/ax_dapp/actions/workflows/linter.yml/badge.svg?branch=main)](https://github.com/SportsToken/ax_dapp/actions/workflows/linter.yml)

Front end UI for athlete equity MVBP built using flutter

## Getting Started 🚀

<!-- Mnenomic -->
<!-- web lady wheat index recipe chunk urge boost hungry critic language crossnote: this mnemonic is not secure; don't use it on a public blockchain.
 -->

## Bloc Architecture ✨

### Overview 🔍

Layering our code is very important and helps us iterate quickly and with confidence. Each layer has a single responsibility and can be used and tested in isolation. This allows us to keep changes contained to a specific layer in order to minimize the impact on the entire application.

For example:

- if engineering decides to migrate to GraphQL instead of a REST API, only the data layer will be impacted
- if product wants to change a criteria for the business, only the domain layer will be impacted
- if design wants to change the application theme, only the presentation layer will be impacted

### Layers 📚

![bloc_architecture_diagram](https://user-images.githubusercontent.com/29372054/178124498-6675ede0-d0ea-40eb-98dc-136991af6b28.png)

#### Data Layer

This layer is the lowest layer and is responsible for retrieving raw data from external sources(database, REST API, GraphQL backend) or device APIs. Usually packages in this layer will expose `clients` (e.g.: `storage_client`, `location_client`, `auth0_api_client`, etc...).

- Packages in the data layer should not import any Flutter dependencies.
- Clients can be reused and even published on pub.dev as standalone packages.
- Packages in the data layer should not be dependent on other clients.
- This layer should not interact with any other layers.
- A single client should be created per data source.

**Note**: This layer can be considered the "engineering" layer because it focuses on how to process/transform data in a performant way.

#### Domain Layer

This layer is a compositional layer meaning that it composes one or more data clients and applies "business rules" to the data. We call each component in this layer a `repository` (e.g.: `user_repository`, `weather_repository`, `payments_repository`, etc...).

- Repositories should not import any Flutter dependencies.
- Packages in the repository layer should not be dependent on other repositories.
- This layer should only interact with the data layer.
- One repository should be created per domain model.

**Note**: This layer can be considered the "product" layer. The business/product owner will determine the rules/acceptance criteria for how to combine data from one or more data providers into a unit that brings value to the customer.

#### Business Logic Layer

This layer composes one or more repositories and contains logic for how to surface the business rules via a specific feature or use-case. This layer uses the [bloc package](https://pub.dev/packages/bloc) to manage the logic associated with each feature. We call each component in this layer a `bloc` (e.g.: `login_bloc`, `weather_forecast_bloc`, `settings_bloc`, etc...).

- The business logic layer should have no dependency on the Flutter SDK
- The business logic layer should not have direct dependencies on other business logic components.
- This layer should only interact with the domain layer.
- One bloc/cubit should be created per feature(see also [cubit vs bloc](https://bloclibrary.dev/#/coreconcepts?id=cubit-vs-bloc)).

**Note**: This layer can be considered the "feature" layer. Design and product will determine the rules for how a particular feature will function.

#### Presentation Layer

This layer takes the state from the business logic layer and renders a UI for the customer to interact with. This layer uses the [flutter_bloc package](https://pub.dev/packages/flutter_bloc) to render widgets based on the bloc's state and to allow the user to interact with the bloc through events.

- The presentation layer should have a dependency on the Flutter SDK, since this is the Flutter layer of the application which uses widgets to "paint pixels" on the screen.
- This layer should only interact with the business logic layer.

**Note**: This layer can be considered the "design" layer. Designers will determine the user interface in order to provide the best possible experience for the customer.

### Project Structure 📁

The project should adhere to the Multimodule Monorepo structure. This is an approach that compliments the layered architecture described above. It allows you to maintain a single repository(git) with multiple submodules. In some cases, data clients can be open-sourced and may eventually not be included in the project. Several benefits of maintaining a single project with multiple submodules are:

- **Discoverability:** all the packages/code can be accessed from the IDE project view
- **Separation of concerns:** following clean architecture recommendations, each package can have a single purpose, and be part of a layer.
- **Testability and composition:** each layer has clear rules for dependencies and should be tested independently of other layers.
- **Reusability:** do you have more Dart/Flutter projects? Do not write the same code twice!
- **Clarity:** clear understanding of your dependency graph (check out [pubviz](https://pub.dev/packages/pubviz))

The application should use a feature-driven directory structure. This project structure enables us to scale the project by having self-contained features and allows developers to work on different features in parallel.
Developers should make use of barrel files to export necessary files from any directory(except for `bloc`/`cubit` which are generated using [vscode bloc extensions](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc) and make use of `part` and `part of`).

An example of a Multimodule Monorepo directory structure is below:

```sh
├── lib
│   ├── app
│   │   ├── bloc
│   │   ├── extensions
│   │   ├── models
│   │   └── view
│   ├── home
│   │   └── view
│   ├── l10n
│   │   └── arb
│   ├── login
│   │   ├── bloc
│   │   ├── view
│   │   └── widgets
│   ├── sign_up
│   │   ├── bloc
│   │   ├── view
│   │   └── widgets
├── packages
│   ├── meta_weather_api_client
│   ├── user_repository
│   └── weather_repository
```

## Naming Conventions 📝

- [Effective dart](https://dart.dev/guides/language/effective-dart/style).
- [Bloc library naming conventions](https://bloclibrary.dev/#/blocnamingconventions?id=naming-conventions).

## Formatting Conventions 🔠

Code formatters fix style, spacing, line jumps, comments, which helps enforce programming and formatting rules that can be easily automated. This helps reduce future code diffs by delegating formatting concerns to an automatic tool rather than individual developers.

- To check code formatting run:

```sh
flutter format --set-exit-if-changed lib test
```

- Formatting checks should be automated via CI/CD pipelines.
- [Effective dart formatting guidelines](https://dart.dev/guides/language/effective-dart/style#do-format-your-code-using-dart-format).

## Linting ⚠️

Code linters analyze code statically to flag programming errors, catch bugs, stylistic errors, and suspicious constructs.

- To analyze the code run:

```sh
flutter analyze lib test
```

- The project should use [very_good_analysis](https://pub.dev/packages/very_good_analysis) for a startup friendly set of lint rules.
- Each submodule should contain it's own `analysis_options.yaml` file including the `very_good_analysis`.
- Optionally, specific rules could be enabled, disabled or have their severity changed.
- Doc-style comments(`///`) should be used for all public members and public APIs; enforcing is done by [very_good_analysis](https://pub.dev/packages/very_good_analysis) through [public_member_api_docs](https://dart-lang.github.io/linter/lints/public_member_api_docs.html) and [package_api_docs](https://dart-lang.github.io/linter/lints/package_api_docs.html) lint rules.
  **Note**: Additional comments should be added when the code itself is not clear enough or presents high levels of complexity.

## Tests 🧪

- To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

- Use [very_good_workflows](https://github.com/VeryGoodOpenSource/very_good_workflows) to automate your test runs as part of reusable GitHub workflows.
- Use [test](https://pub.dev/packages/test) package to write unit tests.
- Use [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) core library to write widget tests.
- Use [integration_test](https://github.com/flutter/flutter/tree/main/packages/integration_test) provided by the SDK to write integration tests.
- Use [mocktail](https://pub.dev/packages/mocktail) to create mocks in Dart with null safety without the need for manual mocks or code generation.
- Use [bloc_test](https://pub.dev/packages/bloc_test) to test blocs and cubits; built to work with [bloc](https://pub.dev/packages/bloc) and [mocktail](https://pub.dev/packages/mocktail).
- Use [mockingjay](https://pub.dev/packages/mockingjay) to mock, test and verify navigation calls; works with [mocktail](https://pub.dev/packages/mocktail).
- The [very_good_workflows](https://github.com/VeryGoodOpenSource/very_good_workflows) also use [very-good-coverage GitHub action](https://github.com/marketplace/actions/very-good-coverage) to check code coverage; this action can be configured(through the workflow too) to exclude paths(supports `globs` to describe file patterns) and to use a minimum coverage percentage threshold.

**Note:** It's a good practice to aim at a code coverage as close to 100% as possible. Files/folders deemed to be unimportant can be excluded from the coverage so they don't affect it.

## UI Best Practices ✔️

### App UI 📱

The project should contain an application package as a submodule having the role of an UI toolkit. This package is usually named `app_ui` or `{appName}_ui` and should contain the `assets` folder, reusable widgets, UI related helpers and classes for layout, navigation, platform, typography, theme, colors, etc...

An example of a class storing colors is below:

```
abstract class AppColors {
  static const Color black = Color(0xFF202124);

  static const Color white = Color(0xFFFFFFFF);
}
```

An example of the `app_ui` directory structure is below:

```sh
├── lib
│   ├── app
│   └── l10n
├── packages
│   ├── app_ui
│   │   ├── assets
│   │   │   ├── fonts
│   │   │   └── images
│   │   ├── lib
│   │   │   └── src
│   │   │   │   ├── helpers
│   │   │   │   ├── layout
│   │   │   │   ├── navigation
│   │   │   │   ├── platform
│   │   │   │   ├── theme
│   │   │   │   └── widgets
│   ├── meta_weather_api_client
│   ├── user_repository
│   └── weather_repository
```

[very_good_cli](https://pub.dev/packages/very_good_cli) can be used to easily create dart/flutter packages or even a full flutter application.

**Note:** Colors inside the app should be configured as much as possible through `ColorScheme`.

### Translations 🌐

This project should rely on [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) and follow the [official internationalization guide for Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization).
This approach is recommended even if there's only a locale needed.

#### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:mindspotter/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

#### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

#### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```
