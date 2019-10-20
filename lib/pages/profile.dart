import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture/API/imgur.dart';
import 'package:epicture/pages/popupImg.dart';

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

  void _buildImageList(BuildContext context) {
    img = wrapper.accountImage();
    List<Map<String, dynamic>> list = new List();
    img.then((ImgurResponse obj) {
      dynamic tmp = obj.data;
      tmp.forEach((dynamic value) {
        list.add(value);
      });
      setState(() {
        listImage = buildList(list, context);
        isLoading = false;
        doNotSkip = false;
      });
    });
  }

  void _buildFavList(BuildContext context) {
    img = wrapper.accountGalleryFavorites();
    List<Map<String, dynamic>> list = new List();
    img.then((ImgurResponse obj) {
      dynamic tmp = obj.data;
      tmp.forEach((dynamic gallery) {
        if (gallery != null) {
          if (gallery['images'] != null) {
            gallery['images'].forEach((dynamic value) {
              list.add(value);
            });
          } else {
            list.add(gallery);
          }
        }
      });
      setState(() {
        listFav = buildList(list, context);
        doNotSkip = false;
      });
    });
  }

  var img;

  @override
  Widget build(BuildContext context) {
    if (doNotSkip) {
      _buildImageList(context);
      _buildFavList(context);
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
            automaticallyImplyLeading: false,
            title: Image.asset('assets/Epicturelogo.png'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.image)),
                Tab(icon: Icon(Icons.star)),
              ],
            ),
          ),
          backgroundColor: Color(0x00000000),
          body: TabBarView(
            children: [
              GridView.extent(
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: listImage,
                childAspectRatio: 0.85,
              ),
              GridView.extent(
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: listFav,
                childAspectRatio: 0.85,
              ),
            ],
          ),
        ),
      );
    }
  }
}

List<Widget> buildList(List<Map<String, dynamic>> list, BuildContext context) {
  List<Widget> widList = new List<Widget>();
  
  if (list == null) {
    widList.add(Center(child: Text('Oups.. Vous n\'avez pas encore de contenus')));
    return widList;
  }
  list.forEach((Map<String, dynamic> info) {
    String link = info['link'];
    if (link != null) {
      if (link.indexOf('.png') != -1 || link.indexOf('.jpg') != -1 || link.indexOf('.gif') != -1) {
        widList.add(
          // Text(link)
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {return PopupImg(image: info);},
              );
            },
            child: Container(
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
                child: CachedNetworkImage(
                  imageUrl: link,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )
              )
            )
          )
        );
      }
    }
  });
  return widList;
}