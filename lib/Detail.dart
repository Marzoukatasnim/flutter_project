import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import './main.dart';

class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({required this.index,required this.list});
  @override
  _DetailState createState() => new _DetailState();
}
class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("${widget.list[widget.index]['Articles']}")),
      body: new Container(
        height: 270.0,
        padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
            child: new Column(
              children: <Widget>[

                //new Padding(padding: const EdgeInsets.only(top: 30.0),),
                new Text(widget.list[widget.index]['Description'], style: new TextStyle(fontSize: 20.0),),
                //new Text("Code : ${widget.list[widget.index]['item_code']}", style: new TextStyle(fontSize: 18.0),),

                //new Padding(padding: const EdgeInsets.only(top: 30.0),),


              ],
            ),
          ),
        ),
      ),
    );
  }
}