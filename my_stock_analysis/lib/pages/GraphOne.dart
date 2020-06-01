import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/candleline.dart';
import 'package:flutter/material.dart';
import 'package:mystockanalysis/http_request.dart';
import 'package:mystockanalysis/models/Company.dart';

int number = 0;

class GraphOne extends StatefulWidget {
  final Company company;
  GraphOne({Key key, this.company}) : super(key: key);

  @override
  GraphOneState createState() => GraphOneState();
}

class GraphOneState extends State<GraphOne> {
  KlineBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(bloc == null){
      bloc = KlineBloc();
    }
    getDataToBloc(bloc);
    print("lista: ${bloc.stringList}");
    //Navigator.push(context, MaterialPageRoute(builder: (context) {
    double height = MediaQuery.of(context).size.height;

    if (bloc.stringList.length == 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Graph View'),
          ),
          body: Container(
              child: Center(
            child: CircularProgressIndicator(),

          )));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph View'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: height - 200,
            child: KlinePage(bloc: bloc),
          ),
          Container(
              height: 100,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Line"),
                    onPressed: _changeToTimeView,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text("Candlestick"),
                      onPressed: _changeToCandleView,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
    //}));
  }

  void _changeToTimeView() {
    bloc.openRealTime(true);
  }

  void _changeToCandleView() {
    bloc.openRealTime(false);
  }

  void getDataToBloc(KlineBloc k){
    List<KlineData> list = List<KlineData>();
    if(k.stringList.length > 0)
      return;
    print("gettting");
    Future<List<KlineData>> apiCallResponse = getHistory(widget.company.symbol, 'daily');
    apiCallResponse.then((value) {
      print("got");
      list = value;
      k.updateDataList(list);

      setState(() {

      });
    });
  }

}

class KlinePageBloc extends KlineBloc {
  @override
  void initData() {
    super.initData();
    List<KlineData> list = List<KlineData>();
    number++;
    if(number >= 10)
      return;
    Future<List<KlineData>> apiCallResponse = getHistory('AAPL', 'daily');
    apiCallResponse.then((value) {
      list = value;
      this.updateDataList(list);

    });
  }
}
