import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:smart_focus_image/src/painters.dart';
import 'src/analyzer.dart';

class SmartFocusImage extends StatefulWidget {
  final File imageFile;
  final double width;
  final double height;
  final Widget? placeholder;
  final bool returnAllFaces;

  const SmartFocusImage({
    super.key,
    required this.imageFile,
    required this.width,
    required this.height,
    this.placeholder,
    this.returnAllFaces = false,
  });

  @override
  State<SmartFocusImage> createState() => _SmartFocusImageState();
}

class _SmartFocusImageState extends State<SmartFocusImage> {
  final SmartImageAnalyzer _analyzer = SmartImageAnalyzer();

  ui.Image? _decodedImage;
  Rect? _faceRect;
  List<Rect> _faceRects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  @override
  void didUpdateWidget(SmartFocusImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.returnAllFaces != widget.returnAllFaces) {
      setState(() {
        _isLoading = true;
        if (widget.returnAllFaces) {
          _faceRect = null;
        } else {
          _faceRects = [];
        }
      });
      _processImage();
    }
  }

  Future<void> _processImage() async {
    try {
      final data = await widget.imageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(data);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final uiImage = frameInfo.image;

      final inputImage = InputImage.fromFile(widget.imageFile);

      if (widget.returnAllFaces) {
        final detectedRects = await _analyzer.calculateAllFaceRects(inputImage);
        final List<Rect> finalRects = [];

        for (var detectedRect in detectedRects) {
          var finalRect = detectedRect.inflate(detectedRect.width * 0.2);
          final imageRect = Rect.fromLTWH(
            0,
            0,
            uiImage.width.toDouble(),
            uiImage.height.toDouble(),
          );
          finalRect = finalRect.intersect(imageRect);
          finalRects.add(finalRect);
        }

        if (mounted) {
          setState(() {
            _decodedImage = uiImage;
            _faceRects = finalRects;
            _isLoading = false;
          });
        }
      } else {
        Rect? detectedRect = await _analyzer.calculateFaceRect(inputImage);

        Rect finalRect;

        if (detectedRect != null) {
          finalRect = detectedRect.inflate(detectedRect.width * 0.2);

          final imageRect = Rect.fromLTWH(
            0,
            0,
            uiImage.width.toDouble(),
            uiImage.height.toDouble(),
          );
          finalRect = finalRect.intersect(imageRect);
        } else {
          finalRect = Rect.fromLTWH(
            0,
            0,
            uiImage.width.toDouble(),
            uiImage.height.toDouble(),
          );
        }

        if (mounted) {
          setState(() {
            _decodedImage = uiImage;
            _faceRect = finalRect;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _analyzer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _decodedImage == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: widget.placeholder ?? const CircularProgressIndicator(),
        ),
      );
    }

    if (widget.returnAllFaces) {
      if (_faceRects.isEmpty) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Center(
            child: widget.placeholder ?? const Text("No faces detected"),
          ),
        );
      }

      return SizedBox(
        width: widget.width,
        child: Column(
          children: _faceRects.map((faceRect) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: widget.height,
              child: ClipRect(
                child: CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: FaceCropperPainter(
                    image: _decodedImage!,
                    faceRect: faceRect,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      if (_faceRect == null) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Center(
            child: widget.placeholder ?? const Text("No faces detected"),
          ),
        );
      }

      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRect(
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            painter: FaceCropperPainter(
              image: _decodedImage!,
              faceRect: _faceRect!,
            ),
          ),
        ),
      );
    }
  }
}
