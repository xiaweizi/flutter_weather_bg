import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/utils/constants.dart';
import 'package:flutter_weather_bg/utils/image_utils.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';
import 'package:flutter_weather_bg/utils/weather_type.dart';

//// 专门负责绘制背景云层。
////
//// 对同一张 `cloud.webp`（以及 sunny 下的 `sun.webp`）在不同天气类型下做
//// 位移 / 缩放 / 渐变染色，实现多种氛围。
////
//// 绘制配置通过 [_CloudLayer] / [_kSpecs] 数据驱动，避免十几种天气各写一个
//// `drawXxx` 方法。
class WeatherCloudBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherCloudBg({super.key, required this.weatherType});

  @override
  State<WeatherCloudBg> createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherCloudBg> {
  ui.Image? _cloudImage;
  ui.Image? _sunImage;

  Future<void> _fetchImages() async {
    weatherPrint("开始获取云层图片");
    final cloud = await ImageUtils.getImage('images/cloud.webp');
    final sun = await ImageUtils.getImage('images/sun.webp');
    if (!mounted) {
      cloud.dispose();
      sun.dispose();
      return;
    }
    setState(() {
      _cloudImage = cloud;
      _sunImage = sun;
    });
    weatherPrint("获取云层图片成功");
  }

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  @override
  void dispose() {
    _cloudImage?.dispose();
    _sunImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cloud = _cloudImage;
    final sun = _sunImage;
    if (cloud == null || sun == null) return const SizedBox.shrink();
    final size = SizeInherited.of(context)!.size;
    return CustomPaint(
      painter: _CloudPainter(
        cloudImage: cloud,
        sunImage: sun,
        weatherType: widget.weatherType,
        widthRatio: size.width / kDesignWidth,
        width: size.width,
      ),
    );
  }
}

/// 一层云绘制的配置。
///
/// Sunny 的太阳层走 [_CloudPainter._drawSunny] 特殊路径，不走 spec。
class _CloudLayer {
  /// 染色矩阵（4x5，共 20 个 double）。
  final List<double> colorMatrix;

  /// 绘制缩放：实际 scale = [scaleFactor] * widthRatio。
  final double scaleFactor;

  /// offset 列表生成器（多数 spec 依赖 `image.width` 做对齐）。
  final List<Offset> Function(ui.Image image) offsetsOf;

  const _CloudLayer({
    required this.colorMatrix,
    required this.scaleFactor,
    required this.offsetsOf,
  });
}

