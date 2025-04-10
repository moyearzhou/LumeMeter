import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import '../bean/metering_mode.dart';
import '../bean/measure_mode.dart';


class LightMeterModel {
  final ValueNotifier<double> evNotifier = ValueNotifier(0.0);
  double get ev => evNotifier.value;
  set ev(double value) => evNotifier.value = value;
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
   double calculateEV(CameraImage image) {
    final lensAperture = (image.lensAperture ?? 0.0);

    
    // 曝光时间：秒, 需要将纳秒转为秒
    final lensShutterSpeed = (image.sensorExposureTime ?? 0) / 1e9;
    final sensorLense= image.sensorSensitivity ?? 0;

    final evApertureShutter = log(pow(lensAperture, 2) / lensShutterSpeed) / log(2);
    final evISO = log(sensorLense / 100) / log(2);

    // 计算EV值
    double ev = evApertureShutter - evISO;
    // print('Aperture: $lensAperture, ShutterSpeed: $lensShutterSpeed, ISO: $sensorLense , EV: $ev');
    return ev;
   }

  // 从图像计算亮度
  double calculateLuminance(double ev) {
    final lux = 2.5 * pow(2, ev); // EV=0 → 2.5 Lux（基准值）
    return lux;
  }

  // 计算光圈, 注意：这个返回的是最接近的光圈值
  static double calAperture(double targetEv, double targetShutterSpeed, int targetIso) {
    double calculatedAperture = math.sqrt(targetShutterSpeed * math.pow(2, targetEv - (math.log(targetIso / 100) / math.ln2)));

    double targetAperture = apertureValues.reduce((a, b) {
      return (a - calculatedAperture).abs() < (b - calculatedAperture).abs() ? a : b;
     });
    return targetAperture;
  }

  // 更新曝光参数
  void updateExposureParams(double newEv) {
    ev = newEv;
    
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

    //  print('光圈: f/${aperture.toStringAsFixed(1)}, 快门速度: 1/${(1/shutterSpeed).toStringAsFixed(0)}s, ISO: $iso, EV: ${ev.toStringAsFixed(1)}, 亮度: ${lux.toStringAsFixed(1)} lux: ${lux.toStringAsFixed(1)}');
   
  }
}