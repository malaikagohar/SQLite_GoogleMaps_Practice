import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);  

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  // Future<void> _takePicture() async {
  //   final picker = ImagePicker();
  //   final imageFile =
  //       await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
  // }

  // Future<void> _openGallery() async {
  //   final picker = ImagePicker();
  //   final imageFile =
  //       await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
  // }

  Future<void> _selectImage(String option) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
        source: option == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 600);
    if(imageFile == null){return;}
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final image_File = File(imageFile.path);
    final fileName = path.basename(imageFile.path);
    final savedImage = await image_File.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
    // print('appDir: $appDir');
    // print('imageFile $imageFile');
    // print('image_File: $image_File');
    // print('fileName: $fileName');
    // print('savedImage: $savedImage');
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
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Column(
          children: [
            TextButton.icon(
              onPressed: () => _selectImage('camera'),
              icon: Icon(Icons.camera_alt_outlined),
              label: Text('Take Picture'),
              // style: ElevatedButton.styleFrom(
              //     textStyle: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            TextButton.icon(
              onPressed: () => _selectImage('gallery'),
              icon: Icon(Icons.photo_library_outlined),
              label: Text('Open Gallery'),
              // style: ElevatedButton.styleFrom(
              //     textStyle: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        ))
      ],
    );
  }
}
