import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:epicture/imgur.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  final Imgur wrapper;

  Profile({Key key, @required this.wrapper}) : super(key: key);

  @override
  _Profile createState() => _Profile(wrapper: wrapper);
}

class _Profile extends State<Profile> {
  final Imgur wrapper;
  List<Widget> listImage = [Text('loading...')];

  _Profile({Key key, @required this.wrapper});

  @override
  Widget build(BuildContext context) {
    var img = wrapper.accountImage();
    List<String> list = new List();
    setState(() {
      img.then((Map<String, dynamic> map) {
        map.forEach((String str, dynamic info) {
          if (str == "data") {
            List<dynamic> tmp = info;
            tmp.forEach((dynamic value) {
              list.add(value['link']);
            });
          }
        });
        listImage = buildList(list);
      });
    });

    return Center(
      child: Stack(
        children: listImage,
      ),
    );
  }
}

List<Widget> buildList(List<String> list) {
  List<Widget> widList = new List<Widget>();
  
  if (list == null) {
    widList.add(Text('Oups.. Vous n\'avez pas encore de contenus'));
    return widList;
  }
  print(list);
  list.forEach((String link) {
    print(link);
    widList.add(
      // Text(link)
      CachedNetworkImage(
        imageUrl: link,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      )
    );
  });
  return widList;
}