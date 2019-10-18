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

/*
      Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/bg1.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 60,
                  left: 30,
                  child: Container(
                    height: logo ? 300 : 0,
                    width: logo ? 300 : 0,
                    //decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.red)),
                    child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo_fond_blanc.png'),
                      ),
                    ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.all(25),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: TextField(
                          onTap: () {
                            setState(() {
                            //  logo = !logo;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          filled: true,
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: TextField(
                          onTap: () {
                            setState(() {
                            //  logo = !logo;
                            });
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                            decoration: InputDecoration(
                          labelText: "Password",
                          fillColor: Colors.white,
                          filled: true,
                        )),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            color: themeColor,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            textColor: primaryColor,
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            color: Colors.white,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            textColor: Colors.grey[600],
                          )),
                      Container(
                        child: RaisedButton(
                          color: Colors.red,
                          onPressed: () {},
                          child: Text('hello',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),GoogleSignInButton(
                          onPressed: handleSignIn,
                        ),
                      ),
                    ],
                  ),
                ),
                // Loading
                Positioned(
                  child: isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          color: Colors.white.withOpacity(0.8),
                        )
                      : Container(),
                ),
              ],
            ))*/