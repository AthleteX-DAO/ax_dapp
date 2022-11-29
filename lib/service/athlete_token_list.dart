import 'dart:async';

import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AthleteTokenList extends StatefulWidget {
  const AthleteTokenList(
    this.tknNum,
    this.createTokenElement, {
    super.key,
  });

  final int tknNum;
  final Widget Function(Token, int) createTokenElement;

  @override
  State<AthleteTokenList> createState() => _AthleteTokenListState();
}

class _AthleteTokenListState extends State<AthleteTokenList> {
  SwapController swapController = Get.find();
  int tokenNumber = 0;
  double fromAmount = 0;
  double toAmount = 0;
  bool isWeb = true;

  String keyword = '';
  SupportedSport selectedSport = SupportedSport.all;
  late List<Token> tokens;
  late List<Token> filteredTokens;

  late StreamSubscription<List<Token>> tokensSubscription;

  @override
  void initState() {
    super.initState();
    tokenNumber = widget.tknNum;
    filteredTokens = [...context.read<TokensRepository>().currentTokens];
    tokensSubscription =
        context.read<TokensRepository>().tokensChanges.listen(updateTokens);
  }

  @override
  void dispose() {
    tokensSubscription.cancel();
    super.dispose();
  }

  void setSelectedSport(SupportedSport sport) {
    setState(() {
      selectedSport = sport;
    });
    updateFilteredApts();
  }

  void updateKeyWord(String value) {
    setState(() {
      keyword = value;
    });
  }

  void updateTokens(List<Token> tokens) {
    if (mounted) {
      this.tokens = [...tokens];
      updateFilteredApts();
    }
  }

  void updateFilteredApts() {
    if (!mounted) {
      return;
    }
    setState(() {
      filteredTokens = tokens.where((token) {
        final flagKeyword =
            token.ticker.toUpperCase().contains(keyword.toUpperCase()) ||
                token.name.toUpperCase().contains(keyword.toUpperCase());
        final flagSport =
            selectedSport == SupportedSport.all || token.sport == selectedSport;
        return flagKeyword && flagSport;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return LayoutBuilder(
      builder: (context, constraints) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: isWeb
                ? constraints.maxWidth * 0.20
                : constraints.maxWidth * 0.55,
            height: constraints.maxHeight * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: constraints.maxHeight * .625,
                  width: constraints.maxWidth * 0.45 + 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select a Token',
                              style: textStyle(
                                Colors.grey[400]!,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SearchBar(
                          searchBarHintTextSize:
                              constraints.maxWidth < 1100 ? 15 : 20,
                          updateKeyWord: updateKeyWord,
                          updateFilteredApts: updateFilteredApts,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10),
                        child: BuildFilterMenu(
                          selectedSport: selectedSport,
                          setSelectedSport: setSelectedSport,
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * .625 - 160,
                        child: (filteredTokens.isEmpty)
                            ? const FilterMenuError()
                            : BuildListView(
                                filteredTokens: filteredTokens,
                                widget: widget,
                                tokenNumber: tokenNumber,
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.searchBarHintTextSize,
    required this.updateKeyWord,
    required this.updateFilteredApts,
  });

  final double searchBarHintTextSize;
  final void Function(String) updateKeyWord;
  final void Function() updateFilteredApts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                updateKeyWord(value);
                updateFilteredApts();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 10),
                hintText: 'Search a token',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: searchBarHintTextSize,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildListView extends StatelessWidget {
  const BuildListView({
    super.key,
    required this.filteredTokens,
    required this.widget,
    required this.tokenNumber,
  });

  final List<Token> filteredTokens;
  final AthleteTokenList widget;
  final int tokenNumber;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: filteredTokens.length,
      itemBuilder: (context, index) {
        return widget.createTokenElement(
          filteredTokens[index],
          tokenNumber,
        );
      },
    );
  }
}

class FilterMenuError extends StatelessWidget {
  const FilterMenuError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No tokens are supported.',
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
        ),
      ),
    );
  }
}

class BuildFilterMenu extends StatelessWidget {
  const BuildFilterMenu({
    super.key,
    required this.selectedSport,
    required this.setSelectedSport,
  });

  final SupportedSport selectedSport;
  final void Function(SupportedSport) setSelectedSport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setSelectedSport(SupportedSport.all);
          },
          child: Text(
            'ALL',
            style: textSwapState(
              condition: selectedSport == SupportedSport.all,
              tabNotSelected: textStyle(
                Colors.white,
                14,
                isBold: false,
                isUline: false,
              ),
              tabSelected: textStyle(
                Colors.amber[400]!,
                14,
                isBold: false,
                isUline: false,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setSelectedSport(SupportedSport.MLB);
          },
          child: Text(
            'MLB',
            style: textSwapState(
              condition: selectedSport == SupportedSport.MLB,
              tabNotSelected: textStyle(
                Colors.white,
                14,
                isBold: false,
                isUline: false,
              ),
              tabSelected: textStyle(
                Colors.amber[400]!,
                14,
                isBold: false,
                isUline: false,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setSelectedSport(SupportedSport.NFL);
          },
          child: Text(
            'NFL',
            style: textSwapState(
              condition: selectedSport == SupportedSport.NFL,
              tabNotSelected: textStyle(
                Colors.white,
                14,
                isBold: false,
                isUline: false,
              ),
              tabSelected: textStyle(
                Colors.amber[400]!,
                14,
                isBold: false,
                isUline: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
