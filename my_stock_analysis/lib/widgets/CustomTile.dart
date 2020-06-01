import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystockanalysis/models/QuoteDetail.dart';

class CustomTile extends StatefulWidget {
  final QuoteDetail company;
  CustomTile(this.company);

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
    if (!widget.company.favorite){
      return new Container();
    }

    return new Container(
        color: color,
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.only(top: 8),
        child: ListTile(
          title: widget.company.buildTitle(context),
          subtitle: widget.company.buildSubtitle(context),
          focusColor: Colors.cyanAccent,
          onTap: () {
            setState(() {
              if(color == Colors.cyanAccent)
                color = Colors.indigo;
              else
                color = Colors.cyanAccent;
            });
          },
        ),
    );

  }
}