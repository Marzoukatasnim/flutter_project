import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import './Detail.dart';


void main() {
  runApp(MaterialApp(
    title: "MY APP",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Map m;
  TextEditingController controller = TextEditingController();
  Future<Null> getData() async {
    final response = await http.get(Uri.parse(url));
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map user in responseJson) {
        _userDetails.add(_ArticleDescription.fromJson(user));
      }
    });

  }
  @override
  void initState() {


    super.initState();

    getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MY APP"),
      ),

      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(

                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {

                return Container(
                  padding: const EdgeInsets.all(10.0),

                child: new GestureDetector(
                onTap: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                builder: (BuildContext context)=> new Detail( list: _searchResult, index: i,)
                )
                ),
                child: new Card(

                child: CustomListItemTwo(
                    thumbnail: Container(
                      decoration: const BoxDecoration(color: Colors.blue),
                    ),

                    articles: (_searchResult[i].articles),
                    features: (_searchResult[i].features),
                    features2: (_searchResult[i].features2),
                    //description: (list[i]['Description']),

                  ),
                ),
                ),

                 // margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return Card(
                  child: CustomListItemTwo(
                    thumbnail: Container(
                      decoration: const BoxDecoration(color: Colors.blue),
                    ),

                    articles: (_userDetails[index].articles),
                    features: (_userDetails[index].features),
                    features2: (_userDetails[index].features2),
                    //description: (list[i]['Description']),

                  ),
                //  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.articles.toUpperCase().contains(text.toUpperCase()) || userDetail.features.toUpperCase().contains(text.toUpperCase())
          ||userDetail.features2.toUpperCase().contains(text.toUpperCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}
/*
class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
}
class ListSearchState extends State<ListSearch> {

  TextEditingController _textController = TextEditingController();
  List newList= [];



  // Copy Main List into New List.
  // List<String> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
     // var text = MyStatelessWidget(list: [],).list;
      newList=MyStatelessWidget(list: [],).list.where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Search here....",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _textController.clear,
                  icon: Icon(Icons.clear),
                ),


              ),
              onChanged: onItemChanged,
            ),

          ),
          Expanded(
            child:
            new FutureBuilder<List>(
              future: _HomeState().getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? new MyStatelessWidget(
                  list: snapshot.data??[],
                )
                    : new Center(
                  child:
                  //Text("someeeeeeeeeeee Dataa"),
                  CircularProgressIndicator(),

                );
              },
            ),
          )
        ],
      ),
    );
  }
}*/
List<_ArticleDescription> _searchResult = [];

List<_ArticleDescription> _userDetails = [];

final String url = 'http://172.16.100.12/api/conn2.php';
class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    Key? key,
    required this.articles,
    required this.features,
    required this.features2,
    //required this.description,

  }) : super(key: key);

  final String articles;
  final String features;
  final String features2;
  // final String description;
  factory _ArticleDescription.fromJson(Map<dynamic, dynamic> json) {
    return _ArticleDescription(
      articles: json['Articles'],
      features: json['Features'],
      features2: json['Features2'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                articles,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                features,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                features2,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              /*Text(
                description,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    Key? key,
    required this.thumbnail,
    required this.articles,
    required this.features,
    required this.features2,
    // required this.description,

  }) : super(key: key);
  final Widget thumbnail;
  final String articles;
  final String features;
  final String features2;
  //final String description;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.8,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0,0.0),
                child: _ArticleDescription(
                  articles: articles,
                  features: features,
                  features2: features2,
                  // description: description,

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class MyStatelessWidget extends StatelessWidget {
  final List list;
//final  List<String> list;


  const MyStatelessWidget({ required this.list});

  //const MyStatelessWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: ()=>Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context)=> Detail(list:list , index: i,)
                  )
              ),

              child:Column(

                children:<Widget> [
                  CustomListItemTwo(
                    thumbnail: Container(
                      decoration: const BoxDecoration(color: Colors.blue),
                    ),

                    articles: (list[i]['Articles']),
                    features: (list[i]['Features']),
                    features2: (list[i]['Features2']),
                    //description: (list[i]['Description']),

                  ),

                ],
              ),
            ),
          );
        }
    );
  }
}





/*class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context)=> new Detail(list:list , index: i,)
                )
            ),
            child: new Card(

              child: new ListTile(
                title: new Text(list[i]['Features']),
                leading: new Icon(Icons.widgets),
                subtitle: new Text(list[i]['Articles']),
              ),
            ),
          ),
        );
      },
    );
  }
}*/
