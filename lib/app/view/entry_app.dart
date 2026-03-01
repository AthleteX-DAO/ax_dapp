import 'package:ax_dapp/app/view/view.dart';
import 'package:ax_dapp/app/widgets/price_data_initializer.dart';
import 'package:ax_dapp/debug/views/debug_app_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EntryApp extends StatelessWidget {
  const EntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _appRouter = MaterialApp.router(
      title: 'AthleteX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        canvasColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColor: Colors.yellow[700],
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: Colors.black),
      ),
      routerConfig: AppRouter().router,
    );

    final appWithInitializer = PriceDataInitializer(
      child: _appRouter,
    );

    return kDebugMode
        ? DebugAppWrapper(home: appWithInitializer)
        : appWithInitializer;
  }
}
