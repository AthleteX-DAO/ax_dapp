import 'dart:async';
import 'dart:developer';

import 'package:ax_dapp/app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

Future<void> bootstrap(FutureOr<Widget> Function() bootstrapper) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  await runZonedGuarded(
    () async => runApp(await bootstrapper()),
    (error, stackTrace) => debugPrint(
      'zone error: $error \n stackTrace: $stackTrace',
    ),
  );
}
