import 'dart:async';

import 'package:flutter/material.dart';
import 'package:epicture/const.dart';
import 'package:epicture/core.dart';
import 'package:epicture/imgur.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epicture',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      home: LoginPage(title: 'Epicture'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  Imgur wrapper = Imgur('ca42024bf4b47ff', '3688f84bd14578f16f3848bdd8fef68385df0a3e');

  @override
  Widget build(BuildContext context) {
    const color1 = const Color(0xFF2651D2);
    const color2 = const Color(0xFF2FA7FB);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              color1,
              color2,
            ]
          )
        ),
        child: Center(
          child: wrapper.getButton(context),
        )
      )
    );
  }
}