import 'dart:async';

import 'package:flutter/material.dart';
import 'package:epicture/const.dart';
import 'package:epicture/core.dart';
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
          child: Container(
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Ink.image(
                image: AssetImage('boutonimgur.png'),
                fit: BoxFit.fill,
                child: InkWell(
                  onTap: () {
                    print("click");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(title: "Epicture")
                      )
                    );
                  },
                ),
              ),
            )
          )
        )
      )
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // final GoogleSignIn googleSignIn = GoogleSignIn(
  //   scopes: [
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  bool logo = true;

  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    // isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainScreen(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    // GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // FirebaseUser firebaseUser =
    //     await firebaseAuth.signInWithCredential(credential);

    /*if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentUserId: firebaseUser.uid,
                )),
      );
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      logo = true;
      if (MediaQuery.of(context).viewInsets.bottom != 0) {
        logo = false;
      }
    });
    return Scaffold(
        body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://api.imgur.com/oauth2/authorize?client_id=ca42024bf4b47ff&response_type=token',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            //TODO: parse the response here
          },
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
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