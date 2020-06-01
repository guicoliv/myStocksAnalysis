import 'package:flutter/material.dart';

class Company {

  final int id;
  final String symbol; //APPL GOOG
  final String name; //APPLE GOOGLE
  bool favorite;

  Company({this.id, this.symbol, this.name, this.favorite});


  Map<String, dynamic> toJson() => {
    "id": this.id,
    "name": this.name,
    "symbol": this.symbol,
    "favorite": this.favorite,
  };

  Company.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        symbol = json['symbol'],
        favorite = json['favorite'];

  static List encodeListToJson(List<Company>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();
    return jsonList;
  }

  static List<Company> decodeListToJson(List list){
    List<Company> companyList = List<Company>();
    list.map((item)=>
        companyList.add(Company.fromJson(item))
    ).toList();
    return companyList;
  }


  static List createStartingCompanies(){
    List<Company> companies = List<Company>();

    companies.add(Company(id:1, symbol:"AAPL", name:"Apple", favorite: true));
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
    companies.add(Company(id:18, symbol:"V", name:"VISA", favorite: false));
    //companies.add(Company(id:19, symbol:"HPQ", name:"HP", favorite: false));
    //companies.add(Company(id:20, symbol:"UBER", name:"Uber", favorite: false));

    //for(int i = 0; i < companies.length; i++) {
    //  SharedPreferencesManager.save(companies[i].symbol, companies[i].toJson());
    //}

    return encodeListToJson(companies);

  }




  Widget buildTitle(BuildContext context) => Text(name, style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold),);

  Widget buildSubtitle(BuildContext context) => Text(symbol, style: TextStyle(fontSize: 16.0),);

  @override
  String toString() {
    if(this.favorite)
      return "[$id] $name - $symbol - favorited";
    else
      return "[$id] $name - $symbol";
  }
}