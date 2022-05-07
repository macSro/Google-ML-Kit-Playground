import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../coordinates_translator.dart';

class TextRecognizerPainter extends CustomPainter {
  final RecognizedText recognizedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  TextRecognizerPainter({
    required this.recognizedText,
    required this.absoluteImageSize,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.white;

    final Paint background = Paint()..color = Colors.black.withOpacity(0.3);

    for (final textBlock in recognizedText.blocks) {
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

      builder.addText(textBlock.text);

      builder.pop();

      final left = translateX(
        x: textBlock.boundingBox.left,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteImageSize,
      );
      final top = translateY(
        y: textBlock.boundingBox.top,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteImageSize,
      );
      final right = translateX(
        x: textBlock.boundingBox.right,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteImageSize,
      );
      final bottom = translateY(
        y: textBlock.boundingBox.bottom,
        rotation: rotation,
        size: size,
        absoluteSize: absoluteImageSize,
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
  bool shouldRepaint(TextRecognizerPainter oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }
}
