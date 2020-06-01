import 'package:flutter/material.dart';
import 'package:mystockanalysis/SharedPreferencesManager.dart';
import 'package:mystockanalysis/models/Company.dart';
import 'package:mystockanalysis/pages/GraphOne.dart';
import 'package:mystockanalysis/pages/SelectFavorite.dart';

import 'pages/HomePage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {      //LoadingPage()
    return MaterialApp(title: 'An App', home: LoadingHomePage(), routes: {
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
    SharedPreferencesManager.read("Companies").then((result){
      if(result == null) {
        print("Creating starting companies");
        companyList = Company.createStartingCompanies();
        SharedPreferencesManager.save("Companies", companyList);
      }else{
        print("Loaded starting companies");
        companyList = result;
      }

      List<Company> companies = Company.decodeListToJson(companyList);
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
