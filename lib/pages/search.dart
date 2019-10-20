import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture/API/imgur.dart';
import 'package:epicture/pages/popupImg.dart';

class Search extends StatefulWidget {
  final Imgur wrapper;

  Search({Key key, @required this.wrapper}) : super(key: key);

  @override
  _Search createState() => _Search(wrapper: wrapper);
}

class _Search extends State<Search> {
  final Imgur wrapper;

  _Search({Key key, @required this.wrapper});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            left: 20,
            width: 350,
            child: SearchBar(),
          ),
          Positioned(
            top: 130,
            left: 5,
            width: 382,
            height: 545,
            child: Container(
              color: Colors.red,
              child: /*GridView.extent(
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.85,
                children: <Widget>[
                  Text('here your result'),
                  //here the search result
                ],
              ),*/Row(children: <Widget>[Text('here will be the result place')],)
            )
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {

  handleKeyPress(String search) {
    print(search);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xff3e3e3e),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
        child: TextField(
          onChanged: handleKeyPress,
          cursorColor: Colors.green,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            labelText: "Search",
            suffixIcon: Icon(Icons.search, color: Colors.white),
            hasFloatingPlaceholder: false,
          ),
        ),
      ),
    );
  }
}