# Smart Focus Image

A Flutter package that automatically crops images to focus on detected faces using Google ML Kit. Perfect for profile pictures, avatars, and any scenario where you need to ensure faces are properly centered and visible in cropped images.

## Features

- 🎯 **Automatic Face Detection**: Uses Google ML Kit to detect faces in images
- 🖼️ **Smart Cropping**: Automatically crops images to focus on detected faces instead of center-cropping
- 👥 **Multiple Faces Support**: Option to detect and display all faces or just the main (largest) face
- ⚡ **Fast Performance**: Optimized for quick face detection and image processing
- 🎨 **Customizable**: Supports custom placeholders and sizing

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_focus_image: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Platform Setup

#### Android

Add the following to your `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

#### iOS

Add the following to your `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

Then run:

```bash
cd ios && pod install
```

## Usage

### Basic Usage (Single Face)

```dart
import 'package:smart_focus_image/smart_focus_image.dart';
import 'dart:io';

SmartFocusImage(
  imageFile: File('path/to/image.jpg'),
  width: 200,
  height: 200,
  placeholder: CircularProgressIndicator(),
)
```

### Multiple Faces

To detect and display all faces in an image:

```dart
SmartFocusImage(
  imageFile: File('path/to/image.jpg'),
  width: 200,
  height: 200,
  returnAllFaces: true, // Set to true to show all detected faces
  placeholder: CircularProgressIndicator(),
)
```

### Complete Example

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_focus_image/smart_focus_image.dart';

class MyWidget extends StatelessWidget {
  final File imageFile;

  const MyWidget({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show only the main face
        SmartFocusImage(
          imageFile: imageFile,
          width: 200,
          height: 200,
          placeholder: const Center(child: Text("Analyzing...")),
        ),
        
        const SizedBox(height: 20),
        
        // Show all detected faces
        SmartFocusImage(
          imageFile: imageFile,
          width: 200,
          height: 200,
          returnAllFaces: true,
          placeholder: const Center(child: Text("Analyzing...")),
        ),
      ],
    );
  }
}
```

## Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `imageFile` | `File` | Yes | - | The image file to process |
| `width` | `double` | Yes | - | Width of the cropped image widget |
| `height` | `double` | Yes | - | Height of the cropped image widget |
| `placeholder` | `Widget?` | No | `CircularProgressIndicator()` | Widget to show while processing |
| `returnAllFaces` | `bool` | No | `false` | If `true`, returns all detected faces; if `false`, returns only the main (largest) face |

## How It Works

1. The package uses Google ML Kit's face detection to identify faces in the image
2. Faces are sorted by size (largest first) to determine the "main" face
3. Each detected face is cropped with a 20% padding around the bounding box
4. The cropped region is then displayed at the specified width and height

## Example App

Check out the `example` folder for a complete working example that demonstrates:
- Single face detection
- Multiple faces detection
- Toggle between modes
- Comparison with standard center cropping

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Issues

If you encounter any issues or have feature requests, please file them on the [GitHub issue tracker](https://github.com/yourusername/smart_focus_image/issues).
