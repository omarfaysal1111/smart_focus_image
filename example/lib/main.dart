import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_focus_image/smart_focus_image.dart';

void main() {
  runApp(const MaterialApp(home: SmartCropTestApp()));
}

class SmartCropTestApp extends StatefulWidget {
  const SmartCropTestApp({super.key});

  @override
  State<SmartCropTestApp> createState() => _SmartCropTestAppState();
}

class _SmartCropTestAppState extends State<SmartCropTestApp> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _showAllFaces = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Face Cropper Demo ')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Select an image with a face"),
            ),

            if (_selectedImage != null) ...[
              const SizedBox(height: 30),

              const Text(
                "Original",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Show all faces: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _showAllFaces,
                    onChanged: (value) {
                      setState(() {
                        _showAllFaces = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                _showAllFaces
                    ? " Smart Focus Crop (All Faces) "
                    : " Smart Focus Crop (Main Face) ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: SmartFocusImage(
                  imageFile: _selectedImage!,
                  width: double.infinity,
                  height: 200,
                  returnAllFaces: _showAllFaces,
                  placeholder: const Center(child: Text("Analyzing...")),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Notice the difference: The red box crops the image from the center and may cut off the head.\nThe green box analyzes and automatically focuses on the face(s).\nToggle 'Show all faces' to see all detected faces or just the main one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
