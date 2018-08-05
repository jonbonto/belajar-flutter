import 'package:flutter/material.dart';

import './mydrawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: AssetImage("img/bg.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                width: 150.0,
                height: 70.0,
                child: new Image.asset("img/logo.jpg"),
              ),
              new Text("video player", style: new TextStyle(fontSize: 20.0),)
            ],
          ),
        ),
      ),
    );
  }
}
