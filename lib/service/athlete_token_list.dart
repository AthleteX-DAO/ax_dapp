// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/service/token_list.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  List<Token> tokenListFilter = [];

  @override
  void initState() {
    super.initState();
    tokenNumber = widget.tknNum;
    tokenListFilter = TokenList.tokenList;
  }

  void setSelectedSport(SupportedSport sport) {
    setState(() {
      selectedSport = sport;
    });
    updateTokenList();
  }

  void updateTokenList() {
    setState(() {
      tokenListFilter = TokenList.tokenList.where((token) {
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
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      // SingleChildScrollView prevents bottom overflow when keyboard pops up
      child: SingleChildScrollView(
        child: SizedBox(
          width: isWeb ? _width * 0.20 : _width * 0.55,
          height: _height * .65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // column of elements
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: _height * .625,
                width: _width * 0.45 + 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select a Token',
                            style: textStyle(
                              Colors.grey[400]!,
                              16,
                              false,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[400],
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: createSearchBar(),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10),
                      child: buildFilterMenuWeb(),
                    ),
                    SizedBox(
                      height: _height * .625 - 160,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tokenListFilter.length,
                        itemBuilder: (context, index) {
                          return widget.createTokenElement(
                            tokenListFilter[index],
                            tokenNumber,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget createSearchBar() {
    final _height = MediaQuery.of(context).size.height;
    final textSize = _height * 0.05;
    var searchBarHintTextSize = textSize * 0.30;
    if (!isWeb) searchBarHintTextSize = textSize * 0.40;
    return Container(
      width: 300,
      height: 40,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[300]!),
      child: Row(
        children: [
          Container(width: 8),
          const Icon(Icons.search, color: Colors.white),
          Container(width: 10),
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  keyword = value;
                });
                updateTokenList();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(bottom: 10),
                hintText: 'Search a name or paste an address',
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

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }

  Row buildFilterMenuWeb() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setSelectedSport(SupportedSport.all);
          },
          child: Text(
            'ALL',
            style: textSwapState(
              selectedSport == SupportedSport.all,
              textStyle(Colors.white, 14, false),
              textStyle(Colors.amber[400]!, 14, false),
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
              selectedSport == SupportedSport.MLB,
              textStyle(Colors.white, 14, false),
              textStyle(Colors.amber[400]!, 14, false),
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
              selectedSport == SupportedSport.NFL,
              textStyle(Colors.white, 14, false),
              textStyle(Colors.amber[400]!, 14, false),
            ),
          ),
        ),
        const Spacer(),
        Container(width: 10),
      ],
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold) {
    if (isBold) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
    }
  }

  BoxDecoration boxDecoration(
    Color col,
    double rad,
    double borWid,
    Color borCol,
  ) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(color: borCol, width: borWid),
    );
  }
}
