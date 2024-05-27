import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

//Creating a class user to store the data;
class User {
  final int id;
  final int userId;
  final String title;
  final String body;

  User({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

//Future represents a value  that will be available at some point in the future.
  Future<List<User>> getRequest() async {
    //replace your restFull API here.
    String url = "https://jsonplaceholder.typicode.com/posts";
    final response = await http.get(Uri.parse(url));//This line sends the GET request to the specified URL using http.get()

    var responseData = json.decode(response.body);//decode the json response body

    //Creating a list to store input data;
    List<User> users = [];
    for (var i in responseData) {
      User user = User(
          id: i["id"],
          userId: i["userId"],
          title: i["title"],
          body: i["body"]);

      //Adding user to the list.
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Http Get Request."),

        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {//snapshot is an object of type AsyncSnapshot, which represents the current state of the Future.
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) => ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].body),
                    contentPadding: EdgeInsets.only(bottom: 20.0),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
