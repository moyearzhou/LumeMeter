import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraControllerProvider extends ChangeNotifier {
  CameraController? _controller;
  bool _isInitialized = false;
  String _errorMessage = '';

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  String get errorMessage => _errorMessage;

  Future<void> initializeCamera() async {
    // 检查相机权限
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _errorMessage = '需要相机权限才能使用测光功能';
      notifyListeners();
      return;
    }

    try {
      // 获取可用相机列表
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _errorMessage = '没有找到可用的相机';
        notifyListeners();
        return;
      }

      // 默认使用后置相机
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // 初始化相机控制器
      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      // 等待相机初始化完成
      await _controller!.initialize();
      _isInitialized = true;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      _errorMessage = '相机初始化失败: $e';
      notifyListeners();
    }
  }

  Future<void> startImageStream(Function(CameraImage) onImage) async {
    if (!_isInitialized || _controller == null) return;

    await _controller!.startImageStream(onImage);
  }

  Future<void> stopImageStream() async {
    if (!_isInitialized || _controller == null) return;

    await _controller!.stopImageStream();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}