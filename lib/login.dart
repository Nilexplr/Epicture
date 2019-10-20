import 'dart:async';

import 'package:epicture/logReadWrite.dart';
import 'package:flutter/material.dart';
import 'package:epicture/const.dart';
import 'package:epicture/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:epicture/API/imgur.dart';

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
  Imgur wrapper =
      Imgur('ca42024bf4b47ff', '3688f84bd14578f16f3848bdd8fef68385df0a3e');
  bool isLoading = true;
  String token;
  bool isLog = false;
  LogRW log = new LogRW();
  bool stateIsEnd = false;
  bool stateIsEnd2 = false;

  void checkLogin() {
    log.readData().then((String tok) {
      setState(() {
        token = tok;
      });
    });
  }

  void checkGoodLogin() {
    setState(() {
      if (token != null) {
        wrapper.authentificateClient(token).then((bool co) {
            setState(() {
              isLog = co;
              isLoading = false;
            });
        });
      } else {
          setState(() {
            isLog = false;
            isLoading = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!stateIsEnd) {
      stateIsEnd = true;
      checkLogin();
      return Container(child: Center(child: CircularProgressIndicator()));
    }

    if (!stateIsEnd2) {
      stateIsEnd2 = true;
      checkGoodLogin();
    }

    if (!isLoading) {
      scheduleMicrotask(() {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) => LoginWidet(isLoading: false, isLog: isLog, wrapper: wrapper)
        ));
      });
    }

    return Container(child: Center(child: CircularProgressIndicator()));
  }
}

class LoginWidet extends StatelessWidget {
  final bool isLoading;
  final bool isLog;
  final Imgur wrapper;

  LoginWidet(
      {Key key,
      @required this.isLoading,
      @required this.isLog,
      @required this.wrapper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color1 = const Color(0xFF2651D2);
    const color2 = const Color(0xFF2FA7FB);

    if (isLoading) {
      return CircularProgressIndicator();
    }

    if (isLog) {
      scheduleMicrotask(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(wrapper: wrapper))
        ).then((dynamic obj) {
          SystemNavigator.pop();
        });
      });
    }

    return Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                  0.1,
                  0.9
                ],
                    colors: [
                  color1,
                  color2,
                ])),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Positioned(
                  top: 160,
                  child: Image.asset('assets/Epicturelogo.png')
                ),
                Positioned(
                  bottom: 50,
                  child: wrapper.getButton(context)
                ),
              ],
            )));
  }
}
