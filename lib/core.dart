import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:epicture/pages/profile.dart';
import 'package:epicture/const.dart';
import 'package:epicture/API/imgur.dart';

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
      Profile(wrapper: wrapper),
      Search(wrapper: wrapper)
      //here the list of possible body
    ];
    return Scaffold(
      body: Container(
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
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
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