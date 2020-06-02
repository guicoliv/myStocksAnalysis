import 'package:flutter/material.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';
import 'package:mystockanalysis/pages/AddCompany.dart';


class SelectFavorite extends StatefulWidget {
  final List<QuoteDetail> companies;

  SelectFavorite({Key key, this.companies}) : super(key: key);

  @override
  SelectFavoriteState createState() => SelectFavoriteState();
}

class SelectFavoriteState extends State<SelectFavorite> {

  Widget _buildCompaniesList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.companies.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider(
            color: Colors.grey,
          );

          final index = i ~/ 2;
          final item = widget.companies[index];
          return _buildRow(item);
        });
  }

  Widget _buildRow(QuoteDetail item) {
    return Dismissible(
      key: Key(item.symbol),
      onDismissed: (direction) {
        setState(() {
          widget.companies.removeAt(widget.companies.indexOf(item));
        });

        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Remove Company")));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title: item.buildTitle(context),
        subtitle: item.buildSubtitle(context),

        trailing: Icon(
          item.favorite ? Icons.check_circle : Icons.check_circle_outline,

          color: item.favorite ? Colors.cyanAccent : !item.favorite
              ? Colors.grey
              : null,
        ),
        onTap: () {
          setState(() {
            if (!item.favorite && countFavoritedCompanies() < 10) {
              item.favorite = true;
            } else {
              item.favorite = false;
            }
          });
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building SelectFavorite page");
    print("Companies on Select Favorite: ${widget.companies}");


    return Scaffold(
        appBar: AppBar(
          title: Text('StockAnalysis'),
          automaticallyImplyLeading: true,
        ),
        body: Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text("${countFavoritedCompanies()}/10",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                    ]),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
              child: _buildCompaniesList()),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          tooltip: 'Increment Counter',
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    AddCompany(companies: widget.companies),
                fullscreenDialog: true,
              ),
            );
            setState(() {});
          },
        ));
  }

  int countFavoritedCompanies() {
    int count = 0;
    for (QuoteDetail c in widget.companies) {
      if (c.favorite)
        count++;
    }
    return count;
  }

}

abstract class CompanyListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a message.
class MessageItem implements CompanyListItem {
  final String name;
  final String symbol;

  MessageItem(this.name, this.symbol);

  Widget buildTitle(BuildContext context) => Text(name);

  Widget buildSubtitle(BuildContext context) => Text(symbol);
}
