import 'dart:io';

import 'package:flutter/material.dart';
import 'package:epicture/imgur.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatelessWidget {

  AddPicture({Key key, @required this.wrapper}): super(key: key);

  final Imgur wrapper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Add image"),
      ),
      body: Container(
        color: Colors.transparent,
        child: ImagePickerPage(),
      ),
    );
  }
}

class ImagePickerPage extends StatefulWidget {

  @override
  _ImagePickerPage createState() => _ImagePickerPage();
}

class _ImagePickerPage extends State<ImagePickerPage> {
  List<File> _imageFile = null;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera, color: Colors.white),
              onPressed: () async => await _pickImageFromCamera(),
              tooltip: 'Shoot picture',
            ),
            IconButton(
              icon: Icon(Icons.photo, color: Colors.white),
              onPressed: () async => await _pickImageFromGallery(),
              tooltip: 'Pick from gallery',
            )
          ],
        ),
        buildImageListView(this._imageFile),
        FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            print("hello world");
          },
          backgroundColor: Colors.green[600],
        )
      ],
    );
  }

  Widget buildImageListView(List<File> list) {
    List<Widget> widlList = new List<Widget>();

    if (list == null) {
      return Placeholder(color: Colors.white);
    }
    list.forEach((File file) {
      widlList.add(Image.file(file));
    });
    return Column(
      children: widlList,
    );
  }

  Future<Null> _pickImageFromGallery() async {
    final File imageFile = 
      await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (this._imageFile == null) {
        this._imageFile = new List<File>();
      }
      this._imageFile.add(imageFile);
    });
  }

    Future<Null> _pickImageFromCamera() async {
    final File imageFile = 
      await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (this._imageFile == null) {
        this._imageFile = new List<File>();
      }
      this._imageFile.add(imageFile);
    });
  }
}