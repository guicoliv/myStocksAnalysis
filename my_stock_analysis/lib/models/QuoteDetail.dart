import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mystockanalysis/SharedPreferencesManager.dart';
import 'package:mystockanalysis/http_request.dart';

class QuoteDetail {
  //fields
  String symbol;
  String exchange;
  String name;
  String dayCode;
  String mode;
  double lastPrice;
  double netChange;
  double percentChange;
  String unitCode;
  double open;
  double high;
  double low;
  double close;
  String flag;
  double volume;
  bool favorite;

  QuoteDetail(
      this.symbol,
      this.exchange,
      this.name,
      this.dayCode,
      this.mode,
      this.lastPrice,
      this.netChange,
      this.percentChange,
      this.unitCode,
      this.open,
      this.high,
      this.low,
      this.close,
      this.flag,
      this.volume,
      this.favorite);

  Map<String, dynamic> toJson() => {
    "symbol" : this.symbol,
        "name": this.name,
        "exchange": this.exchange,
        "dayCode": this.dayCode,
        "mode": this.mode,
        "lastPrice": this.lastPrice,
        "netChange": this.netChange,
        "percentChange": this.percentChange,
        "unitCode": this.unitCode,
        "open": this.open,
        "high": this.high,
        "low": this.low,
        "close": this.close,
        "flag": this.flag,
        "volume": this.volume,
        "favorite": this.favorite
      };

  QuoteDetail.fromJson(Map<String, dynamic> json)
      : symbol = json['symbol'],
        name = json['name'],
        exchange = json['exchange'],
        dayCode = json['dayCode'],
        mode = json['mode'],
        lastPrice = json['lastPrice'],
        netChange = json['netChange'],
        percentChange = json['percentChange'],
        unitCode = json['unitCode'],
        open = json['open'],
        high = json['high'],
        low = json['low'],
        close = json['close'],
        flag = json['flag'],
        volume = json['volume'],
        favorite = json['favorite'];

  static List encodeListToJson(List<QuoteDetail> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  static List<QuoteDetail> decodeListToJson(List list) {
    List<QuoteDetail> companyList = List<QuoteDetail>();
    list.map((item) {
      print(item);
      companyList.add(QuoteDetail.fromJson(item));
    }).toList();
    return companyList;
  }

  static Future<List> createStartingCompanies() async {
    List<QuoteDetail> companies = List<QuoteDetail>();

    List<QuoteDetail> value = await getQuotes([
      "AAPL",
      "GOOG",
      "AMZN",
      "INTC",
      "AMD",
      "MSFT",
      "IBM",
      "ORCL",
      "FB",
      "HPQ",
      "TWTR",
      "PYPL",
      "NFLX",
      "NVDA",
      "ADBE",
      "CSCO"
    ]);

    companies = value;
    print(companies);
    await SharedPreferencesManager.save("Companies", companies);

    return encodeListToJson(companies);


    /*companies.add(Company(id:1, symbol:"AAPL", name:"Apple", favorite: true));
    companies.add(Company(id:2, symbol:"GOOG", name:"Google", favorite: true));
    companies.add(Company(id:3, symbol:"AMZN", name:"Amazon", favorite: true));
    companies.add(Company(id:4, symbol:"INTC", name:"Intel", favorite: true));
    companies.add(Company(id:5, symbol:"AMD", name:"AMD", favorite: true));
    companies.add(Company(id:6, symbol:"MSFT", name:"Microsoft", favorite: true));
    companies.add(Company(id:7, symbol:"IBM", name:"IBM", favorite: true));
    companies.add(Company(id:8, symbol:"ORCL", name:"Oracle", favorite: true));
    companies.add(Company(id:9, symbol:"FB", name:"Facebook", favorite: true));
    companies.add(Company(id:10, symbol:"HPQ", name:"Hewlett-Packard", favorite: true));
    companies.add(Company(id:11, symbol:"TWTR", name:"Twitter", favorite: false));
    companies.add(Company(id:12, symbol:"PYPL", name:"PayPal", favorite: false));
    companies.add(Company(id:13, symbol:"NFLX", name:"Netflix", favorite: false));
    companies.add(Company(id:14, symbol:"NVDA", name:"NVidia", favorite: false));
    companies.add(Company(id:15, symbol:"ADBE", name:"Adobe", favorite: false));
    companies.add(Company(id:16, symbol:"CSCO", name:"Cisco", favorite: false));
    companies.add(Company(id:17, symbol:"SBUX", name:"Starbucks", favorite: false));
    companies.add(Company(id:18, symbol:"V", name:"VISA", favorite: false));*/
    //companies.add(Company(id:19, symbol:"HPQ", name:"HP", favorite: false));
    //companies.add(Company(id:20, symbol:"UBER", name:"Uber", favorite: false));

    //for(int i = 0; i < companies.length; i++) {
    //  SharedPreferencesManager.save(companies[i].symbol, companies[i].toJson());
    //}


  }

  Widget buildTitle(BuildContext context) => Text(
        name,
        style: TextStyle(
            fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.grey),
      );

  Widget buildSubtitle(BuildContext context) => Text(
        symbol,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey),
      );

  @override
  String toString() {
    if (this.favorite)
      return " $name - $symbol - favorited";
    else
      return "$name - $symbol";
  }
}
