import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:lab3/screens/camera_view.dart';

import '../painters/image_labeler_painter.dart';

class ImageLabelerScreen extends StatefulWidget {
  const ImageLabelerScreen({Key? key}) : super(key: key);

  @override
  State<ImageLabelerScreen> createState() => _ImageLabelerScreenState();
}

class _ImageLabelerScreenState extends State<ImageLabelerScreen> {
  final ImageLabeler _imageLabeler = ImageLabeler(
    options: ImageLabelerOptions(),
  );
  bool _isReady = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  @override
  void dispose() {
    _isReady = false;
    _imageLabeler.close();
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

    final labels = await _imageLabeler.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      _customPaint = CustomPaint(
        painter: ImageLabelerPainter(labels: labels),
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
