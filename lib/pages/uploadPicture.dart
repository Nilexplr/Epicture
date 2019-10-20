import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture/imgur.dart';

class UploadPicture extends StatefulWidget {

  final List<File> files;
  final Imgur wrapper;

  UploadPicture({Key key, @required this.files, @required this.wrapper}) : super(key: key);

  @override
  _UploadPicture createState() => _UploadPicture(files: files, wrapper: wrapper);
}

class _UploadPicture extends State<UploadPicture> {
  
  final List<File> files;
  final Imgur wrapper;

  _UploadPicture({Key key, @required this.files, @required this.wrapper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload pictures"),
      ),
      body: Container(
        //height: MediaQueryData,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              Color(0xff212121),
              Color(0xff656565),
            ]
          )
        ),
        constraints: BoxConstraints.expand(),
        child: ListView(
          shrinkWrap : true,
          children: <Widget> [
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (String title) => print(title),
                cursorColor: Colors.green,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  focusColor: Colors.white,
                  labelText: "Name",
                  hasFloatingPlaceholder: false,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                    )
                  ),
                  child: GridView.extent(
                    shrinkWrap : true,
                    childAspectRatio: 0.85,
                    maxCrossAxisExtent: 150,
                    padding: const EdgeInsets.all(4),
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: buildFileList(files),
                  )
                ), 
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: RaisedButton(
                color: Colors.green[600],
                child: Text('Upload'),
                textColor: Colors.white,
                onPressed: () {
                  print("hello batard !");
                  files.forEach((File file) {
                    
                  });
                },
              )
            )
          ]
        )
      )
    );
  }
}

List<Widget> buildFileList(List<File> list) {
  List<Widget> widList = new List<Widget>();
  
  if (list == null) {
    widList.add(Center(child: Text('Frero l\'appli a bugguer faut que tu recommence, soso :/')));
    return widList;
  }
  list.forEach((File file) {
    widList.add(
      // Text(link)
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Color(0xffffffff),
              Color(0xffbbbbbb),
            ]
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 40),
          child: Image(
            fit: BoxFit.cover,
            image: FileImage(file)
          )
        )
      )
    );
  });
  return widList;
}