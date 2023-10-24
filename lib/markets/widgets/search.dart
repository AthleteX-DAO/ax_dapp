import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class Search extends StatelessWidget {
  const Search({super.key, required BoxConstraints boxConstraints})
      : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    var input = '';
    final myController = TextEditingController(text: input);
    final bloc = context.read<MarketsPageBloc>();
    var _selectedSport = SupportedSport.all;
    var isLongToken = true;
    const sportFilterTxSz = 14.0;
    return // Search Bar
        Container(
      width: (constraints.maxWidth > 800)
          ? constraints.maxWidth * 0.26
          : constraints.maxWidth - 610,
      height: 160,
      decoration: boxDecoration(
        const Color.fromRGBO(118, 118, 128, 0.24),
        20,
        1,
        const Color.fromRGBO(118, 118, 128, 0.24),
      ),
      child: Row(
        children: <Widget>[
          Container(width: 6),
          const Icon(
            Icons.search,
            color: Color.fromRGBO(235, 235, 245, 0.6),
            size: 20,
          ),
          Container(width: 35),
          Expanded(
            child: TextFormField(
              controller: myController,
              onChanged: (value) {
                input = value;

                bloc.add(
                  AthleteSearchChanged(
                    searchedName: value,
                    selectedSport: _selectedSport,
                  ),
                );
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 8.5),
                hintText: 'Search for an active market',
                hintStyle: TextStyle(
                  color: Color.fromRGBO(
                    235,
                    235,
                    245,
                    0.6,
                  ),
                  fontFamily: 'OpenSans',
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[a-zA-z. ]'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
