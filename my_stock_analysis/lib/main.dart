import 'package:flutter/material.dart';
import 'package:mystockanalysis/SharedPreferencesManager.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:mystockanalysis/pages/GraphOne.dart';
import 'package:mystockanalysis/pages/SelectFavorite.dart';

import 'pages/HomePage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //LoadingPage()
    return MaterialApp(
        title: 'An App',
        home: LoadingHomePage(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => HomePage(),
          '/favorites': (context) => SelectFavorite(),
          '/graphOne': (context) => GraphOne(),
        });
  }
}

class LoadingHomePage extends StatefulWidget {
  LoadingHomePage({Key key}) : super(key: key);

  _LoadingHomePageState createState() => _LoadingHomePageState();
}

class _LoadingHomePageState extends State<LoadingHomePage> {
  @override
  void initState() {
    super.initState();
    loadPage();
  }

  loadPage() {
    List companyList;
    //SharedPreferencesManager.clean();
    SharedPreferencesManager.read("Companies").then((result) async {
      if (result == null) {
        print("Creating starting companies");
        companyList = await QuoteDetail.createStartingCompanies();
        //print(companyList);
      } else {
        print("Loaded starting companies");
        print("RESULT READ FROM SHARED PREFERENCES:\n\n$result");
        companyList = result;
      }

      List<QuoteDetail> companies = QuoteDetail.decodeListToJson(companyList);
      print("Companies on initialization: $companies");

      //Navigator.of(context).pushNamed('/home');
      Navigator.pushNamed(context, '/home', arguments: companies);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
