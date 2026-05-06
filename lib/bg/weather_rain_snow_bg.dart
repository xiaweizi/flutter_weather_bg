// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/constants.dart';
import 'package:flutter_weather_bg/utils/image_utils.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

//// 雨雪动画层
class WeatherRainSnowBg extends StatefulWidget {
  final WeatherType weatherType;
  final double viewWidth;
  final double viewHeight;

  const WeatherRainSnowBg({
    super.key,
    required this.weatherType,
    required this.viewWidth,
    required this.viewHeight,
  });

  @override
  State<WeatherRainSnowBg> createState() => _WeatherRainSnowBgState();
}

class _WeatherRainSnowBgState extends State<WeatherRainSnowBg>
    with SingleTickerProviderStateMixin {
  ui.Image? _rainImage;
  ui.Image? _snowImage;
  late final AnimationController _controller;
  final List<RainSnowParams> _rainSnows = [];
  WeatherDataState _state = WeatherDataState.init;

  /// 异步加载雨 / 雪图片。
  Future<void> _fetchImages() async {
    weatherPrint("开始获取雨雪图片");
    final rain = await ImageUtils.getImage('images/rain.webp');
    final snow = await ImageUtils.getImage('images/snow.webp');
    if (!mounted) {
      rain.dispose();
      snow.dispose();
      return;
    }
    _rainImage = rain;
    _snowImage = snow;
    _state = WeatherDataState.init;
    setState(() {});
  }

  /// 根据当前 size 初始化雨 / 雪粒子参数。
  void _initParams() {
    _state = WeatherDataState.loading;
    if (widget.viewWidth != 0 &&
        widget.viewHeight != 0 &&
        _rainSnows.isEmpty) {
      if (WeatherUtil.isSnowRain(widget.weatherType)) {
        final count = _particleCountFor(widget.weatherType);
        final size = SizeInherited.of(context)!.size;
        final widthRatio = size.width / kDesignWidth;
        final heightRatio = size.height / kDesignHeight;
        for (int i = 0; i < count; i++) {
          _rainSnows.add(
            RainSnowParams(widget.viewWidth, widget.viewHeight,
                widget.weatherType)
              ..init(widthRatio, heightRatio),
          );
        }
        weatherPrint("初始化雨参数成功 ${_rainSnows.length}");
      }
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  static int _particleCountFor(WeatherType t) {
    switch (t) {
      case WeatherType.lightRainy:
        return 70;
      case WeatherType.middleRainy:
        return 100;
      case WeatherType.heavyRainy:
      case WeatherType.thunder:
        return 200;
      case WeatherType.lightSnow:
        return 30;
      case WeatherType.middleSnow:
        return 100;
      case WeatherType.heavySnow:
        return 200;
      default:
        return 0;
    }
  }

  @override
  void didUpdateWidget(WeatherRainSnowBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherType != widget.weatherType ||
        oldWidget.viewWidth != widget.viewWidth ||
        oldWidget.viewHeight != widget.viewHeight) {
      _rainSnows.clear();
      _initParams();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(minutes: 1),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _controller.repeat();
      });
    _fetchImages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rainImage?.dispose();
    _snowImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      _initParams();
    }
    if (_state != WeatherDataState.finish) return const SizedBox.shrink();
    return CustomPaint(
      painter: RainSnowPainter(this, _controller),
    );
  }
}

/// 绘制雨 / 雪粒子。
///
/// 绑定到 [AnimationController]，由它触发 repaint —— widget 本身不重建。
class RainSnowPainter extends CustomPainter {
  final Paint _paint = Paint();
  final _WeatherRainSnowBgState _state;

  RainSnowPainter(this._state, Listenable repaint) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final weatherType = _state.widget.weatherType;
    if (WeatherUtil.isSnow(weatherType) && _state._snowImage != null) {
      _drawParticles(canvas, _state._snowImage!, true);
    } else if (WeatherUtil.isRainy(weatherType) && _state._rainImage != null) {
      _drawParticles(canvas, _state._rainImage!, false);
    }
  }

  void _drawParticles(Canvas canvas, ui.Image image, bool isSnow) {
    for (final p in _state._rainSnows) {
      _move(p, isSnow);
      canvas.save();
      canvas.scale(p.scale);
      // 用 modulate + 白色 alpha 等价于 alpha-only ColorFilter，
      // 避免每帧构建 4x5 matrix list。
      _paint.colorFilter = ColorFilter.mode(
        Color.fromRGBO(255, 255, 255, p.alpha),
        BlendMode.modulate,
      );
      canvas.drawImage(image, Offset(p.x, p.y), _paint);
      canvas.restore();
    }
  }

  void _move(RainSnowParams p, bool isSnow) {
    p.y += p.speed;
    if (isSnow) {
      final offsetX =
          sin(p.y / (300 + 50 * p.alpha)) * (1 + 0.5 * p.alpha) * p.widthRatio;
      p.x += offsetX;
    }
    if (p.y > p.height / p.scale) {
      p.y = -p.height * p.scale;
      if (!isSnow && _state._rainImage != null) {
        p.y = -_state._rainImage!.height.toDouble();
      }
      p.reset();
    }
  }

  @override
  bool shouldRepaint(covariant RainSnowPainter old) => true;
}

class RainSnowParams {
  /// x 坐标
  double x = 0;

  /// y 坐标
  double y = 0;

  /// 下落速度
  double speed = 0;

  /// 绘制的缩放
  double scale = 1;

  /// 视图宽度（不随屏幕旋转变化）
  final double width;

  /// 视图高度
  final double height;

  /// 透明度
  double alpha = 1;

  /// 天气类型
  final WeatherType weatherType;

  double widthRatio = 1;
  double heightRatio = 1;

  RainSnowParams(this.width, this.height, this.weatherType);

  void init(double widthRatio, double heightRatio) {
    this.widthRatio = widthRatio;
    this.heightRatio = max(heightRatio, 0.65);
    reset();
    // 初始 y 分布在整个屏幕高度内，避免一开始全在顶部
    y = kRandom.nextInt(800 ~/ scale).toDouble();
  }

  /// 粒子移出屏幕后重置位置 / 速度 / 透明度等。
  void reset() {
    final ratio = _speedRatio(weatherType);
    final double random = 0.4 + 0.12 * kRandom.nextDouble() * 5;
    if (WeatherUtil.isRainy(weatherType)) {
      scale = random * 1.2;
      speed = 30 * random * ratio * heightRatio;
      alpha = random * 0.6;
    } else {
      scale = random * 0.8 * heightRatio;
      speed = 8 * random * ratio * heightRatio;
      alpha = random;
    }
    x = kRandom.nextInt(width * 1.2 ~/ scale).toDouble() -
        width * 0.1 ~/ scale;
  }

  static double _speedRatio(WeatherType t) {
    switch (t) {
      case WeatherType.lightRainy:
      case WeatherType.lightSnow:
        return 0.5;
      case WeatherType.middleRainy:
      case WeatherType.middleSnow:
        return 0.75;
      case WeatherType.heavyRainy:
      case WeatherType.thunder:
      case WeatherType.heavySnow:
        return 1;
      default:
        return 1;
    }
  }
}
