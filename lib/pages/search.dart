import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture/API/imgur.dart';
import 'package:epicture/pages/popupImg.dart';
import 'package:epicture/pages/profile.dart';


class Search extends StatefulWidget {
  final Imgur wrapper;

  Search({Key key, @required this.wrapper}) : super(key: key);

  @override
  _Search createState() => _Search(wrapper: wrapper);
}

class _Search extends State<Search> {
  final Imgur wrapper;
  List<Map<String, dynamic>> _listResult = new List<Map<String, dynamic>>();
  List<Widget> _listWidgetDisp = new List<Widget>();

  _Search({Key key, @required this.wrapper});

  String window = "day";
  String section = "hot";
  String sort = "viral";
  String _search = "";

  void clear() {
    _listResult.clear();
  }

  void addImg(Map<String, dynamic> img) {
    _listResult.add(img);
  }

  void rebuildStatsList() {
    setState(() {
      _listWidgetDisp = buildList(_listResult, context, wrapper);
    });
  }

  void update(String search) {
    _search = search;
    wrapper.searchGallery(
      search,
      window: window,
      //section: section,
      sort: sort,
    ).then((ImgurResponse res) {
    if (res.data != null) {
        this.clear();
        res.data.forEach((dynamic gallery) {
          if (gallery['images'] != null) {
            gallery['images'].forEach((dynamic img) {
              this.addImg(img);
            });
          } else if (gallery != null) {
              this.addImg(gallery);
          }
        });
        this.rebuildStatsList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_listResult.length == 0 && _search.length == 0) {
      wrapper.getGallery(
        window: window,
        section: section,
        sort: sort,
      ).then((ImgurResponse res) {
        if (res.data != null) {
          res.data.forEach((dynamic gallery) {
            if (gallery != null && gallery['images'] != null) {
              gallery['images'].forEach((dynamic img) {
                _listResult.add(img);
              });
            }
          });
        }
        this.rebuildStatsList();
      });
    } else if (_listResult.length == 0) {
      this.update(_search);
    }

    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            left: 20,
            width: 350,
            child: SearchBar(wrapper: wrapper, daddy: this),
          ),
          Positioned(
            top: 100,
            child: Container(
              width: 400,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DropdownButton<String>(
                    value: window,
                    icon: Icon(Icons.arrow_downward, color:  Colors.white,),
                    iconSize: 20,
                    elevation: 18,
                    style: TextStyle(
                      color: Colors.blue
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        this.clear();
                        window = newValue;
                      });
                    },
                    items: <String>['day', 'week', 'month', 'year', 'all']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  ),
                  DropdownButton<String>(
                    value: section,
                    icon: Icon(Icons.arrow_downward, color:  Colors.white,),
                    iconSize: 20,
                    elevation: 18,
                    style: TextStyle(
                      color: Colors.blue
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        this.clear();
                        section = newValue;
                      });
                    },
                    items: <String>['hot', 'top', 'user']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  ),
                  DropdownButton<String>(
                    value: sort,
                    icon: Icon(Icons.arrow_downward, color:  Colors.white,),
                    iconSize: 20,
                    elevation: 18,
                    style: TextStyle(
                      color: Colors.blue
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        this.clear();
                        sort = newValue;
                      });
                    },
                    items: <String>['viral', 'top', 'time', 'rising']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                  ),
                ],
              )
            ),
          ),
          Positioned(
            top: 160,
            left: 5,
            width: 382,
            height: 545,
            child: Container(
              color: Colors.transparent,
              child: GridView.extent(
                shrinkWrap : true,
                maxCrossAxisExtent: 150,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.85,
                children: _listWidgetDisp,
              ),
            )
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {

  final Imgur wrapper;
  final _Search daddy;

  SearchBar({Key key, @required this.wrapper, @required this.daddy}): super(key: key);

  handleKeyPress(String search) {
    print(search);
    daddy.update(search);
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
          cursorColor: Colors.white,
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