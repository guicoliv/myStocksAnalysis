import 'package:flutter/material.dart';
import 'package:mystockanalysis/SharedPreferencesManager.dart';
import 'package:mystockanalysis/http_request.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:mystockanalysis/pages/GraphOne.dart';
import 'package:mystockanalysis/pages/GraphTwo.dart';
import 'package:mystockanalysis/pages/SelectFavorite.dart';
import 'package:intl/intl.dart' show DateFormat;

bool selected = false;
QuoteDetail selComp1, selComp2;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<QuoteDetail> companies;
  bool pressed = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int metricChoice = 1;

  Future<Null> _refresh() {
    var symbols = [];
    for (QuoteDetail qd in companies) {
      symbols.add(qd.symbol);
    }
    print("symbols: $symbols");

    var favSymbols = [];
    for (QuoteDetail qd in companies) {
      if (qd.favorite) favSymbols.add(qd.symbol);
    }

    return getQuotes(symbols).then((value) {
      setState(() {
        companies = value;

        for (QuoteDetail qd in companies) {
          if (favSymbols.indexOf(qd.symbol) != -1) {
            qd.favorite = true;
          }
        }
        SharedPreferencesManager.save("Companies", companies);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building home page!");
    if (this.companies == null) {
      List<QuoteDetail> args = ModalRoute.of(context).settings.arguments;
      this.companies = args;

      print("Companies on HomePage: $companies");
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('StockAnalysis'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              color: Colors.indigo,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SelectFavorite(companies: companies),
                    fullscreenDialog: true,
                  ),
                );
                SharedPreferencesManager.save(
                    "Companies", QuoteDetail.encodeListToJson(companies));
                if (selComp1 != null) if (!selComp1.favorite) selComp1 = null;
                if (selComp2 != null) if (!selComp2.favorite) selComp2 = null;
                setState(() {});
              },
            ),
          ],
        ),
        body: Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Companies",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                    ]),
              )),
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(countSelectedCompanies(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                    ]),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
              child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: _buildList(companies))),
          Container(
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width * 0.80,
              margin: EdgeInsets.only(left:35, right: 40),
              child: Row(
                children: <Widget>[
                  ButtonTheme(
                    padding: EdgeInsets.all(2),
                    minWidth: MediaQuery.of(context).size.width * 0.16,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: getMetricChoiceButtonColor(1),
                      child: Text("Day"),
                      onPressed: () {
                        setState(() {
                          metricChoice = 1;
                        });},
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ButtonTheme(
                    padding: EdgeInsets.all(2),
                    minWidth: MediaQuery.of(context).size.width * 0.16,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: getMetricChoiceButtonColor(2),
                      child: Text("Week"),
                      onPressed: () {
                        setState(() {
                          metricChoice = 2;
                        });},
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ButtonTheme(
                    padding: EdgeInsets.all(2),
                    minWidth: MediaQuery.of(context).size.width * 0.16,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: getMetricChoiceButtonColor(3),
                      child: Text("Month"),
                      onPressed: () {
                        setState(() {
                          metricChoice = 3;
                        });},
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ButtonTheme(
                    padding: EdgeInsets.all(2),
                    minWidth: MediaQuery.of(context).size.width * 0.16,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: getMetricChoiceButtonColor(4),
                      child: Text("Year"),
                      onPressed: () {
                        setState(() {
                        metricChoice = 4;
                      });},
                    ),
                  ),
                ],
              ))
        ]),
        floatingActionButton: _getFloatingButton());
  }

  String countSelectedCompanies() {
    int count = 0;
    if (selComp2 != null) count++;
    if (selComp1 != null) count++;

    return "$count/2";
  }

  Color getMetricChoiceButtonColor(int button){
      if(button == metricChoice)
        return Colors.cyanAccent;

      return Colors.indigo;
  }

  Widget _getFloatingButton() {
    if (selComp1 == null && selComp2 == null) return Container();

    return FloatingActionButton(
      onPressed: () {
        if (selComp1 != null && selComp2 != null) {
          //SHOW GRAPH FOR 2(selComp1, selComp2)
          print("Selected 2 companies:\n\t$selComp1\n\t$selComp2\n");
          List<QuoteDetail> selectedCompanies = new List<QuoteDetail>();
          selectedCompanies.add(selComp1);
          selectedCompanies.add(selComp2);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  GraphTwo(companies: selectedCompanies, metricChoice: metricChoice,),
              fullscreenDialog: true,
            ),
          );
        } else {
          QuoteDetail temp;
          if (selComp2 != null) {
            temp = selComp2;
            print("Selected 1 company [2]:\n\t$selComp2\n");
          } else {
            temp = selComp1;
            print("Selected 1 company [1]:\n\t$selComp1\n");
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GraphOne(company: temp, metricChoice: metricChoice,),
              fullscreenDialog: true,
            ),
          );
        }
      },
      backgroundColor: getButtonColor(),
      tooltip: 'Increment Counter',
      child: _confirmButton(),
    );
  }

  Color getButtonColor() {
    if (selComp1 != null || selComp2 != null)
      return Colors.cyan;
    else
      return Colors.transparent;
  }

  Widget _buildList(List<QuoteDetail> companies) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          QuoteDetail item = companies[index];
          return CustomTile(item, this);
        });
  }
}

Widget _confirmButton() {
  if (selComp1 != null || selComp2 != null)
    return Icon(Icons.check);
  else
    return Icon(Icons.clear);
}

class CustomTile extends StatefulWidget {
  final QuoteDetail company;
  final HomePageState parent;
  CustomTile(this.company, this.parent);

  @override
  CustomTileState createState() => CustomTileState();
}

class CustomTileState extends State<CustomTile> {
  Color color;
  double width;

  @override
  void initState() {
    super.initState();

    color = Colors.indigo;
    width = 1;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.company.favorite) {
      color = Colors.indigo;
      width = 1;
      return new Container();
    }

    return new Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: width,
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: ListTile(
        title: widget.company.buildTitle(context),
        subtitle: widget.company.buildSubtitle(context),
        trailing: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text(widget.company.lastPrice.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              selectText(),
            ])),
        onTap: () {
          setState(() {
            if (color == Colors.cyanAccent) {
              if (selComp2 != null) if (widget.company.symbol ==
                  selComp2.symbol) selComp2 = null;
              if (selComp1 != null) if (widget.company.symbol ==
                  selComp1.symbol) selComp1 = null;
              color = Colors.indigo;
              width = 1;
            } else if (selComp1 != null && selComp2 != null) {
            } else {
              if (selComp1 == null)
                selComp1 = widget.company;
              else
                selComp2 = widget.company;
              color = Colors.cyanAccent;
              width = 2;
            }

            if (selComp1 == null && selComp2 == null)
              selected = false;
            else
              selected = true;
            widget.parent.setState(() {});
          });
        },
      ),
    );
  }

  Widget selectText() {
    double change = widget.company.lastPrice - widget.company.open;
    //print(" ${widget.company.symbol} last price: ${widget.company.lastPrice}");
    //print(" ${widget.company.symbol} open: ${widget.company.open}");
    //print("change: $change");

    if (change < 0)
      return Text("${change.toStringAsFixed(3)}",
          style: TextStyle(color: Colors.red, fontSize: 16));
    else if (change > 0)
      return Text("+${change.toStringAsFixed(3)}",
          style: TextStyle(color: Colors.green, fontSize: 16));
    else
      return Text("-",
          style: TextStyle(color: Colors.white, fontSize: 16));
  }
}
