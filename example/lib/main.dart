import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg_example/anim_view.dart';

import 'package:flutter_weather_bg_example/grid_view.dart';
import 'package:flutter_weather_bg_example/list_view.dart';
import 'package:flutter_weather_bg_example/page_view.dart';

void main() {
  runApp(MyApp());
}

const routePage = "page";
const routeList = "list";
const routeGrid = "grid";
const routeAnim = "anim";

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
        routePage: (BuildContext context) {
          // 普通的侧滑样式
          return PageViewWidget();
        },
        routeList: (BuildContext context) {
          // 宫格样式
          return ListViewWidget();
        },
        routeGrid: (BuildContext context) {
          // 宫格样式
          return GridViewWidget();
        },
        routeAnim: (BuildContext context) {
          // 动态切换 宽高样式
          return AnimViewWidget();
        }
      },
      home: HomePage(),
    );
  }
}

/// demo 首页布局
class HomePage extends StatelessWidget {
  /// 创建首页 item 布局
  Widget _buildItem(BuildContext context, String routeName, String desc,
      WeatherType weatherType) {
    double width = MediaQuery.of(context).size.width;
    double marginLeft = 10.0;
    double marginTop = 8.0;
    double itemWidth = (width - marginLeft * 4) / 2;
    double itemHeight = itemWidth * 1.5;
    var radius = 10.0;
    return Container(
      width: itemWidth,
      height: itemHeight,
      child: Card(
        elevation: 7,
        margin:
            EdgeInsets.symmetric(horizontal: marginLeft, vertical: marginTop),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          child: Stack(
            children: [
              WeatherBg(
                weatherType: weatherType,
                width: itemWidth,
                height: itemHeight,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: InkWell(
                  child: Center(
                    child: Text(
                      desc,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    weatherPrint("name: $routeName");
                    Navigator.of(context).pushNamed(routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          children: [
            _buildItem(context, routePage, "翻页效果", WeatherType.thunder),
            _buildItem(context, routeGrid, "宫格效果", WeatherType.sunnyNight),
            _buildItem(context, routeList, "列表效果", WeatherType.lightSnow),
            _buildItem(context, routeAnim, "切换效果", WeatherType.sunny),
          ],
        ),
      ),
    );
  }
}
