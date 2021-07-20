import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class AthleteDetails extends StatefulWidget {
  AthleteDetails({Key? key}) : super(key: key);

  @override
  _AthleteDetailsState createState() => _AthleteDetailsState();
}

Future<List<Candle>> fetchCandles(
    {required String symbol, required String interval}) async {
  final uri = Uri.parse(
      "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=1000");
  final res = await http.get(uri);
  return (jsonDecode(res.body) as List<dynamic>)
      .map((e) => Candle.fromJson(e))
      .toList()
      .reversed
      .toList();
}

class _AthleteDetailsState extends State<AthleteDetails> {
  List<Candle> candles = [];
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://stream.binance.com:9443/ws'),
  );

  @override
  void initState() {
    fetchCandles(symbol: "BTCUSDT", interval: "1h").then((value) {
      setState(() {
        candles = value;
      });
      print(value[0].date.day);
    });
    _channel.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": ["btcusdt@kline_1h"],
          "id": 1
        },
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("candleSticks"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.2,
          child: StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final data =
                    jsonDecode(snapshot.data as String) as Map<String, dynamic>;
                if (data.containsKey("k") == true &&
                    candles[0].date.millisecondsSinceEpoch == data["k"]["t"]) {
                  candles[0] = Candle(
                      date: candles[0].date,
                      high: double.parse(data["k"]["h"]),
                      low: double.parse(data["k"]["l"]),
                      open: double.parse(data["k"]["o"]),
                      close: double.parse(data["k"]["c"]),
                      volume: double.parse(data["k"]["v"]));
                } else if (data.containsKey("k") == true) {
                  candles.insert(
                      0,
                      Candle(
                          date: DateTime.fromMillisecondsSinceEpoch(
                              data["k"]["t"]),
                          high: double.parse(data["k"]["h"]),
                          low: double.parse(data["k"]["l"]),
                          open: double.parse(data["k"]["o"]),
                          close: double.parse(data["k"]["c"]),
                          volume: double.parse(data["k"]["v"])));
                }
              }
              // candles[0] = new Candle(close: )
              return Candlesticks(
                candles: candles,
              );
            },
          ),
        ),
      ),
    );
  }
}
