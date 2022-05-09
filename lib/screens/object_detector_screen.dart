import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../painters/object_detector_painter.dart';
import 'camera_view.dart';

class ObjectDetectorScreen extends StatefulWidget {
  const ObjectDetectorScreen({Key? key}) : super(key: key);

  @override
  State<ObjectDetectorScreen> createState() => _ObjectDetectorScreenState();
}

class _ObjectDetectorScreenState extends State<ObjectDetectorScreen> {
  final ObjectDetector _objectDetector = ObjectDetector(
    options: ObjectDetectorOptions(
      classifyObjects: true,
      multipleObjects: true,
    ),
  );
  bool _isReady = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  @override
  void dispose() {
    _isReady = false;
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      painter: _customPaint,
      process: _processImage,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_isReady) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {});

    final detectedObjects = await _objectDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      _customPaint = CustomPaint(
        painter: ObjectDetectorPainter(
          detectedObjects: detectedObjects,
          absoluteSize: inputImage.inputImageData!.size,
          rotation: inputImage.inputImageData!.imageRotation,
        ),
      );
    } else {
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
