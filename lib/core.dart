import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:epicture/pages/profile.dart';
import 'package:epicture/const.dart';
import 'package:epicture/imgur.dart';

// void main() => runApp(MyApp());

class MainScreen extends StatefulWidget {
  final Imgur wrapper;

  MainScreen({Key key, @required this.wrapper}) : super(key: key);

  @override
  State createState() => MainScreenState(wrapper: wrapper);
}

class MainScreenState extends State<MainScreen> {
  MainScreenState({Key key, @required this.wrapper});

  final Imgur wrapper;
  
  int _selectedIndex = 0;

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Profile(wrapper: wrapper)
      //here the list of possible body
    ];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF299DE6),
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('profile'),
            backgroundColor: Color(0xFF299DE6),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('search'),
            backgroundColor: Color(0xFF299DE6),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_photo_alternate),
            title: Text('add'),
            backgroundColor: Color(0xFF299DE6),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('settings'),
            backgroundColor: Color(0xFF299DE6),
          ),
        ],
        selectedItemColor: Colors.white,
        onTap: onItemTap,
      ),
    );
  }
}