import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../coordinates_translator.dart';

class ObjectDetectorPainter extends CustomPainter {
  final List<DetectedObject> detectedObjects;
  final Size absoluteSize;
  final InputImageRotation rotation;

  ObjectDetectorPainter({
    required this.detectedObjects,
    required this.absoluteSize,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.white;

    final Paint background = Paint()..color = Colors.black.withOpacity(0.3);

    for (final detectedObject in detectedObjects) {
      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 14,
          textDirection: TextDirection.ltr,
        ),
      );

      builder.pushStyle(
        ui.TextStyle(
          color: Colors.white,
          background: background,
        ),
      );

      for (final Label label in detectedObject.labels) {
        builder.addText('${label.text} ${label.confidence}\n');
      }

      builder.pop();

      final left = translateX(
        x: detectedObject.boundingBox.left,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteSize,
      );
      final top = translateY(
        y: detectedObject.boundingBox.top,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteSize,
      );
      final right = translateX(
        x: detectedObject.boundingBox.right,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteSize,
      );
      final bottom = translateY(
        y: detectedObject.boundingBox.bottom,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteSize,
      );

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      canvas.drawParagraph(
        builder.build()
          ..layout(ui.ParagraphConstraints(
            width: right - left,
          )),
        Offset(left, top),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ObjectDetectorPainter oldDelegate) {
    return oldDelegate.detectedObjects != detectedObjects;
  }
}
