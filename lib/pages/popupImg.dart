import 'package:flutter/material.dart';
import 'package:epicture/API/imgur.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PopupImg extends StatefulWidget {
  final Map<String, dynamic> image;
  final Imgur wrapper;

  PopupImg({Key key, @required this.image, @required this.wrapper}) : super(key: key);

  @override
  _PopupImg createState() => _PopupImg(image: image, wrapper: wrapper);
}

class _PopupImg extends State<PopupImg> {
  final Map<String, dynamic> image;
  final Imgur wrapper;

  _PopupImg({Key key, @required this.image, @required this.wrapper});

  @override
  Widget build(BuildContext context) {
    String title = '';
    if (image['title'] != null) {
      title = image['title'];
    }
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Color(0xffffffff),
              Color(0xffaaaaaa),
            ]
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 250,
                width: 250,
                child: image['link'] != null ? CachedNetworkImage(
                  width: 250,
                  imageUrl: image['link'],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ) : Text('An error occured.')
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.thumb_up, color: Colors.grey[500]),
                        Text(title),
                        IconButton(
                          icon: image['favorite'] == true ? Icon(Icons.star, color: Colors.yellow[600]) : Icon(Icons.star_border, color: Colors.grey[600]),
                          onPressed: () {
                            setState(() {
                              wrapper.favorite(image['id']);
                              image['favorite'] = image['favorite'] == null ? true : !image['favorite'];                           
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}