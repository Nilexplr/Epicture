import 'package:epicture/core.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImgurResponse {
  var data;
  bool success;
  int status;

  ImgurResponse(Map<String, dynamic> json) {
    data = json["data"];
    success = json["success"];
    status = json["status"];
  }
}

class User {
  String accessToken;
  var expiresIn;
  String tokenType;
  String scope;
  String refreshToken;
  var accountId;
  String accountUsername;

  User(Map<String, dynamic> info) {
    accessToken = info["access_token"];
    expiresIn = info["expires_in"];
    tokenType = info["token_type"];
    scope = info["scope"];
    refreshToken = info["refresh_token"];
    accountId = info["account_id"];
    accountUsername = info["account_username"];
  }
}


class Imgur {
  String _clientId;
  String _clientSecret;
  User _myUser;

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
    http.Response request = await http.post(Uri.parse("https://api.imgur.com/oauth2/token"), body: body);
    _myUser = new User(json.decode(request.body));
  }

  /*********************
  ** ACCOUNT REQUEST **
  ********************/

  Future<ImgurResponse> accountBase() async {
    http.Response source = await http.get(Uri.parse(
      'https://api.imgur.com/3/account/${_myUser.accountUsername}'), 
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountBlocks() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/block'),
      headers: {'Authorization': "Bearer ${_myUser.accessToken}", 'Accept' : "application/vnd.api+json"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountBlocksCreate() async {
    http.Response source = await http.post(Uri.parse('https://api.imgur.com/account/v1/${_myUser.accountUsername}/block'),
      headers: {'Authorization': "Bearer ${_myUser.accessToken}", 'Accept' : "application/vnd.api+json"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountSetting() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/settings'),
      headers: {'Authorization': "Bearer ${_myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }


  Future<ImgurResponse> accountImage() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/images'),
      headers: {'Authorization': "Bearer ${_myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountAvatar() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${_myUser.accountUsername}/avatar'),
      headers: {'Authorization': "Bearer ${_myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountGalleryFavorites(int page, bool sort) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${_myUser.accountUsername}/gallery_favorites/$page/$sort'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountFavorites(int page, bool sort) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${_myUser.accountUsername}/favorites'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }
  /*********************
  ** COMMENT REQUEST ***
  *********************/

  // Future<ImgurResponse> getComment(int commentID) async {
  //   http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/$commentID/gallery_favorites/$page/$sort'), headers: {'Authorization': "Client-ID $_clientId"});
  //   return ImgurResponse(json.decode(source.body));
  // }

  // Future<ImgurResponse> createComment(String comment, int id, String key) async {
  //   var body = {
  //     "refresh_token": refreshToken,
  //     "client_id": _clientId,
  //     "client_secret": _clientSecret,
  //     "grant_type": "refresh_token"
  //   };
  //   http.Response source = await http.post(Uri.parse('https://api.imgur.com/3/comment'), headers: {'Authorization': "Bearer ${_myUser.accessToken}"});
  //   return ImgurResponse(json.decode(source.body));
  // }

  /*********************
  *** ALBUM REQUEST ****
  *********************/
  
  Future<ImgurResponse> getAlbum(String albumHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/album/$albumHash'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> albumImages(String albumHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/album/$albumHash/images'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> albumImage(String albumHash, String imageHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/album/$albumHash/image/$imageHash'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  /*********************
  ** GALLERY REQUEST ***
  *********************/

  Future<ImgurResponse> getGallery(String section, int window, int page, bool sort, bool showViral, bool mature, bool albumPreviews) async {
    http.Response source = await http.get(Uri.parse(
      'https://api.imgur.com/3/gallery/$section/$sort/$window/$page?showViral=$showViral&mature=$mature&album_previews=$albumPreviews'),
      headers: {'Authorization': "Client-ID $_clientId"});
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> getGalleryAlbum(String galleryHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/gallery/album/$galleryHash'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  /*********************
  *** IMAGE REQUEST ****
  *********************/
  
  Future<ImgurResponse> getImage(String imageHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/image/$imageHash'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }
}

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
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print(url);
            var pos = url.indexOf('refresh_token=');
            if (pos != -1 && !end) {
              end = true;
              String token = url.substring(pos).replaceAll('refresh_token=', '');
              pos = token.indexOf('&');
              token = token.substring(0, pos);
              print(token);
              wrapper.authentificateClient(token).whenComplete(() {
                print("test !");
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
