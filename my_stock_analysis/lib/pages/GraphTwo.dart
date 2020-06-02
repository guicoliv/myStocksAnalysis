import 'package:flutter/material.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mystockanalysis/http_request.dart';
import 'package:candleline/candleline.dart';
import 'package:intl/intl.dart' show DateFormat;

int number = 0;

class GraphTwo extends StatefulWidget {
  final List<QuoteDetail> companies;
  final int metricChoice;

  GraphTwo({Key key, this.companies, this.metricChoice}) : super(key: key);

  @override
  GraphTwoState createState() => GraphTwoState();
}

class GraphTwoState extends State<GraphTwo> {
  List<CompaniesComparison> companyOneData = new List();
  List<CompaniesComparison> companyTwoData = new List();
  bool companiesDataFetched = false;
  int linesToShow = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (!companiesDataFetched) {
      getGraphData(widget.companies);
    }

    if (companyOneData.length <= 1 || companyTwoData.length <= 1) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Companies Comparison'),
          ),
          body: Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              )));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Companies Comparison'),
          ),
          body: Column(
            children: <Widget>[
              Container(
                  color: Colors.black,
                  height: height - 180,
                  child: Center(
                    child: createChart(),
                  )),
              Container(
                  height: 100,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.white,
                        color: Colors.cyan,
                        child: Text(widget.companies[0].symbol),
                        onPressed: _companyOnePressed,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Colors.indigo,
                          child: Text(widget.companies[1].symbol),
                          onPressed: _companyTwoPressed,
                        ),
                      )
                    ],
                  ))
            ],
          ));
    }
  }

  void _companyOnePressed() {
    setState(() {
      if(this.linesToShow == 1){
        this.linesToShow = 0;
      }else{
        this.linesToShow = 1;
      }
    });
  }

  void _companyTwoPressed() {
    setState(() {
      if(this.linesToShow == 2){
        this.linesToShow = 0;
      }else{
        this.linesToShow = 2;
      }
    });
  }

  Widget createChart() {
    List<charts.Series<CompaniesComparison, DateTime>> dataList =
        _formatDataToGraph(companyOneData, companyTwoData, linesToShow);

    return new charts.TimeSeriesChart(dataList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: true);
  }

  static List<charts.Series<CompaniesComparison, DateTime>> _formatDataToGraph(
      companyOneData, companyTwoData, l) {
    if (l == 0) {
      return [
        new charts.Series<CompaniesComparison, DateTime>(
          id: 'CompanyOne',
          colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
          domainFn: (CompaniesComparison value, _) => value.marketDay,
          measureFn: (CompaniesComparison value, _) => value.highQuoteValue,
          data: companyOneData,
        ),
        new charts.Series<CompaniesComparison, DateTime>(
          id: 'CompanyTwo',
          colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
          domainFn: (CompaniesComparison value, _) => value.marketDay,
          measureFn: (CompaniesComparison value, _) => value.highQuoteValue,
          data: companyTwoData,
        ),
      ];
    } else if (l == 1) {
      return [
        new charts.Series<CompaniesComparison, DateTime>(
          id: 'CompanyOne',
          colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
          domainFn: (CompaniesComparison value, _) => value.marketDay,
          measureFn: (CompaniesComparison value, _) => value.highQuoteValue,
          data: companyOneData,
        ),
      ];
    } else {
      return [
        new charts.Series<CompaniesComparison, DateTime>(
          id: 'CompanyTwo',
          colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
          domainFn: (CompaniesComparison value, _) => value.marketDay,
          measureFn: (CompaniesComparison value, _) => value.highQuoteValue,
          data: companyTwoData,
        ),
      ];
    }
  }

  void getGraphData(List<QuoteDetail> k) {
    String metric, startDate;
    DateTime today = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    DateTime dateTimeToFormat;

    print('metric choice: ' + widget.metricChoice.toString());
    switch (widget.metricChoice) {
      case 1:
        metric = 'minutes';
        dateTimeToFormat = today.subtract(new Duration(days: 7));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate = formattedDate;
        print(startDate);
        break;
      case 2:
        metric = 'minutes';
        dateTimeToFormat = today.subtract(new Duration(days: 28));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate = formattedDate;
        print(startDate);
        break;
      case 3:
        metric = 'daily';
        dateTimeToFormat = today.subtract(new Duration(days: 90));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate = formattedDate;
        print(startDate);
        break;
      case 4:
        metric = 'daily';
        dateTimeToFormat = today.subtract(new Duration(days: 730));
        String formattedDate = formatter.format(dateTimeToFormat);
        startDate = formattedDate;
        print(startDate);
        break;
    }

    Future<List<KlineData>> companyOneResponse =
        getHistory(widget.companies[0].symbol, metric, startDate);

    //COMPANY ONE
    companyOneResponse.then((valueOne) {
      formatFetchedData(valueOne, 1);

      Future<List<KlineData>> companyTwoResponse =
          getHistory(widget.companies[1].symbol, metric, startDate);

      //COMPANY TWO
      companyTwoResponse.then((valueTwo) {
        formatFetchedData(valueTwo, 2);
      });
    });

    companiesDataFetched = true;
  }

  void formatFetchedData(List<KlineData> k, int companyNum) {
    for (KlineData item in k) {
      String date = item.date.toString();

      if (companyNum == 1) {
        companyOneData.add(new CompaniesComparison(
            item.high, DateTime.parse(date.substring(0, 8))));
      } else {
        companyTwoData.add(new CompaniesComparison(
            item.high, DateTime.parse(date.substring(0, 8))));
      }
    }

    setState(() {});
  }
}

class CompaniesComparison {
  final double highQuoteValue;
  final DateTime marketDay;

  CompaniesComparison(this.highQuoteValue, this.marketDay);
}
