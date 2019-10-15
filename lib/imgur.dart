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
  static HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  Imgur(this._clientId, this._clientSecret);

  authentificateClient(String refreshToken) async {
    var body = {"refresh_token": refreshToken, "client_id": _clientId, "client_secret": _clientSecret, "grant_type": "refresh_token"};
    http.Response request = await http.post(Uri.parse("https://api.imgur.com/oauth2/token"), body: body);
    // request.add(utf8.encode(json.encode(body)));
    // HttpClientResponse response = await request.close();
    print("bhbh");
    String toto = request.body;
    print(toto);
    client.close();
    return 0;
  }

}