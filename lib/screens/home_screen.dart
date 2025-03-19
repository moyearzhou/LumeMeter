import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../bean/measure_mode.dart';
import '../bean/metering_mode.dart';
import 'package:provider/provider.dart';
import '../controllers/camera_controller.dart';
import '../models/light_meter_model.dart';
import '../services/storage_service.dart';
import '../theme/retro_camera_theme.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/parameter_display_widget.dart';
import '../widgets/shutter_speed_widget.dart';
import '../widgets/controls_widget.dart';

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
    return Theme(
      data: RetroCameraTheme.darkTheme,
      child: Scaffold(
        backgroundColor: RetroCameraTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Light Meter'),
          leading: IconButton(
            icon: const Icon(Icons.settings, color: RetroCameraTheme.primaryText),
            onPressed: () {},
          ),
          actions: [
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

            return Column(children: [
              Expanded(
                child: CameraPreviewWidget(controller: cameraProvider.controller!),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: RetroCameraTheme.metallicDecoration,
                child: Column(
                  children: [
                    ParameterDisplayWidget(lightMeter: _lightMeter),
                    ShutterSpeedWidget(
                      lightMeter: _lightMeter,
                      onChanged: (value) {
                        setState(() {
                          _lightMeter.setShutterSpeed(value);
                        });
                      },
                    ),
                    ControlsWidget(
                      controller: cameraProvider.controller!,
                      storage: _storage,
                      lightMeter: _lightMeter,
                    ),
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}