import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'dart:ui' as ui;

import 'package:flutter_weather_bg/utils/weather_type.dart';

//// 晴晚&流星层
class WeatherNightStarBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherNightStarBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherNightStarBgState createState() => _WeatherNightStarBgState();
}

class _WeatherNightStarBgState extends State<WeatherNightStarBg>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<_StarParam> _starParams = [];
  List<_MeteorParam> _meteorParams = [];
  WeatherDataState _state = WeatherDataState.init;
  double width;
  double height;
  double widthRatio;

  /// 准备星星的参数信息
  void fetchData() async {
    Size size = SizeInherited.of(context).size;
    width = size.width;
    height = size.height;
    widthRatio = width / 392.0;
    weatherPrint("开始准备星星参数");
    _state = WeatherDataState.loading;
    initStarParams();
    setState(() {
      _controller.repeat();
    });
    _state = WeatherDataState.finish;
  }

  /// 初始化星星参数
  void initStarParams() {
    for (int i = 0; i < 100; i++) {
      var index = Random().nextInt(2);
      _StarParam _starParam = _StarParam(index);
      _starParam.init(width, height, widthRatio);
      _starParams.add(_starParam);
    }
    for (int i = 0; i < 4; i++) {
      _MeteorParam param = _MeteorParam();
      param.init(width, height, widthRatio);
      _meteorParams.add(param);
    }
  }

  @override
  void initState() {
    /// 初始化动画信息
    _controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    if (_starParams != null &&
        _starParams.isNotEmpty &&
        widget.weatherType == WeatherType.sunnyNight) {
      return CustomPaint(
        painter:
            _StarPainter(_starParams, _meteorParams, width, height, widthRatio),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      fetchData();
    } else if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class _StarPainter extends CustomPainter {
  final _paint = Paint();
  final _meteorPaint = Paint();
  final List<_StarParam> _starParams;

  final width;
  final height;
  final widthRatio;

  /// 配置星星数据信息
  final List<_MeteorParam> _meteorParams;

  /// 流星参数信息
  final double _meteorWidth = 200;

  /// 流星的长度
  final double _meteorHeight = 2;

  /// 流星的高度
  final Radius _radius = Radius.circular(10);

  /// 流星的圆角半径
  _StarPainter(this._starParams, this._meteorParams, this.width, this.height,
      this.widthRatio) {
    _paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 1);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_starParams != null && _starParams.isNotEmpty) {
      for (var param in _starParams) {
        drawStar(param, canvas);
      }
    }
    if (_meteorParams != null && _meteorParams.isNotEmpty) {
      for (var param in _meteorParams) {
        drawMeteor(param, canvas);
      }
    }
  }

  /// 绘制流星
  void drawMeteor(_MeteorParam param, Canvas canvas) {
    canvas.save();
    var gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(_meteorWidth, 0),
      <Color>[const Color(0xFFFFFFFF), const Color(0x00FFFFFF)],
    );
    _meteorPaint.shader = gradient;
    canvas.rotate(pi * param.radians);
    canvas.scale(widthRatio);
    canvas.translate(
        param.translateX, tan(pi * 0.1) * _meteorWidth + param.translateY);
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(0, 0, _meteorWidth, _meteorHeight,
            topLeft: _radius,
            topRight: _radius,
            bottomRight: _radius,
            bottomLeft: _radius),
        _meteorPaint);
    param.move();
    canvas.restore();
  }

  /// 绘制星星
  void drawStar(_StarParam param, Canvas canvas) {
    if (param == null) {
      return;
    }
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      param.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(param.scale);
    canvas.drawCircle(Offset(param.x, param.y), 3, _paint);
    canvas.restore();
    param.move();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _MeteorParam {
  double translateX;
  double translateY;
  double radians;

  double width, height, widthRatio;

  /// 初始化数据
  void init(width, height, widthRatio) {
    this.width = width;
    this.height = height;
    this.widthRatio = widthRatio;
    reset();
  }

  /// 重置数据
  void reset() {
    translateX = width + Random().nextDouble() * 20.0 * width;
    radians = -Random().nextDouble() * 0.07 - 0.05;
    translateY = Random().nextDouble() * 0.5 * height * widthRatio;
  }

  /// 移动
  void move() {
    translateX -= 20;
    if (translateX <= -1.0 * width / widthRatio) {
      reset();
    }
  }
}

class _StarParam {
  /// x 坐标
  double x;

  /// y 坐标
  double y;

  /// 透明度值，默认为 0
  double alpha = 0.0;

  /// 缩放
  double scale;

  /// 是否反向动画
  bool reverse = false;

  /// 当前下标值
  int index;

  double width;

  double height;

  double widthRatio;

  _StarParam(this.index);

  void reset() {
    alpha = 0;
    double baseScale = index == 0 ? 0.7 : 0.5;
    scale = (Random().nextDouble() * 0.1 + baseScale) * widthRatio;
    x = Random().nextDouble() * 1 * width / scale;
    y = Random().nextDouble() * max(0.3 * height, 150);
    reverse = false;
  }

  /// 用于初始参数
  void init(width, height, widthRatio) {
    this.width = width;
    this.height = height;
    this.widthRatio = widthRatio;
    alpha = Random().nextDouble();
    double baseScale = index == 0 ? 0.7 : 0.5;
    scale = (Random().nextDouble() * 0.1 + baseScale) * widthRatio;
    x = Random().nextDouble() * 1 * width / scale;
    y = Random().nextDouble() * max(0.3 * height, 150);
    reverse = false;
  }

  /// 每次绘制完会触发此方法，开始移动
  void move() {
    if (reverse == true) {
      alpha -= 0.01;
      if (alpha < 0) {
        reset();
      }
    } else {
      alpha += 0.01;
      if (alpha > 1.2) {
        reverse = true;
      }
    }
  }
}
