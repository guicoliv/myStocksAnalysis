import 'package:flutter/material.dart';
import 'package:mystockanalysis/http_request.dart';
import 'package:mystockanalysis/models/Company.dart';




class AddCompany extends StatefulWidget {
  final List<Company> companies;
  AddCompany({Key key, this.companies}) : super(key: key);

  @override
  AddCompanyState createState() => AddCompanyState();
}


class AddCompanyState extends State<AddCompany> {
  final nameController = TextEditingController();
  final symbolController = TextEditingController();



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
                          child: new Text('Name: ', style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                        ),
                        new Flexible(
                          child: new TextField(
                              style: TextStyle(fontSize: 24.0),
                              controller: nameController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),

                              )
                          ),
                        ),
                      ],
                    ),
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
                print("erro");
              else{
                widget.companies.add(new Company(id:widget.companies.length, symbol:value[0].symbol, name:value[0].name, favorite: false));
                
                
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
