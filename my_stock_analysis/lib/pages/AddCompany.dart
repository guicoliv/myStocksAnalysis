import 'package:flutter/material.dart';
import 'package:mystockanalysis/SharedPreferencesManager.dart';
import 'package:mystockanalysis/http_request.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';

class AddCompany extends StatefulWidget {
  final List<QuoteDetail> companies;
  AddCompany({Key key, this.companies}) : super(key: key);

  @override
  AddCompanyState createState() => AddCompanyState();
}

class AddCompanyState extends State<AddCompany> {
  final nameController = TextEditingController();
  final symbolController = TextEditingController();
  bool _error = false, _repeated = false;
  QuoteDetail tempCompany;

  @override
  Widget build(BuildContext context) {
    print("Building Add Company page");

    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Company'),
          automaticallyImplyLeading: true,
        ),
        body: Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: PageView(children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: new Text(
                            'Symbol: ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Flexible(
                          child: new TextField(
                              textAlign: TextAlign.center,
                              cursorColor: Colors.blue,
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.white),
                              controller: symbolController,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigo),
                                ),
                                errorText: _error
                                    ? 'Wrong Symbol'
                                    : _repeated ? 'Already Exists' : null,
                                errorStyle: TextStyle(fontSize: 16),
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        FlatButton(
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.indigo, width: 2),
                          ),
                          color: Colors.grey,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          onPressed: () {
                            getNewCompany();
                          },
                          child: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: Text(
                              'Name: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: Text(
                              (tempCompany != null) ? tempCompany.name : '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Exchange: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              (tempCompany != null)
                                  ? tempCompany.exchange
                                  : '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Open: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              (tempCompany != null)
                                  ? tempCompany.open.toStringAsFixed(2)
                                  : '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Last: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              (tempCompany != null)
                                  ? tempCompany.lastPrice.toStringAsFixed(2)
                                  : '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'High: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              (tempCompany != null)
                                  ? tempCompany.high.toStringAsFixed(2)
                                  : '-',
                              style: TextStyle(
                                  color: (tempCompany != null)
                                      ? Colors.green
                                      : Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              'Low: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Text(
                              (tempCompany != null)
                                  ? tempCompany.low.toStringAsFixed(2)
                                  : '-',
                              style: TextStyle(
                                  color: (tempCompany != null)
                                      ? Colors.red
                                      : Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                  ],
                ),
              ])),
        ]),
        floatingActionButton: getFloatingButton());
  }

  Widget getNewCompany() {
    getQuotes([symbolController.text]).then((value) {
      if (value == null)
        setState(() {
          tempCompany = null;
          _repeated = false;
          _error = true;
        });
      else {
        for (QuoteDetail c in widget.companies) {
          if (c.symbol == value[0].symbol) {
            setState(() {
              tempCompany = null;
              _error = false;
              _repeated = true;
            });
            return;
          }
        }
        setState(() {
          _error = false;
          _repeated = false;
          tempCompany = value[0];
        });
      }
    });
  }

  Widget getFloatingButton() {
    if (tempCompany == null) return Container();

    return FloatingActionButton(
        backgroundColor: Colors.indigo,
        tooltip: 'Increment Counter',
        child: Icon(Icons.check),
        onPressed: () {
          widget.companies.add(tempCompany);

          SharedPreferencesManager.save(
              "Companies", QuoteDetail.encodeListToJson(widget.companies));

          Navigator.pop(context, true);
        });
  }
}