// ---- 预生成的颜色矩阵常量，均为 identity + alpha + tint 组合 ----
const List<double> _mClearAlpha90 = [
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 0, 1, 0, 0, //
  0, 0, 0, 0.9, 0, //
];
const List<double> _mCloudyNight = [
  0.32, 0, 0, 0, 0, //
  0, 0.39, 0, 0, 0, //
  0, 0, 0.52, 0, 0, //
  0, 0, 0, 0.9, 0, //
];
const List<double> _mOvercast = [
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 0, 1, 0, 0, //
  0, 0, 0, 0.7, 0, //
];
const List<double> _mLightRainy = [
  0.45, 0, 0, 0, 0, //
  0, 0.52, 0, 0, 0, //
  0, 0, 0.6, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mMiddleRainy = [
  0.16, 0, 0, 0, 0, //
  0, 0.22, 0, 0, 0, //
  0, 0, 0.31, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mHeavyRainy = [
  0.19, 0, 0, 0, 0, //
  0, 0.2, 0, 0, 0, //
  0, 0, 0.22, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mHazy = [
  0.67, 0, 0, 0, 0, //
  0, 0.67, 0, 0, 0, //
  0, 0, 0.67, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mFoggy = [
  0.75, 0, 0, 0, 0, //
  0, 0.77, 0, 0, 0, //
  0, 0, 0.82, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mDusty = [
  0.62, 0, 0, 0, 0, //
  0, 0.55, 0, 0, 0, //
  0, 0, 0.45, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mLightSnow = [
  0.67, 0, 0, 0, 0, //
  0, 0.75, 0, 0, 0, //
  0, 0, 0.87, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mMiddleSnow = [
  0.7, 0, 0, 0, 0, //
  0, 0.77, 0, 0, 0, //
  0, 0, 0.87, 0, 0, //
  0, 0, 0, 1, 0, //
];
const List<double> _mHeavySnow = [
  0.74, 0, 0, 0, 0, //
  0, 0.74, 0, 0, 0, //
  0, 0, 0.81, 0, 0, //
  0, 0, 0, 1, 0, //
];

// 常见的三朵云布局 / 两朵云布局（偏移依赖图片宽度，所以用 offsetsOf）
List<Offset> _threeCloudOffsets(ui.Image image) => [
      const Offset(0, -200),
      Offset(-image.width / 2, -130),
      const Offset(100, 0),
    ];

List<Offset> _twoSnowOffsets(ui.Image image) => const [
      Offset(-380, -100),
      Offset(0, -170),
    ];

List<Offset> _threeRainOffsets(ui.Image image) => const [
      Offset(-380, -150),
      Offset(0, -60),
      Offset(0, 60),
    ];

List<Offset> _singleHugeOffset(ui.Image image) =>
    [Offset(-image.width * 0.5, -200)];

/// 各天气类型的绘制规格表。
///
/// 不在这张表里的类型（sunny / sunnyNight）由 _CloudPainter.paint 里的
/// 特殊路径处理，或不画云。
final Map<WeatherType, List<_CloudLayer>> _kSpecs = {
  WeatherType.cloudy: [
    _CloudLayer(
      colorMatrix: _mClearAlpha90,
      scaleFactor: 0.8,
      offsetsOf: _threeCloudOffsets,
    ),
  ],
  WeatherType.cloudyNight: [
    _CloudLayer(
      colorMatrix: _mCloudyNight,
      scaleFactor: 0.8,
      offsetsOf: _threeCloudOffsets,
    ),
  ],
  WeatherType.overcast: [
    _CloudLayer(
      colorMatrix: _mOvercast,
      scaleFactor: 0.8,
      offsetsOf: _threeCloudOffsets,
    ),
  ],
  WeatherType.lightRainy: [
    _CloudLayer(
      colorMatrix: _mLightRainy,
      scaleFactor: 0.8,
      offsetsOf: _threeRainOffsets,
    ),
  ],
  WeatherType.middleRainy: [
    _CloudLayer(
      colorMatrix: _mMiddleRainy,
      scaleFactor: 0.8,
      offsetsOf: _threeRainOffsets,
    ),
  ],
  WeatherType.heavyRainy: [
    _CloudLayer(
      colorMatrix: _mHeavyRainy,
      scaleFactor: 0.8,
      offsetsOf: _threeRainOffsets,
    ),
  ],
  WeatherType.thunder: [
    // 与 heavyRainy 同款云层
    _CloudLayer(
      colorMatrix: _mHeavyRainy,
      scaleFactor: 0.8,
      offsetsOf: _threeRainOffsets,
    ),
  ],
  WeatherType.hazy: [
    _CloudLayer(
      colorMatrix: _mHazy,
      scaleFactor: 2.0,
      offsetsOf: _singleHugeOffset,
    ),
  ],
  WeatherType.foggy: [
    _CloudLayer(
      colorMatrix: _mFoggy,
      scaleFactor: 2.0,
      offsetsOf: _singleHugeOffset,
    ),
  ],
  WeatherType.dusty: [
    _CloudLayer(
      colorMatrix: _mDusty,
      scaleFactor: 2.0,
      offsetsOf: _singleHugeOffset,
    ),
  ],
  WeatherType.lightSnow: [
    _CloudLayer(
      colorMatrix: _mLightSnow,
      scaleFactor: 0.8,
      offsetsOf: _twoSnowOffsets,
    ),
  ],
  WeatherType.middleSnow: [
    _CloudLayer(
      colorMatrix: _mMiddleSnow,
      scaleFactor: 0.8,
      offsetsOf: _twoSnowOffsets,
    ),
  ],
  WeatherType.heavySnow: [
    _CloudLayer(
      colorMatrix: _mHeavySnow,
      scaleFactor: 0.8,
      offsetsOf: _twoSnowOffsets,
    ),
  ],
  // sunnyNight 不画云，用 WeatherNightStarBg 画星空
};

class _CloudPainter extends CustomPainter {
  final ui.Image cloudImage;
  final ui.Image sunImage;
  final WeatherType weatherType;
  final double widthRatio;
  final double width;
  final Paint _paint = Paint();

  _CloudPainter({
    required this.cloudImage,
    required this.sunImage,
    required this.weatherType,
    required this.widthRatio,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // sunny 需要特殊处理太阳的位置（基于宽度靠右）
    if (weatherType == WeatherType.sunny) {
      _drawSunny(canvas);
      return;
    }
    final layers = _kSpecs[weatherType];
    if (layers == null) return;
    for (final layer in layers) {
      _drawLayer(canvas, layer);
    }
  }

  void _drawSunny(Canvas canvas) {
    // 1) 太阳（带 blur 光晕，放在画布右上）
    _paint
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40)
      ..colorFilter = null;
    canvas.save();
    final sunScale = 1.2 * widthRatio;
    canvas.scale(sunScale, sunScale);
    final sunOffset = Offset(
      width - sunImage.width.toDouble() * sunScale,
      -sunImage.width.toDouble() / 2,
    );
    canvas.drawImage(sunImage, sunOffset, _paint);
    canvas.restore();

    // 2) 左上角远处的云（和太阳共用模糊效果）
    canvas.save();
    final cloudScale = 0.6 * widthRatio;
    canvas.scale(cloudScale, cloudScale);
    canvas.drawImage(cloudImage, const Offset(-100, -100), _paint);
    canvas.restore();
  }

  void _drawLayer(Canvas canvas, _CloudLayer layer) {
    _paint
      ..maskFilter = null
      ..colorFilter = ColorFilter.matrix(layer.colorMatrix);

    final offsets = layer.offsetsOf(cloudImage);
    final scale = layer.scaleFactor * widthRatio;

    canvas.save();
    canvas.scale(scale, scale);
    for (final off in offsets) {
      canvas.drawImage(cloudImage, off, _paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CloudPainter old) =>
      old.weatherType != weatherType ||
      old.widthRatio != widthRatio ||
      old.width != width ||
      old.cloudImage != cloudImage ||
      old.sunImage != sunImage;
}
