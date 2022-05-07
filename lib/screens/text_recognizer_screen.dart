import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lab3/screens/camera_view.dart';

import '../painters/text_recognizer_painter.dart';

class TextRecognizerScreen extends StatefulWidget {
  const TextRecognizerScreen({Key? key}) : super(key: key);

  @override
  State<TextRecognizerScreen> createState() => _TextRecognizerScreenState();
}

class _TextRecognizerScreenState extends State<TextRecognizerScreen> {
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isReady = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  @override
  void dispose() {
    _isReady = false;
    _textRecognizer.close();
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

    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      _customPaint = CustomPaint(
        painter: TextRecognizerPainter(
          recognizedText: recognizedText,
          absoluteImageSize: inputImage.inputImageData!.size,
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
