import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:mystockanalysis/pages/GraphOne.dart';

class LoadingPageGraph extends StatefulWidget {
  final QuoteDetail company;
  LoadingPageGraph({Key key, this.company}) : super(key: key);

  LoadingPageGraphState createState() => LoadingPageGraphState();
}

class LoadingPageGraphState extends State<LoadingPageGraph> {
  @override
  void initState() {
    super.initState();
    loadPage();
  }

  loadPage() {

    KlinePageBloc bloc;

    while(bloc == null){
      bloc = KlinePageBloc();
    }
    print("AI JOCA");
    //Navigator.of(context).pushNamed('/home');
    Navigator.pushNamed(context, '/graphOne', arguments: widget.company);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
