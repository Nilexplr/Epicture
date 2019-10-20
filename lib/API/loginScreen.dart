import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:epicture/core.dart';
import 'package:epicture/API/imgur.dart';
import 'package:epicture/logReadWrite.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.wrapper, {Key key, this.title}) : super(key: key);

  final String title;
  final Imgur wrapper;

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

  static bool end = false;

  // final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    print("hola");
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
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print(url);
            var pos = url.indexOf('refresh_token=');
            LogRW log = new LogRW();
            if (pos != -1 && !end) {
              end = true;
              String token = url.substring(pos).replaceAll('refresh_token=', '');
              pos = token.indexOf('&');
              token = token.substring(0, pos);
              print(token);
              log.writeData(token);
              cookieManager.clearCookies();
              _controller.future.then((WebViewController ctrl) {
                ctrl.clearCache();
              });
              wrapper.authentificateClient(token).whenComplete(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(wrapper: wrapper),
                  )
                );
              });
            }
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