import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FaceCropperPainter extends CustomPainter {
  final ui.Image image;
  final Rect faceRect;

  FaceCropperPainter({required this.image, required this.faceRect});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect src = faceRect;

    final Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
