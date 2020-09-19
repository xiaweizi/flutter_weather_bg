import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_example/anim_view.dart';

import 'package:flutter_weather_bg_example/grid_view.dart';
import 'package:flutter_weather_bg_example/page_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "page": (BuildContext context) {
          // 普通的侧滑样式
          return PageViewWidget();
        },
        "grid": (BuildContext context) {
          // 宫格样式
          return GridViewWidget();
        },
        "anim": (BuildContext context) {
          // 动态切换 宽高样式
          return AnimViewWidget();
        }
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("page"),
              onPressed: () {
                Navigator.of(context).pushNamed("page");
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("grid"),
              onPressed: () {
                Navigator.of(context).pushNamed("grid");
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("anim"),
              onPressed: () {
                Navigator.of(context).pushNamed("anim");
              },
            )
          ],
        ),
      ),
    );
  }
}
