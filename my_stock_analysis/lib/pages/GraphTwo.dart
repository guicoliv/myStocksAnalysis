import 'package:flutter/material.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mystockanalysis/http_request.dart';
import 'package:candleline/candleline.dart';

int number = 0;

class GraphTwo extends StatefulWidget {
  final List<QuoteDetail> companies;

  GraphTwo({Key key, this.companies}) : super(key: key);

  @override
  GraphTwoState createState() => GraphTwoState();
}

class GraphTwoState extends State<GraphTwo> {
  List<CompaniesComparison> companyOneData = new List();
  List<CompaniesComparison> companyTwoData = new List();
  bool companiesDataFetched = false;

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
                        onPressed: (){},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Colors.indigo,
                          child: Text(widget.companies[1].symbol),
                          onPressed: (){},
                        ),
                      )
                    ],
                  ))
            ],
          ));
    }
  }

  Widget createChart() {
    List<charts.Series<CompaniesComparison, DateTime>> dataList =
        _formatDataToGraph(companyOneData, companyTwoData);

    return new charts.TimeSeriesChart(dataList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: true);
  }

  static List<charts.Series<CompaniesComparison, DateTime>> _formatDataToGraph(
      companyOneData, companyTwoData) {
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
  }

  void getGraphData(List<QuoteDetail> k) {
    Future<List<KlineData>> companyOneResponse =
        getHistory(widget.companies[0].symbol, 'daily');

    //COMPANY ONE
    companyOneResponse.then((valueOne) {
      formatFetchedData(valueOne, 1);

      Future<List<KlineData>> companyTwoResponse =
          getHistory(widget.companies[1].symbol, 'daily');

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
