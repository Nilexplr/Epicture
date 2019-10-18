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
  List<Widget> listFav = [Text('loading...')];

  _Profile({Key key, @required this.wrapper});

  bool isLoading = true;
  bool doNotSkip = true;

  void _buildImageList() {
    img = wrapper.accountImage();
    List<String> list = new List();
    img.then((ImgurResponse obj) {
      dynamic tmp = obj.data;
      tmp.forEach((dynamic value) {
        list.add(value['link']);
      });
      setState(() {
        listImage = buildList(list);
        isLoading = false;
        doNotSkip = false;
      });
    });
  }
  void _buildFavList() {
    img = wrapper.accountGalleryFavorites(0, true);
    List<String> list = new List();
    img.then((ImgurResponse obj) {
      dynamic tmp = obj.data;
      tmp.forEach((dynamic gallery) {
        gallery['images'].forEach((dynamic value) {
          list.add(value['link']);
        });
      });
      setState(() {
        listFav = buildList(list);
        doNotSkip = false;
      });
    });
  }

  var img;

  @override
  Widget build(BuildContext context) {
    if (doNotSkip) {
      _buildImageList();
      _buildFavList();
    }

    if (isLoading) {
      return Center(
        child: Text('Loading...'),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.image)),
                Tab(icon: Icon(Icons.star)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GridView.extent(
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: listImage,
              ),
              GridView.extent(
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: listFav,
              ),
            ],
          ),
        ),
      );
    }
  }
}

List<Widget> buildList(List<String> list) {
  List<Widget> widList = new List<Widget>();
  
  if (list == null) {
    widList.add(Text('Oups.. Vous n\'avez pas encore de contenus'));
    return widList;
  }
  list.forEach((dynamic link) {
    try {
    widList.add(
      // Text(link)
      CachedNetworkImage(
        imageUrl: link,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.fill,
      )
    );
    } catch(e) {
      try {
        link.forEach((String lk) {
          widList.add(
            // Text(link)
            CachedNetworkImage(
              imageUrl: lk,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fill,
            )
          );
        });
      } catch(e) {
        print(e);
      }
    }
  });
  return widList;
}