import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/candleline.dart';
import 'package:flutter/material.dart';
import 'package:mystockanalysis/http_request.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:intl/intl.dart' show DateFormat;

int number = 0;

class GraphOne extends StatefulWidget {
  final QuoteDetail company;
  final int metricChoice;
  GraphOne({Key key, this.company, this.metricChoice}) : super(key: key);

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
    if (bloc == null) {
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
              color: Colors.black,
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
            height: height - 180,
            child: KlinePage(bloc: bloc),
          ),
          Container(
              height: 100,
              color: Colors.black,
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(widget.company.symbol ,
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,

                          ),
                        softWrap: true,

                      )),
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

  void getDataToBloc(KlineBloc k) {
    List<KlineData> list = List<KlineData>();
    if (k.stringList.length > 0) return;
    String metric, startDate;
    DateTime today = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    DateTime dateTimeToFormat;

    print('metric choice: '+widget.metricChoice.toString());
    switch(widget.metricChoice){
      case 1:
        metric= 'minutes';
        dateTimeToFormat = today.subtract(new Duration(days: 1));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate= formattedDate;
        print(startDate);
        break;
      case 2:
        metric = 'minutes';
        dateTimeToFormat = today.subtract(new Duration(days: 7));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate= formattedDate;
        print(startDate);
        break;
      case 3:
        metric = 'daily';
        dateTimeToFormat = today.subtract(new Duration(days: 90));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate= formattedDate;
        print(startDate);
        break;
      case 4:
        metric = 'daily';
        dateTimeToFormat = today.subtract(new Duration(days: 365));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate= formattedDate;
        print(startDate);
        break;
    }




    Future<List<KlineData>> apiCallResponse =getHistory(widget.company.symbol, metric, startDate);

    apiCallResponse.then((value) {
      print("got");
      list = value;
      k.updateDataList(list);

      setState(() {});
    });
  }
}
/*
class KlinePageBloc extends KlineBloc {
  @override
  void initData() {
    super.initData();
    List<KlineData> list = List<KlineData>();
    number++;
    if (number >= 10) return;
    Future<List<KlineData>> apiCallResponse = getHistory('AAPL', 'daily');
    apiCallResponse.then((value) {
      list = value;
      this.updateDataList(list);
    });
  }
}*/
