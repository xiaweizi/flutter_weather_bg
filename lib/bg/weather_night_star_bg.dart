import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/constants.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

//// 晴晚星空 / 流星层
class WeatherNightStarBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherNightStarBg({super.key, required this.weatherType});

  @override
  State<WeatherNightStarBg> createState() => _WeatherNightStarBgState();
}

class _WeatherNightStarBgState extends State<WeatherNightStarBg>
    with SingleTickerProviderStateMixin {
  static const int _starCount = 100;
  static const int _meteorCount = 4;

  late final AnimationController _controller;
  final List<_StarParam> _starParams = [];
  final List<_MeteorParam> _meteorParams = [];
  WeatherDataState _state = WeatherDataState.init;
  double width = 0;
  double height = 0;
  double widthRatio = 1;

  /// 读取 size 并初始化星星 / 流星参数。
  void _setup() {
    final size = SizeInherited.of(context)!.size;
    width = size.width;
    height = size.height;
    widthRatio = width / kDesignWidth;
    weatherPrint("开始准备星星参数");
    _state = WeatherDataState.loading;
    _initParams();
    if (!mounted) return;
    _controller.repeat();
    _state = WeatherDataState.finish;
    setState(() {});
  }

  void _initParams() {
    for (int i = 0; i < _starCount; i++) {
      _starParams.add(
        _StarParam(kRandom.nextInt(2))..init(width, height, widthRatio),
      );
    }
    for (int i = 0; i < _meteorCount; i++) {
      _meteorParams.add(_MeteorParam()..init(width, height, widthRatio));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      _setup();
    }
    if (_state != WeatherDataState.finish ||
        widget.weatherType != WeatherType.sunnyNight ||
        _starParams.isEmpty) {
      return const SizedBox.shrink();
    }
    return CustomPaint(
      painter: _StarPainter(
        _starParams,
        _meteorParams,
        width,
        height,
        widthRatio,
        _controller,
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<_StarParam> _starParams;
  final List<_MeteorParam> _meteorParams;
  final double width;
  final double height;
  final double widthRatio;

  static const double _meteorWidth = 200;
  static const double _meteorHeight = 2;
  static const Radius _radius = Radius.circular(10);

  final Paint _paint = Paint();
  final Paint _meteorPaint = Paint();

  _StarPainter(this._starParams, this._meteorParams, this.width, this.height,
      this.widthRatio, Listenable repaint)
      : super(repaint: repaint) {
    _paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _starParams) {
      _drawStar(p, canvas);
    }
    for (final p in _meteorParams) {
      _drawMeteor(p, canvas);
    }
  }

  void _drawMeteor(_MeteorParam p, Canvas canvas) {
    canvas.save();
    // 流星梯度可以预构建成 shader 缓存，但这里每帧开销本来就小（4 条流星）
    final gradient = ui.Gradient.linear(
      const Offset(0, 0),
      const Offset(_meteorWidth, 0),
      const <Color>[Color(0xFFFFFFFF), Color(0x00FFFFFF)],
    );
    _meteorPaint.shader = gradient;
    canvas.rotate(pi * p.radians);
    canvas.scale(widthRatio);
    canvas.translate(
        p.translateX, tan(pi * 0.1) * _meteorWidth + p.translateY);
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        _meteorWidth,
        _meteorHeight,
        topLeft: _radius,
        topRight: _radius,
        bottomRight: _radius,
        bottomLeft: _radius,
      ),
      _meteorPaint,
    );
    p.move();
    canvas.restore();
  }

  void _drawStar(_StarParam p, Canvas canvas) {
    canvas.save();
    // 白色点 × alpha：modulate 替代 4x5 matrix，避免 100 个星星每帧都构造 matrix
    _paint.colorFilter = ColorFilter.mode(
      Color.fromRGBO(255, 255, 255, p.alpha),
      BlendMode.modulate,
    );
    canvas.scale(p.scale);
    canvas.drawCircle(Offset(p.x, p.y), 3, _paint);
    canvas.restore();
    p.move();
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => true;
}

class _MeteorParam {
  double translateX = 0;
  double translateY = 0;
  double radians = 0;

  double width = 0;
  double height = 0;
  double widthRatio = 1;

  void init(double width, double height, double widthRatio) {
    this.width = width;
    this.height = height;
    this.widthRatio = widthRatio;
    reset();
  }

  void reset() {
    translateX = width + kRandom.nextDouble() * 20.0 * width;
    radians = -kRandom.nextDouble() * 0.07 - 0.05;
    translateY = kRandom.nextDouble() * 0.5 * height * widthRatio;
  }

  void move() {
    translateX -= 20;
    if (translateX <= -1.0 * width / widthRatio) reset();
  }
}

class _StarParam {
  double x = 0;
  double y = 0;
  double alpha = 0.0;
  double scale = 1;
  bool reverse = false;

  final int index;
  double width = 0;
  double height = 0;
  double widthRatio = 1;

  _StarParam(this.index);

  void reset() {
    alpha = 0;
    final baseScale = index == 0 ? 0.7 : 0.5;
    scale = (kRandom.nextDouble() * 0.1 + baseScale) * widthRatio;
    x = kRandom.nextDouble() * 1 * width / scale;
    y = kRandom.nextDouble() * max(0.3 * height, 150);
    reverse = false;
  }

  void init(double width, double height, double widthRatio) {
    this.width = width;
    this.height = height;
    this.widthRatio = widthRatio;
    alpha = kRandom.nextDouble();
    final baseScale = index == 0 ? 0.7 : 0.5;
    scale = (kRandom.nextDouble() * 0.1 + baseScale) * widthRatio;
    x = kRandom.nextDouble() * 1 * width / scale;
    y = kRandom.nextDouble() * max(0.3 * height, 150);
    reverse = false;
  }

  /// 星星的呼吸动画：透明度从 0 → 1.2 → 0 循环。
  void move() {
    if (reverse) {
      alpha -= 0.01;
      if (alpha < 0) reset();
    } else {
      alpha += 0.01;
      if (alpha > 1.2) reverse = true;
    }
  }
}
