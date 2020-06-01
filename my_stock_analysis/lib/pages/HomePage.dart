import 'package:flutter/material.dart';
import 'package:mystockanalysis/SharedPreferencesManager.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:mystockanalysis/pages/GraphOne.dart';
import 'package:mystockanalysis/pages/SelectFavorite.dart';

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
              child: _buildList(companies)),
        ]),
        floatingActionButton: _getFloatingButton());
  }

  String countSelectedCompanies() {
    int count = 0;
    if (selComp2 != null) count++;
    if (selComp1 != null) count++;

    return "$count/2";
  }

  Widget _getFloatingButton() {
    if (selComp1 == null && selComp2 == null) return Container();

    return FloatingActionButton(
      onPressed: () {
        if (selComp1 != null && selComp2 != null) {
          //SHOW GRAPH FOR 2(selComp1, selComp2)
          print("Selected 2 companies:\n\t$selComp1\n\t$selComp2\n");
        } else {
          QuoteDetail temp;
          if(selComp2 != null){
            temp = selComp2;
            print("Selected 1 company [2]:\n\t$selComp2\n");
          }else{
            temp = selComp1;
            print("Selected 1 company [1]:\n\t$selComp1\n");
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) =>
                GraphOne(company: temp),
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

  @override
  void initState() {
    super.initState();

    color = Colors.indigo;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.company.favorite) {
      color = Colors.indigo;
      return new Container();
    }

    return new Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.only(top: 8),
      child: ListTile(
        title: widget.company.buildTitle(context),
        subtitle: widget.company.buildSubtitle(context),
        focusColor: Colors.cyanAccent,
        onTap: () {
          setState(() {
            if (color == Colors.cyanAccent) {
              if (selComp2 != null) if (widget.company.symbol == selComp2.symbol)
                selComp2 = null;
              if (selComp1 != null) if (widget.company.symbol == selComp1.symbol)
                selComp1 = null;
              color = Colors.indigo;
            } else if (selComp1 != null && selComp2 != null) {
            } else {
              if (selComp1 == null)
                selComp1 = widget.company;
              else
                selComp2 = widget.company;
              color = Colors.cyanAccent;
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
}
