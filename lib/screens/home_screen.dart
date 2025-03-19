import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../bean/measure_mode.dart';
import '../bean/metering_mode.dart';
import 'package:provider/provider.dart';
import '../controllers/camera_controller.dart';
import '../models/light_meter_model.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LightMeterModel _lightMeter = LightMeterModel();
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    context.read<CameraControllerProvider>().initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测光仪'),
        actions: [
          Row(
            children: [
              PopupMenuButton<MeteringMode>(
                onSelected: (MeteringMode mode) {
                  setState(() {
                    _lightMeter.meteringMode = mode;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<MeteringMode>>[
                  const PopupMenuItem<MeteringMode>(
                    value: MeteringMode.average,
                    child: Text('平均测光'),
                  ),
                  const PopupMenuItem<MeteringMode>(
                    value: MeteringMode.spot,
                    child: Text('点测光'),
                  ),
                  const PopupMenuItem<MeteringMode>(
                    value: MeteringMode.matrix,
                    child: Text('矩阵测光'),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _lightMeter.exposureMode = _lightMeter.exposureMode == MeasureMode.aperturePriority
                        ? MeasureMode.shutterPriority
                        : MeasureMode.aperturePriority;
                  });
                },
                icon: const Icon(Icons.exposure),
                label: Text(_lightMeter.exposureMode == MeasureMode.aperturePriority ? '光圈优先' : '快门优先'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<CameraControllerProvider>(
        builder: (context, cameraProvider, child) {
          if (cameraProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(cameraProvider.errorMessage));
          }

          if (!cameraProvider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: CameraPreview(cameraProvider.controller!),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('EV: ${_lightMeter.ev.toStringAsFixed(1)}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ISO:'),
                        DropdownButton<int>(
                          value: _lightMeter.iso,
                          items: LightMeterModel.isoValues.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            if (value != null) {
                              setState(() {
                                _lightMeter.setIso(value);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('快门速度:'),
                        DropdownButton<double>(
                          value: _lightMeter.shutterSpeed,
                          items: LightMeterModel.shutterSpeedValues.map((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Text(value < 1 ? '1/${(1/value).round()}' : '${value}s'),
                            );
                          }).toList(),
                          onChanged: (double? value) {
                            if (value != null) {
                              setState(() {
                                _lightMeter.setShutterSpeed(value);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('光圈:'),
                        DropdownButton<double>(
                          value: _lightMeter.aperture,
                          items: LightMeterModel.apertureValues.map((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Text('f/${value.toStringAsFixed(1)}'),
                            );
                          }).toList(),
                          onChanged: (double? value) {
                            if (value != null) {
                              setState(() {
                                _lightMeter.setAperture(value);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final image = cameraProvider.controller!.value;
                            if (image.isInitialized) {
                              final luminance = _lightMeter.calculateLuminance(
                                await cameraProvider.controller!.startImageStream(
                                  (CameraImage image) {
                                    final luminance = _lightMeter.calculateLuminance(image);
                                    final ev = _lightMeter.calculateEV(luminance);
                                    setState(() {
                                      _lightMeter.updateExposureParams(ev);
                                    });
                                  },
                                ) as CameraImage,
                              );
                              final ev = _lightMeter.calculateEV(luminance);
                              setState(() {
                                _lightMeter.updateExposureParams(ev);
                              });
                            }
                          },
                          child: const Text('测光'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final image = await cameraProvider.controller!.takePicture();
                              await _storage.saveShot(
                                ev: _lightMeter.ev,
                                iso: _lightMeter.iso,
                                shutterSpeed: _lightMeter.shutterSpeed,
                                aperture: _lightMeter.aperture,
                                meteringMode: _lightMeter.meteringMode.toString(),
                                imagePath: image.path,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('拍摄已保存')),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('保存失败: $e')),
                                );
                              }
                            }
                          },
                          child: const Text('拍摄'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}