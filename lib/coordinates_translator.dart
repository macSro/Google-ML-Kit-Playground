import 'dart:ui';

import 'package:google_mlkit_commons/google_mlkit_commons.dart';

double translateX({
  required double x,
  required InputImageRotation rotation,
  required Size size,
  required Size absoluteSize,
}) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x * size.width / absoluteSize.height;
    case InputImageRotation.rotation270deg:
      return size.width - x * size.width / absoluteSize.height;
    default:
      return x * size.width / absoluteSize.width;
  }
}

double translateY({
  required double y,
  required InputImageRotation rotation,
  required Size size,
  required Size absoluteSize,
}) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y * size.height / absoluteSize.width;
    default:
      return y * size.height / absoluteSize.height;
  }
}
