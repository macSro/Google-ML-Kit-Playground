import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

import '../main.dart';

class CameraView extends StatefulWidget {
  final CustomPaint? painter;
  final Function(InputImage inputImage) process;

  const CameraView({
    Key? key,
    required this.painter,
    required this.process,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final CameraController _cameraController = CameraController(
    cameras.first,
    ResolutionPreset.high,
    enableAudio: false,
  );

  @override
  void initState() {
    super.initState();
    _startImageStream();
  }

  Future _startImageStream() async {
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.startImageStream(_processCameraImage);
    });
  }

  @override
  void dispose() {
    _stopImageStream();
    super.dispose();
  }

  Future _stopImageStream() async {
    await _cameraController.stopImageStream();
    await _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (_cameraController.value.isInitialized == false) {
      return Container();
    }

    double scale = MediaQuery.of(context).size.aspectRatio *
        _cameraController.value.aspectRatio;

    if (scale < 1) {
      scale = 1 / scale;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_cameraController),
          ),
        ),
        if (widget.painter != null) widget.painter!,
      ],
    );
  }

  Future _processCameraImage(CameraImage image) async {
    final inputImage = InputImage.fromBytes(
      bytes: _bytes(image),
      inputImageData: _inputImageData(image),
    );
    widget.process(inputImage);
  }

  Uint8List _bytes(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  InputImageData _inputImageData(CameraImage image) {
    final imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final imageRotation =
        InputImageRotationValue.fromRawValue(cameras.first.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map(
      (plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    return InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
  }
}
