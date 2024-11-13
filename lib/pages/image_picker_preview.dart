import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class ImageInTextField extends StatefulWidget {
  @override
  _ImageInTextFieldState createState() => _ImageInTextFieldState();
}

class _ImageInTextFieldState extends State<ImageInTextField> {
  Uint8List? _imageBytes;

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageBytes = await imageFile.readAsBytes();

      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Inside TextField")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                const TextField(
                  // textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Enter text here',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    border: OutlineInputBorder(),
                  ),
                  minLines: 1,
                  maxLines: 5,
                ),
                if (_imageBytes != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Image.memory(
                      _imageBytes!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Image"),
            ),
          ],
        ),
      ),
    );
  }
}
