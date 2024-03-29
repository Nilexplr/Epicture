import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:epicture/API/loginScreen.dart';
import 'dart:io';
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
  User myUser;

  Imgur(this._clientId, this._clientSecret);

  String transformFileImage(File img) {
    return base64Encode(img.readAsBytesSync());
  }
  Widget getButton(BuildContext context) {


    void LogIn() {
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

  Future<bool> authentificateClient(String refreshToken) async {
    var body = {
      "refresh_token": refreshToken,
      "client_id": _clientId,
      "client_secret": _clientSecret,
      "grant_type": "refresh_token"
    };
    http.Response request = await http.post(Uri.parse("https://api.imgur.com/oauth2/token"), body: body);
    myUser = new User(json.decode(request.body));
    ImgurResponse response = ImgurResponse(json.decode(request.body));
    return response.success == null ? true : false;
  }

  /*********************
  ** ACCOUNT REQUEST **
  ********************/

  Future<ImgurResponse> accountBase() async {
    http.Response source = await http.get(Uri.parse(
      'https://api.imgur.com/3/account/${myUser.accountUsername}'), 
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountBlocks() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/block'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}", 'Accept' : "application/vnd.api+json"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  // Future<ImgurResponse> accountBlocksCreate() async {
  //   http.Response source = await http.post(Uri.parse('https://api.imgur.com/account/v1/${myUser.accountUsername}/block'),
  //     headers: {'Authorization': "Bearer ${myUser.accessToken}", 'Accept' : "application/vnd.api+json"}
  //   );
  //   return ImgurResponse(json.decode(source.body));
  // }

  Future<ImgurResponse> accountSetting() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/settings'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }


  Future<ImgurResponse> accountImage() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/images'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountAvatar() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${myUser.accountUsername}/avatar'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountGalleryFavorites({int page = 0, bool sort = true}) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${myUser.accountUsername}/gallery_favorites/$page/$sort'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> accountFavorites({int page = 0, bool sort = true}) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${myUser.accountUsername}/favorites'),
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
  //   http.Response source = await http.post(Uri.parse('https://api.imgur.com/3/comment'), headers: {'Authorization': "Bearer ${myUser.accessToken}"});
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

  Future<ImgurResponse> getGallery({
      String section = "hot", /// hot | top | user
      String window = "day", /// day | week | month | year | all
      String sort = 'viral', /// viral | top | time | rising
      int page = 0,
      bool showViral = true,
      bool mature = true,
      bool albumPreviews = true
      }) async {

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

  Future<ImgurResponse> getGalleryImage(String galleryHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/gallery/image/$galleryHash'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> getTags() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/tags'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> getGalleryByTag(String tag, {
    int page = 0,
    String window = "day", /// day | week | month | year | all
    String sort = 'viral', /// viral | top | time | rising
  }) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/gallery/t/$tag/$sort/$window/$page'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> searchGallery(String tag, {
    int page = 0,
    String window = "day", /// day | week | month | year | all
    String sort = 'viral', /// viral | top | time | rising
  }) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/gallery/search/$sort/$window/$page?q=$tag'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> getVoteGallery(String galleryHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/gallery/$galleryHash/votes'),
      headers: {'Authorization': "Client-ID $_clientId"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> setVoteGallery(String galleryHash, {
    String vote = 'up', /// up | down | veto
  }) async {
    http.Response source = await http.post(Uri.parse('https://api.imgur.com/3/gallery/$galleryHash/vote/$vote'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}"}
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

  Future<ImgurResponse> favorite(String imageHash) async {
    http.Response source = await http.post(Uri.parse('https://api.imgur.com/3/image/$imageHash/favorite'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}"}
    );
    return ImgurResponse(json.decode(source.body));
  }

  Future<ImgurResponse> uploadImage(String imageHash, String title) async {
    http.Response source = await http.post(Uri.parse('https://api.imgur.com/3/upload'),
      headers: {'Authorization': "Bearer ${myUser.accessToken}"},
      body: {"image" : imageHash, "title":title}
    );
    return ImgurResponse(json.decode(source.body));
  }
}