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



  @override
  Widget build(BuildContext context) {
    print("Building Add Company page");

    return Scaffold(
        appBar: AppBar(
          title: Text('StockAnalysis'),
          automaticallyImplyLeading: true,
        ),
        body:  Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Add new company",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                    ]),
              )),
          Container(
              padding: EdgeInsets.all(50),
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: SafeArea(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: new Text('Symbol: ', style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                        ),
                        new Flexible(
                          child: new TextField(
                              style: TextStyle(fontSize: 24.0),
                              controller: symbolController,
                              decoration: InputDecoration(
                                errorText: _error ? 'Wrong Symbol' : _repeated ? 'Already Exists' : null,
                                errorStyle: TextStyle(fontSize: 16),
                                contentPadding: EdgeInsets.all(10),

                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          tooltip: 'Increment Counter',
          child: Icon(Icons.check),
          onPressed: ()  {
            getQuotes([symbolController.text]).then((value) {
              if(value == null)
                setState(() {
                  _repeated = false;
                  _error = true;
                });
              else{
                for(QuoteDetail c in widget.companies){
                  if(c.symbol == value[0].symbol) {
                    setState(() {
                      _error = false;
                      _repeated = true;
                    });
                    return;
                  }
                }
                _error = false;
                _repeated = false;
                widget.companies.add(value[0]);

                SharedPreferencesManager.save(
                    "Companies", QuoteDetail.encodeListToJson(widget.companies));
                
                Navigator.pop(context, true);
                
              }
            });
            //testar pedido
            //if result.status == 204
            //invalid
            //else
            //new company
          },
        ));

  }


}
