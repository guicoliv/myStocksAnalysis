import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:candleline/candleline.dart';
import 'models/QuoteDetail.dart';

String baseUrl = "https://marketdata.websol.barchart.com/";

String getApiKey(){
  return '133c0a27b0b00a4613da04c6cf71abd7';
}

Future<List<QuoteDetail>> getQuotes(List symbols) async{
  String symbolsParam = symbols.join(",");
  String url = baseUrl + "getQuote.json?apikey=" + getApiKey() + "&symbols=" + symbolsParam;
  print(url);

  try{
    var response = await http.get(url).timeout(Duration(seconds: 10), onTimeout: (){
      return null;
    });

    //Timeout
    if(response == null) return null;

    final data = jsonDecode(response.body);
    if(data['status']['code'] == 204)
      return null;

    //Possible Server problem?
    if (response.statusCode < 200 || response.statusCode > 400) {
      return null;
    }

    //print(jsonDecode(response.body));

    if (response.headers.containsKey('content-type')) {
      if (response.headers['content-type'].contains("application/json")) {
        final data = jsonDecode(response.body);
        List<QuoteDetail> finalList = new List<QuoteDetail>();
        for(Map<String, dynamic> item in data['results']){
          var quoteDetail = QuoteDetail(
              item['symbol'] ?? "",
              item['exchange'] ?? "",
              item['name'] ?? item['symbol'],
              item['dayCode'] ?? "",
              item['mode'] ?? "",
              item['lastPrice'].toDouble() ?? null,
              item['netChange'].toDouble() ?? null,
              item['percentChange'].toDouble() ?? null,
              item['unitCode'] ?? "",
              item['open'].toDouble() ?? null,
              item['high'].toDouble() ?? null,
              item['low'].toDouble() ?? null,
              null,
              item['flag'] ?? "",
              item['volume'].toDouble() ?? null,
              false
          );
          finalList.add(quoteDetail);
        }
        return finalList;
      }
      return null;
    }else{
      return null;
    }
  } catch(e){
    print(e);
    return null;
  }
}


Future<List<KlineData>> getHistory(String symbol, String type) async{
  String url = baseUrl + "getHistory.json?apikey=" + getApiKey() + "&symbol=" + symbol + "&type=" + type + '&startDate=20200106';

  try{
    var response = await http.get(url).timeout(Duration(seconds: 10), onTimeout: (){
      return null;
    });

    //Timeout
    if(response == null) return null;

    //Possible Server problem?
    if (response.statusCode < 200 || response.statusCode > 400) {
      return null;
    }

    if (response.headers.containsKey('content-type')) {
      if (response.headers['content-type'].contains("application/json")) {
        final data = jsonDecode(response.body);
        List<KlineData> finalList = new List<KlineData>();
        for(Map<String, dynamic> item in data['results']){
          var dateTemp = DateTime.parse(item['timestamp']);
          var marketQuote = KlineData(
              open: item['open'].toDouble(),
              high: item['high'].toDouble(),
              low: item['low'].toDouble(),
              close: item['close'].toDouble(),
              vol: item['volume'].toDouble(),
              date: 100000000 * dateTemp.year + 1000000 * dateTemp.month + 10000 * dateTemp.day + 100 * dateTemp.hour + dateTemp.minute);
          finalList.add(marketQuote);
        }
        return finalList;
      }
      return null;
    }else{
      return null;
    }
  } catch(e){
    print(e);
    return null;
  }
}