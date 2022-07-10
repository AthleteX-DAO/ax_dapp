# AthleteX dApp UI

[![Deploy Staging](https://github.com/SportsToken/ax_dapp/actions/workflows/deploy_staging.yml/badge.svg?branch=develop)](https://github.com/SportsToken/ax_dapp/actions/workflows/deploy_staging.yml)
[![Deploy Release](https://github.com/SportsToken/ax_dapp/actions/workflows/release_deploy.yml/badge.svg?branch=main)](https://github.com/SportsToken/ax_dapp/actions/workflows/release_deploy.yml)
[![Linter](https://github.com/SportsToken/ax_dapp/actions/workflows/linter.yml/badge.svg?branch=main)](https://github.com/SportsToken/ax_dapp/actions/workflows/linter.yml)

Front end UI for athlete equity MVBP built using flutter

## Getting Started

<!-- Mnenomic -->
<!-- web lady wheat index recipe chunk urge boost hungry critic language crossnote: this mnemonic is not secure; don't use it on a public blockchain.
 -->

## Bloc Architecture

### Overview

Layering our code is very important and helps us iterate quickly and with confidence. Each layer has a single responsibility and can be used and tested in isolation. This allows us to keep changes contained to a specific layer in order to minimize the impact on the entire application.

For example:

- if engineering decides to migrate to GraphQL instead of a REST API, only the data layer will be impacted
- if product wants to change a criteria for the business, only the domain layer will be impacted
- if design wants to change the application theme, only the presentation layer will be impacted

### Layers

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

### Project Structure

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
│   │   ├── arb
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

## Naming Conventions

- [effective dart](https://dart.dev/guides/language/effective-dart/style).
- [bloc library naming conventions](https://bloclibrary.dev/#/blocnamingconventions?id=naming-conventions).

## Formatting Conventions

Code formatters fix style, spacing, line jumps, comments, which helps enforce programming and formatting rules that can be easily automated. This helps reduce future code diffs by delegating formatting concerns to an automatic tool rather than individual developers.

- To check code formatting run: `flutter format --set-exit-if-changed lib test`.
- Formatting checks should be automated via CI/CD pipelines.
- [effective dart formatting guidelines](https://dart.dev/guides/language/effective-dart/style#do-format-your-code-using-dart-format).
