import 'dart:ui';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class SmartImageAnalyzer {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableClassification: false,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  Future<Rect?> calculateFaceRect(InputImage inputImage) async {
    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) return null;

      final sortedFaces = _sortFacesBySize(faces);
      return sortedFaces.first.boundingBox;
    } catch (e) {
      print("Error inside SmartImageAnalyzer: $e");
      return null;
    }
  }

  Future<List<Rect>> calculateAllFaceRects(InputImage inputImage) async {
    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) return [];

      final sortedFaces = _sortFacesBySize(faces);
      return sortedFaces.map((face) => face.boundingBox).toList();
    } catch (e) {
      print("Error inside SmartImageAnalyzer: $e");
      return [];
    }
  }

  List<Face> _sortFacesBySize(List<Face> faces) {
    final sortedFaces = List<Face>.from(faces);
    if (sortedFaces.length > 1) {
      sortedFaces.sort((a, b) {
        double areaA = a.boundingBox.width * a.boundingBox.height;
        double areaB = b.boundingBox.width * b.boundingBox.height;
        return areaB.compareTo(areaA);
      });
    }
    return sortedFaces;
  }

  void dispose() {
    _faceDetector.close();
  }
}

