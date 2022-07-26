import 'package:ax_dapp/pages/landing_page/landing_page.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_repository/wallet_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc(
        walletRepository: context.read<WalletRepository>(),
      ),
      child: MaterialApp(
        title: 'AthleteX',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: ThemeData(
          canvasColor: Colors.transparent,
          brightness: Brightness.dark,
          primaryColor: Colors.yellow[700],
          colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
              .copyWith(secondary: Colors.black),
        ),
        home: const LandingPage(),
      ),
    );
  }
}
