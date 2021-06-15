import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:k_chart/flutter_k_chart.dart';

class AthleteDetail extends StatefulWidget {
  AthleteDetail({Key? key}) : super(key: key);

  @override
  _AthleteDetailState createState() => _AthleteDetailState();
}

class _AthleteDetailState extends State<AthleteDetail> {
  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();
  List<KLineEntity>? datas;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container( child: Row(children: [
        Text("Chart Goes Here"),
        Column(
          children: [
            Row(
              children: [
                        TextButton.icon(onPressed: () {
          print("Adding to your tokens");
        }, icon: Icon(Icons.call_made_outlined), label: const Text("Long")),
        TextButton.icon(onPressed: () {}, icon: Icon(Icons.call_received_outlined), label: const Text("SHORT"))
              ],
            )
          ],
        )
      ], mainAxisAlignment: MainAxisAlignment.spaceEvenly,),),),
    );
  }

  void getData(String period) {
    final Future<String> future = getIPAddress(period);
    future.then((String result) {
      final Map parseJson = json.decode(result) as Map<dynamic, dynamic>;
      final list = parseJson['data'] as List<dynamic>;
      datas = list
          .map((item) => KLineEntity.fromJson(item as Map<String, dynamic>))
          .toList()
          .reversed
          .toList()
          .cast<KLineEntity>();
      DataUtil.calculate(datas!);
      setState(() {});
    }).catchError((_) {
  
      setState(() {});
      print('### datas error $_');
    });
  }

//获取火币数据，需要翻墙
  Future<String> getIPAddress(String? period) async {
    var url =
        'https://api.huobi.br.com/market/history/kline?period=${period ?? '1day'}&size=300&symbol=btcusdt';
    late String result;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      result = response.body;
    } else {
      print('Failed getting IP address');
    }
    return result;
  }
}



      //     KChartWidget(
      //       datas,
      //       chartStyle,
      //       chartColors,
      //       isLine: true,
      //       mainState: MainState.BOLL,
      //       volHidden: false,
      //       secondaryState: SecondaryState.RSI,
      //       fixedLength: 2,
      //       timeFormat: TimeFormat.YEAR_MONTH_DAY,
      //       isChinese: false,
      //       maDayList: [1, 100, 1000],
      //     ),
      //     HStack(
      //       [
      //         ElevatedButton.icon(
      //           onPressed: () async {
      //             // Staking token
      //           },
      //           icon: Icon(
      //             Icons.call_made_rounded,
      //             color: Colors.white,
      //           ),
      //           label: "LONG".text.white.make(),
      //           style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
      //         ).h(60).tooltip("Buy more tokens of this athlete"),
      //         ElevatedButton.icon(
      //           onPressed: () {}, //Withdraw Smart Contract Logic
      //           icon: Icon(
      //             Icons.call_received_rounded,
      //             color: Colors.white,
      //           ),
      //           label: "SHORT".text.white.make(),
      //           style: ElevatedButton.styleFrom(primary: Colors.redAccent),
      //         ).h(60).tooltip("Short your athlete positions"),
      //       ],
      //       alignment: MainAxisAlignment.spaceEvenly,
      //       axisSize: MainAxisSize.max,
      //     ).p16()
      //   ]),
      // ]),