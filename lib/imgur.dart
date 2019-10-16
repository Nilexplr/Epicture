import 'package:epicture/core.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:oauth2/oauth2.dart' as oauth2;

//id ca42024bf4b47ff
//secret 3688f84bd14578f16f3848bdd8fef68385df0a3e
// refresh token d107b4fa46bf7a727872ba5f3b9f5a76e26d82a3
class Imgur {
  String _clientId;
  String _clientSecret;
  static HttpClient client = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  Imgur(this._clientId, this._clientSecret);

  Widget getButton(BuildContext context) {

    void LogIn() {
      print("click");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(this, title: "Epicture")
          )
        );
    }

    return InkWell(
      splashColor: Colors.green[400].withAlpha(50),
      onTap: LogIn,
      child: Container(
        height: 200,
        width: 300,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/boutonimgur.png"),
                fit: BoxFit.none,
              )
            ),
          ),
        ),
      ),
    );
  }

  authentificateClient(String refreshToken) async {
    var body = {
      "refresh_token": refreshToken,
      "client_id": _clientId,
      "client_secret": _clientSecret,
      "grant_type": "refresh_token"
    };
    http.Response request = await http
        .post(Uri.parse("https://api.imgur.com/oauth2/token"), body: body);
    // request.add(utf8.encode(json.encode(body)));
    // HttpClientResponse response = await request.close();
    print("bhbh");
    String toto = request.body;
    print(toto);
    client.close();
    return 0;
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen(this.wrapper, {Key key, this.title}) : super(key: key);

  final String title;
  Imgur wrapper;

  @override
  LoginScreenState createState() => LoginScreenState(wrapper);
}

class LoginScreenState extends State<LoginScreen> {

  LoginScreenState(this.wrapper);

  Imgur wrapper;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool logo = true;

  @override
  void initState() {
    super.initState();
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
          initialUrl:
              'https://api.imgur.com/oauth2/authorize?client_id=ca42024bf4b47ff&response_type=token',
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
            var pos = url.indexOf('refresh_token=');
            String token = url.substring(pos).replaceAll('refresh_token=', '');
            pos = token.indexOf('&');
            token = token.substring(0, pos);
            wrapper.authentificateClient(token);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(currentUserId: 'id'),
              )
            );
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
