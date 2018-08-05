import 'package:flutter/material.dart';

import './pages/komputer.dart' as komputer;
import './pages/headset.dart' as headset;
import './pages/radio.dart' as radio;
import './pages/smartphone.dart' as hp;

void main() {
  runApp(new MaterialApp(
    title: 'Tab Bar Demo',
    theme: new ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
      // counter didn't reset back to zero; the application is not restarted.
      primarySwatch: Colors.blue,
    ),
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: new Text("Daftar Elektronik"),
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.computer),
            ),
            new Tab(
              icon: new Icon(Icons.headset),
            ),
            new Tab(
              icon: new Icon(Icons.radio),
            ),
            new Tab(
              icon: new Icon(Icons.smartphone),
            )
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new komputer.Komputer(),
          new headset.Headset(),
          new radio.Radio(),
          new hp.Smartphone()
        ],
      ),
    );
  }
}
