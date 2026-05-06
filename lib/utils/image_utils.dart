import 'dart:ui' as ui;

import 'package:flutter/services.dart';

/// 图片相关的工具类
class ImageUtils {
  /// 绘制时需要用到 ui.Image 的对象，通过此方法进行转换
  static Future<ui.Image> getImage(String asset) async {
    final ByteData data =
        await rootBundle.load("packages/flutter_weather_bg/$asset");
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
