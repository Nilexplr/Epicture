import 'dart:async';
import 'dart:convert' as prefix0;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:oauth2/oauth2.dart' as oauth2;

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

  authentificateClient(String refreshToken) async {
    var body = {"refresh_token": refreshToken, "client_id": _clientId, "client_secret": _clientSecret, "grant_type": "refresh_token"};
    http.Response request = await http.post(Uri.parse("https://api.imgur.com/oauth2/token"), body: body);
    _myUser = new User(json.decode(request.body));
  }

  /*********************
  ** ACCOUNT REQUEST **
  ********************/

  Future<Map<String, dynamic>> accountBase() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/{{username}}'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> accountBlocks() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/block'), headers: {'Authorization': "Bearer ${_myUser.accessToken}", 'Accept' : "application/vnd.api+json"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> accountBlocksCreate() async {
    http.Response source = await http.post(Uri.parse('https://api.imgur.com/account/v1/{{username}}/block'), headers: {'Authorization': "Bearer ${_myUser.accessToken}", 'Accept' : "application/vnd.api+json"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> accountSetting() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/settings'), headers: {'Authorization': "Bearer ${_myUser.accessToken}"});
    return json.decode(source.body);
  }


  Future<Map<String, dynamic>> accountImage() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/me/images'),headers: {'Authorization': "Bearer ${_myUser.accessToken}"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> accountAvatar() async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/${_myUser.accountUsername}/avatar'), headers: {'Authorization': "Bearer ${_myUser.accessToken}"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> accountGalleryFavorites(int page, bool sort) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/{{username}}/gallery_favorites/$page/$sort'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  /*********************
  ** COMMENT REQUEST ***
  *********************/

  // Future<Map<String, dynamic>> getComment(int commentID) async {
  //   http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/account/$commentID/gallery_favorites/$page/$sort'), headers: {'Authorization': "Client-ID $_clientId"});
  //   return json.decode(source.body);
  // }

  // Future<Map<String, dynamic>> createComment(String comment, int id, String key) async {
  //   var body = {
  //     "refresh_token": refreshToken,
  //     "client_id": _clientId,
  //     "client_secret": _clientSecret,
  //     "grant_type": "refresh_token"
  //   };
  //   http.Response source = await http.post(Uri.parse('https://api.imgur.com/3/comment'), headers: {'Authorization': "Bearer ${_myUser.accessToken}"});
  //   return json.decode(source.body);
  // }

  /*********************
  *** ALBUM REQUEST ****
  *********************/
  
  Future<Map<String, dynamic>> getAlbum(String albumHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/album/$albumHash'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> albumImages(String albumHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/album/$albumHash/images'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> albumImage(String albumHash, String imageHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/album/$albumHash/image/$imageHash'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  /*********************
  ** GALLERY REQUEST ***
  *********************/

  Future<Map<String, dynamic>> getGallery(String section, int window, int page, bool sort, bool showViral, bool mature, bool albumPreviews) async {
    http.Response source = await http.get(Uri.parse(
      'https://api.imgur.com/3/gallery/$section/$sort/$window/$page?showViral=$showViral&mature=$mature&album_previews=$albumPreviews'),
      headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  Future<Map<String, dynamic>> getGalleryAlbum(String galleryHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/gallery/album/$galleryHash'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

  /*********************
  *** IMAGE REQUEST ****
  *********************/
  
  Future<Map<String, dynamic>> getImage(String imageHash) async {
    http.Response source = await http.get(Uri.parse('https://api.imgur.com/3/image/$imageHash'), headers: {'Authorization': "Client-ID $_clientId"});
    return json.decode(source.body);
  }

}