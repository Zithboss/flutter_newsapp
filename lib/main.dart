import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Thailand News App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NewsData> data = [];
  Future<String> _getData() async {
    print("Loading");
    var url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=th&category=business&apiKey=7a03d973391b4cae9d8f757a278c811d');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var article in jsonData['articles']) {
        NewsData news = NewsData(article['title'], article['description'],
            article['url'], article['urlToImage']);
        data.add(news);
      }
    }
    return response.statusCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (context, snapshort) {
          if (snapshort.hasData) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          '${data[index].urlToImage}',
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                      ),
                      Text(
                        "${data[index].title}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        "${data[index].description}",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Text("Loading");
          }
        },
      ),
    );
  }
}

class NewsData {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  NewsData(this.title, this.description, this.url, this.urlToImage);
}
