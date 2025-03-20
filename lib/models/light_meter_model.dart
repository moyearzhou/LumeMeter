import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import '../bean/metering_mode.dart';
import '../bean/measure_mode.dart';


class LightMeterModel {
  double ev = 0.0;
  int iso = 100;
  double shutterSpeed = 1/60;
  double aperture = 5.6;
  final ValueNotifier<double> luxNotifier = ValueNotifier(0.0);
  double get lux => luxNotifier.value;
  set lux(double value) => luxNotifier.value = value;
  MeteringMode meteringMode = MeteringMode.average;
  MeasureMode exposureMode = MeasureMode.aperturePriority;


  // 预设的ISO值列表
  static const List<int> isoValues = [50, 100, 200, 400, 800, 1600, 3200, 6400];
  
  // 预设的快门速度列表（秒）
  static const List<double> shutterSpeedValues = [
    1/4000, 1/2000, 1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1.0, 2.0, 4.0, 8.0
  ];
  
  // 预设的光圈值列表
  static const List<double> apertureValues = [
    1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11.0, 16.0, 22.0
  ];

  // 更新ISO值
  void setIso(int value) {
    if (isoValues.contains(value)) {
      iso = value;
    }
  }

  // 更新快门速度
  void setShutterSpeed(double value) {
    if (shutterSpeedValues.contains(value)) {
      shutterSpeed = value;
    }
  }

  // 更新光圈值
  void setAperture(double value) {
    if (apertureValues.contains(value)) {
      aperture = value;
    }
  }

  // 计算EV值
  double calculateEV(double luminance) {
    // 将亮度转换为LUX值
    lux = luminance * 100000; // 根据相机传感器的特性进行校准
    // EV = log2(光圈²/快门时间) + log2(ISO/100)
    return (math.log(aperture * aperture / shutterSpeed) / math.ln2) + (math.log(iso / 100) / math.ln2);
  }

  // 从图像计算亮度
  double calculateLuminance(CameraImage image) {
    // 将YUV格式转换为灰度值
    final bytes = image.planes[0].bytes;
    double totalLuminance = 0;
    int pixelCount = bytes.length;

    // 根据测光模式选择计算区域
    switch (meteringMode) {
      case MeteringMode.spot:
        // 仅计算中心区域
        final centerX = image.width ~/ 2;
        final centerY = image.height ~/ 2;
        final spotSize = 50; // 点测光区域大小
        
        for (int y = centerY - spotSize; y < centerY + spotSize; y++) {
          for (int x = centerX - spotSize; x < centerX + spotSize; x++) {
            if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
              totalLuminance += bytes[y * image.width + x];
            }
          }
        }
        pixelCount = spotSize * spotSize * 4;
        break;
        
      case MeteringMode.matrix:
        // 将图像分为多个区域进行加权计算
        // TODO: 实现更复杂的矩阵测光算法
        totalLuminance = bytes.fold(0, (sum, byte) => sum + byte);
        break;
        
      case MeteringMode.average:
      default:
        // 计算整个画面的平均亮度
        totalLuminance = bytes.fold(0, (sum, byte) => sum + byte);
    }

    return totalLuminance / (pixelCount * 255); // 归一化到0-1范围
  }

  // 更新曝光参数
  void updateExposureParams(double ev) {
    this.ev = ev;
    
    // 根据曝光模式计算参数
    if (exposureMode == MeasureMode.aperturePriority) {
      // 光圈优先模式：根据EV值和光圈计算快门速度
      // EV = log2(光圈²/快门时间) + log2(ISO/100)
      // 快门时间 = 光圈²/(2^(EV - log2(ISO/100)))
      double targetShutterSpeed = (aperture * aperture) / math.pow(2, ev - (math.log(iso / 100) / math.ln2));
      
      // 找到最接近的预设快门速度
      double closestShutterSpeed = shutterSpeedValues.reduce((a, b) {
        return (a - targetShutterSpeed).abs() < (b - targetShutterSpeed).abs() ? a : b;
      });
      setShutterSpeed(closestShutterSpeed);
    } else {
      // 快门优先模式：根据EV值和快门速度计算光圈
      // 光圈 = sqrt(快门时间 * 2^(EV - log2(ISO/100)))
      double targetAperture = math.sqrt(shutterSpeed * math.pow(2, ev - (math.log(iso / 100) / math.ln2)));
      
      // 找到最接近的预设光圈值
      double closestAperture = apertureValues.reduce((a, b) {
        return (a - targetAperture).abs() < (b - targetAperture).abs() ? a : b;
      });
      setAperture(closestAperture);
    }

     print('光圈: f/${aperture.toStringAsFixed(1)}, 快门速度: 1/${(1/shutterSpeed).toStringAsFixed(0)}s, ISO: $iso, EV: ${ev.toStringAsFixed(1)}, 亮度: ${lux.toStringAsFixed(1)} lux: ${lux.toStringAsFixed(1)}');
   
  }
}