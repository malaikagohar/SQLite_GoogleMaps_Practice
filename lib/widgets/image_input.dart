import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput(this.onSelectImage, {Key? key}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _selectImage(String option) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
        source: option == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    // ignore: non_constant_identifier_names
    final image_File = File(imageFile.path);
    final fileName = path.basename(imageFile.path);
    final savedImage = await image_File.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Column(
          children: [
            TextButton.icon(
              onPressed: () => _selectImage('camera'),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Take Picture'),
            ),
            TextButton.icon(
              onPressed: () => _selectImage('gallery'),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Open Gallery'),
            ),
          ],
        ))
      ],
    );
  }
}
